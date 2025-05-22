//
//  MVViewController.m
//  OC_MarkdownView
//
//  Created by ximmyxiao on 05/22/2025.
//  Copyright (c) 2025 ximmyxiao. All rights reserved.
//

#import "MVViewController.h"
#import <OC_MarkdownView/MarkdownView.h>
@interface MVViewController ()

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MarkdownView *markdownView = [[MarkdownView alloc] initWithFrame:self.view.bounds];
    markdownView.markdownText = @"# Hello World\n\nThis is a Markdown text.\n\n- Item 1\n- Item 2\n- Item 3";
    [self.view addSubview:markdownView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
