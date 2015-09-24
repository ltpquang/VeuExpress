//
//  TicketThreadTableViewCell.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PQThread;
@class PQTicketDetailViewController;

@interface TicketThreadTableViewCell : UITableViewCell
- (void)configCellUsingThread:(PQThread *)thread
                  andParentVC:(PQTicketDetailViewController *)parentVC;
@end
