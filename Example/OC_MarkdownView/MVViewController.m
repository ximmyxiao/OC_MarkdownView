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
- (void)dealloc
{
    NSLog(@"MVViewController dealloc");
}

- (void)testMK
{

    NSURL* url = [[NSBundle mainBundle] URLForResource:self.markdownContentType withExtension:@"txt"];
    NSString* markdown = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];

    SSEContentViewModel* viewModel = [[SSEContentViewModel alloc] init];
    viewModel.thought = @"";
    viewModel.reply = markdown;
    self.viewModel = viewModel;
}


- (void)testSSE
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"SSE" withExtension:@"txt"];
    NSString* markdown = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary* dataDic  = [NSJSONSerialization JSONObjectWithData:[markdown dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    
    __block NSInteger i = 0;
    __weak typeof(self) weakSelf = self;
    
    void (^processNextChunk)(void) = ^{
        if (i < 10) {
            NSString* eventType = dataDic[@"type"];
            if ([eventType isKindOfClass:[NSString class]]) {
                NSDictionary* payloadDic = dataDic[@"payload"];
                if ([payloadDic isKindOfClass:[NSDictionary class]]) {
                    if ([eventType isEqualToString:@"thought"]) {
                        NSArray* procedures = payloadDic[@"procedures"];
                        if ([procedures isKindOfClass:[NSArray class]]) {
                            NSDictionary* procedureDic = [procedures firstObject];

                            NSString* thought = procedureDic[@"debugging"][@"content"];
                            weakSelf.thought = thought;
                            //                        NSLog(@"thought: %@", thought);
                        }
                    } else if ([eventType isEqualToString:@"reply"]) {
                        NSString* replyContent = payloadDic[@"content"];
                        NSInteger wholeLength = [replyContent length];
                        NSLog(@"processNextChunk wholeLength : %ld", wholeLength);
                        NSInteger pageSize = ceil(wholeLength/10.0);
                        // calculate the range for the current chunk
                        NSRange range = NSMakeRange(0, i*pageSize + MIN(pageSize, wholeLength - i * pageSize));
                        NSLog(@"processNextChunk range : %@", NSStringFromRange(range));
                        weakSelf.reply = [replyContent substringWithRange:range];
                        NSLog(@"processNextChunk reply content : %@", self.reply);
                    }

                    SSEContentViewModel* viewModel = [[SSEContentViewModel alloc] init];
                    viewModel.thought = weakSelf.thought;
                    viewModel.reply = weakSelf.reply;
                    weakSelf.viewModel = viewModel;
                }
            }
            i++;

        }
    };

    // 创建 timer，每隔 0.5 秒触发一次
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        processNextChunk(); // 执行 block
        
        if (i >= 10) {
            [timer invalidate]; // 调用 10 次后停止
        }
    }];
    
    [timer fire];
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SSECell" bundle:nil] forCellReuseIdentifier:@"SSECell"];
    if ([self.markdownContentType isEqualToString:@"SSE"]) {
        [self testSSE];
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

//        if (timeSinceLastCall < threshold) {
//            NSLog(@"processNextChunk reload is discard due to frequency limit");
//            return;
//        }

//        if (self.pendingBlock != nil) {
//            NSLog(@"processNextChunk reload is discard");
//            return;
//        }
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
