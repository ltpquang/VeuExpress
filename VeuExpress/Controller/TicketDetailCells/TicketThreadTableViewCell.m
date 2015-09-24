//
//  TicketThreadTableViewCell.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "TicketThreadTableViewCell.h"
#import "PQTicketDetailViewController.h"
#import "PQThread.h"

@interface TicketThreadTableViewCell()
@property (nonatomic) PQTicketDetailViewController *parentVC;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation TicketThreadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellUsingThread:(PQThread *)thread
                  andParentVC:(PQTicketDetailViewController *)parentVC {
    _authorLabel.text = thread.author;
    _dateLabel.text = thread.date;
    _contentTextView.text = thread.content;
    
    _parentVC = parentVC;
    
    _contentTextView.delegate = _parentVC;
}

- (IBAction)copyContentButtonTUI:(id)sender {
    [_parentVC copiedTextToClipboard:_contentTextView.text];
}

@end
