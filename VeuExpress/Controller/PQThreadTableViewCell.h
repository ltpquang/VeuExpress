//
//  PQThreadTableViewCell.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/18/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PQThread;
@class PQConversationDetailViewController;

@interface PQThreadTableViewCell : UITableViewCell <UITextViewDelegate>
- (void)configCellUsingThread:(PQThread *)thread andParentViewController:(PQConversationDetailViewController *)parentVC;
@end
