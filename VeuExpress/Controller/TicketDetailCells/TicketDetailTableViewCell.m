//
//  TicketDetailTableViewCell.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "TicketDetailTableViewCell.h"
#import "PQTicket.h"

@interface TicketDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastResponseLabel;

@end

@implementation TicketDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configTicketUsingLabel:(PQTicket *)ticket {
    _idLabel.text = ticket.orderId;
    _statusLabel.text = ticket.status;
    _topicLabel.text = ticket.helpTopic;
    _createDateLabel.text = ticket.createDate;
    _dueDateLabel.text = ticket.dueDate;
    _lastMessageLabel.text = ticket.lastMessage;
    _lastResponseLabel.text = ticket.lastResponse;
}

@end
