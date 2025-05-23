//
//  MVViewController.m
//  OC_MarkdownView
//
//  Created by ximmyxiao on 05/22/2025.
//  Copyright (c) 2025 ximmyxiao. All rights reserved.
//

#import "MVViewController.h"
#import <OC_MarkdownView/MarkdownView.h>
#import "SSECell.h"
#import <libcmark_gfm/libcmark_gfm.h>

@interface MVViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableData* receivedData;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSString* thought;
@property (nonatomic, strong) NSString* reply;
@property (nonatomic, strong) SSEContentViewModel* viewModel;
@property (nonatomic, strong) NSDate* lastCallTime; // 记录最后一次触发时间
@property (nonatomic, strong) dispatch_block_t pendingBlock; // 待执行的 block
@end

@implementation MVViewController

- (void)testMK
{

    NSURL* url = [[NSBundle mainBundle] URLForResource:self.markdownContentType withExtension:@"txt"];
    NSString* markdown = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];

    SSEContentViewModel* viewModel = [[SSEContentViewModel alloc] init];
    viewModel.thought = @"";
    viewModel.reply = markdown;
    self.viewModel = viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SSECell" bundle:nil] forCellReuseIdentifier:@"SSECell"];
    if ([self.markdownContentType isEqualToString:@"SSE"]) {
        [self sendRequest];
        [self testMK];
    } else {
        [self testMK];
    }
}

- (void)processJSON:(NSDictionary*)json
{
    // 处理 JSON 数据
    NSDictionary* dataDic = json[@"data"];
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        NSString* eventType = dataDic[@"type"];
        if ([eventType isKindOfClass:[NSString class]]) {
            NSDictionary* payloadDic = dataDic[@"payload"];
            if ([payloadDic isKindOfClass:[NSDictionary class]]) {
                if ([eventType isEqualToString:@"thought"]) {
                    NSArray* procedures = payloadDic[@"procedures"];
                    if ([procedures isKindOfClass:[NSArray class]]) {
                        NSDictionary* procedureDic = [procedures firstObject];

                        NSString* thought = procedureDic[@"debugging"][@"content"];
                        self.thought = thought;
                        //                        NSLog(@"thought: %@", thought);
                    }
                } else if ([eventType isEqualToString:@"reply"]) {
                    self.reply = payloadDic[@"content"];
                    NSLog(@"reply content : %@", self.reply);
                }

                SSEContentViewModel* viewModel = [[SSEContentViewModel alloc] init];
                viewModel.thought = self.thought;
                viewModel.reply = self.reply;
                self.viewModel = viewModel;
            }
        }
    }
}

- (void)setViewModel:(SSEContentViewModel*)viewModel
{
    if ([self.markdownContentType isEqualToString:@"SSE"]) {
        CGFloat threshold = 0.05;
        // limit the frequency of calling reloadData
        NSDate* now = [NSDate date];
        NSTimeInterval timeSinceLastCall = [now timeIntervalSinceDate:self.lastCallTime];

        if (timeSinceLastCall < threshold) {
            return;
        }

        if (self.pendingBlock != nil) {
            return;
        }
        _viewModel = viewModel;

        self.lastCallTime = now;

        __weak typeof(self) weakSelf = self;
        dispatch_block_t block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
            NSLog(@"reloadData");
            [weakSelf.tableView reloadData];
            weakSelf.pendingBlock = nil;
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });

        self.pendingBlock = block;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(threshold * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    } else {
        _viewModel = viewModel;
        [self.tableView reloadData];
    }
}
- (void)sendRequest
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://wss.lke.cloud.tencent.com/v1/qbot/chat/sse"]];
    [request setAllHTTPHeaderFields:@{
        @"Content-Type" : @"application/json",
        @"Accept" : @"text/event-stream"
    }];
    NSData* postData = [[NSData alloc] initWithData:[@"{\n    \"content\": \"你可以回答哪些问题\",\n    \"bot_app_key\": \"yourkey\",\n    \"visitor_biz_id\": \"yourid\",\n    \"session_id\": \"test\"\n}" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];

    [request setHTTPMethod:@"POST"];

    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession*)session dataTask:(NSURLSessionDataTask*)dataTask didReceiveData:(NSData*)data
{
    // 逐块追加数据
    if (!self.receivedData) {
        self.receivedData = [NSMutableData data];
    }

    [self.receivedData appendData:data];

    NSString* receivedString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSArray* allResults = [receivedString componentsSeparatedByString:@"\n\n"];
    if ([allResults count] > 3) {
        NSString* secondlastResult = [allResults objectAtIndex:[allResults count] - 3];
        NSArray* lines = [secondlastResult componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if ([lines count] >= 2) {
            NSString* content = [lines objectAtIndex:1];
            if ([content hasPrefix:@"data:"]) {
                content = [content stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"\"data\":"];
            }
            NSString* jsonString = [NSString stringWithFormat:@"{%@}", content];
            NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            [self processJSON:json];
        }
    }
}

- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error
{
    if (error) {
        NSLog(@"Request failed: %@", error);
    } else {
        // 全部数据接收完成
        NSString* receivedString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"final string:%@", receivedString);
        NSLog(@"Final data: %@", self.receivedData);
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.viewModel isKindOfClass:[SSEContentViewModel class]]) {
        return 1;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SSECell* cell = [tableView dequeueReusableCellWithIdentifier:@"SSECell" forIndexPath:indexPath];
    cell.viewModel = self.viewModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.tableView reloadData];
}

@end
