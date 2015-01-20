//
//  PQReplyTicketViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQReplyTicketViewController.h"
#import "PQRequestingService.h"

@interface PQReplyTicketViewController ()
@property (nonatomic) PQRequestingService *requestService;
@end

@implementation PQReplyTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)postButtonTUI:(id)sender {
    //
}

- (IBAction)cancelButtonTUI:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
