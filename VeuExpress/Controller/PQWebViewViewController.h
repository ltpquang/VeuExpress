//
//  PQWebViewViewController.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/17/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PQWebViewViewController : UIViewController <UIWebViewDelegate>
- (void)configWebViewUrlWithUrl:(NSURL *)url;
@end
