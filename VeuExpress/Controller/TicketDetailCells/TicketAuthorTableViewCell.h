//
//  TicketAuthorTableViewCell.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PQTicket;
@class PQTicketDetailViewController;

@interface TicketAuthorTableViewCell : UITableViewCell
- (void)configCellUsingTicket:(PQTicket *)ticket
                  andParentVC:(PQTicketDetailViewController *)parentVC;
@end
