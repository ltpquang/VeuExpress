//
//  TicketDetailTableViewCell.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PQTicket;

@interface TicketDetailTableViewCell : UITableViewCell
- (void)configTicketUsingLabel:(PQTicket *)ticket;
@end
