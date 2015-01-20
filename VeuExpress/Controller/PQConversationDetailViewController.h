//
//  PQConversationDetailViewController.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/18/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PQThread;
@class PQRequestingService;

@interface PQConversationDetailViewController : UITableViewController
- (void)configThreads:(NSArray *)threads
    andRequestService:(PQRequestingService *)requestService;
- (void)openWebViewWithUrl:(NSURL *)URL;
@end
