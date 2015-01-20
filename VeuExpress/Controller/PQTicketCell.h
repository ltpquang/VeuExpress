//
//  PQTicketCell.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/5/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PQTicket;

@interface PQTicketCell : UITableViewCell
- (void)setupCellContentWithTicket:(PQTicket *)ticket;
@end
