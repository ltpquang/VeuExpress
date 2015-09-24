//
//  PQTicketDetailViewController.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/14/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PQTicket;
@class PQRequestingService;

@interface PQTicketDetailViewController : UITableViewController <UITextViewDelegate>
- (void)configUsingTicket:(PQTicket *)ticket
     andRequestingService:(PQRequestingService *)requestService;
- (void)copiedTextToClipboard:(NSString *)toPaste;
- (void)call;
@end
