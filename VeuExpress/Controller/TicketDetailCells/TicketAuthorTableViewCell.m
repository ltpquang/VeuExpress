//
//  TicketAuthorTableViewCell.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "TicketAuthorTableViewCell.h"
#import "PQTicket.h"
#import "PQUser.h"
#import "PQTicketDetailViewController.h"

@interface TicketAuthorTableViewCell()
@property (nonatomic) PQTicketDetailViewController *parentVC;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation TicketAuthorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self configLabelForWordWrapping:_addressLabel];
    [self configLabelForWordWrapping:_noteLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configLabelForWordWrapping:(UILabel *)label {
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [label sizeToFit];
}

- (void)configCellUsingTicket:(PQTicket *)ticket
                  andParentVC:(PQTicketDetailViewController *)parentVC {
    _nameLabel.text = ticket.user.name;
    _emailLabel.text = ticket.user.email;
    _phoneLabel.text = ticket.user.phone;
    _addressLabel.text = ticket.user.address;
    _noteLabel.text = ticket.user.note;
    
    _parentVC = parentVC;
}

- (IBAction)copyInfoButtonTUI:(id)sender {
    NSString *toPaste = [NSString stringWithFormat:@"%@\n%@\n%@",
                         _nameLabel.text,
                         _phoneLabel.text,
                         _addressLabel.text];
    [_parentVC copiedTextToClipboard:toPaste];
}

- (IBAction)callButtonTUI:(id)sender {
    [_parentVC call];
}

@end
