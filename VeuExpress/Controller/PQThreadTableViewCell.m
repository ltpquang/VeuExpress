//
//  PQThreadTableViewCell.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/18/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQThreadTableViewCell.h"
#import "PQThread.h"
#import "PQConversationDetailViewController.h"

@interface PQThreadTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property PQConversationDetailViewController *parentVC;
@end

@implementation PQThreadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellUsingThread:(PQThread *)thread andParentViewController:(PQConversationDetailViewController *)parentVC {
    _nameLabel.text = thread.author;
    _dateLabel.text = thread.date;
    _contentTextView.text = thread.content;
    _contentTextView.delegate = self;
    
    _parentVC = parentVC;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    [_parentVC openWebViewWithUrl:URL];
    return NO;
}
@end
