//
//  SSECell.m
//  testSSE
//
//  Created by ximmy on 2025/2/26.
//

#import "SSECell.h"
#import "MarkdownView.h"

@interface SSECell ()
@property (weak, nonatomic) IBOutlet MarkdownView* markdownView;
@property (weak, nonatomic) IBOutlet UILabel* thoughtLabel;

@end

@implementation SSECell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.thoughtLabel.numberOfLines = 0;
    self.thoughtLabel.backgroundColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(SSEContentViewModel*)viewModel
{
    _viewModel = viewModel;
    self.thoughtLabel.text = viewModel.thought;

    [self.markdownView setMarkdownText:viewModel.reply];
}

@end
