//
//  PQTicketTableViewViewController.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/2/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketViewTypeEnum.h"
@class PQRequestingService;
@class PQTicketDetailViewController;

@interface PQTicketTableViewViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate>

- (id)withRequestService:(PQRequestingService *)requestService
                 andType:(TicketTypeEnum)ticketType;
- (void)configTicketDetailViewController:(PQTicketDetailViewController *)toVC;
@end
