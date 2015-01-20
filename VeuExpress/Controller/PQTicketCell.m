//
//  PQTicketCell.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/5/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQTicketCell.h"
#import "PQTicket.h"

@interface PQTicketCell()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation PQTicketCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellContentWithTicket:(PQTicket *)ticket {
    _orderIdLabel.text = ticket.orderId;
    _dateLabel.text = ticket.date;
    _subjectLabel.text = ticket.subject;
    _authorLabel.text = ticket.author;
}

@end
