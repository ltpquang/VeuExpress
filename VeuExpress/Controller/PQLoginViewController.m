//
//  PQLoginViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/30/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQLoginViewController.h"
#import "PQAuthenticatingService.h"
#import "PQTicketListViewController.h"
#import "PQRequestingService.h"

@interface PQLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, retain) PQAuthenticatingService *authService;

@end

@implementation PQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _authService = [[PQAuthenticatingService alloc] init];
    // Do any additional setup after loading the view.
    //[self loginButtonTUI:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchToWaitingState
{
    [_loadingIndicator startAnimating];
    [_loginButton setEnabled:NO];
}

- (void)switchToNonWaitingState
{
    [_loadingIndicator stopAnimating];
    [_loginButton setEnabled:YES];
}

- (IBAction)loginButtonTUI:(id)sender {
    
    [self performSelectorOnMainThread:@selector(switchToWaitingState)
                           withObject:nil
                        waitUntilDone:NO];
    
    NSString *userid = _userIdTextField.text;
    NSString *passwd = _passwdTextField.text;
    
    [_authService loginWithUserId:userid
                      andPassword:passwd
                          success:^{
                              NSLog(@"Logged in");
                              [self performSelectorOnMainThread:@selector(switchToNonWaitingState)
                                                     withObject:nil
                                                  waitUntilDone:NO];
                              
                              [self performSegueWithIdentifier:@"NavigateToTicketListSegue" sender:nil];
                          }
                          failure:^(NSError *error){
                              NSLog(@"%@", error);
                          }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"NavigateToTicketListSegue"]) {
        
        UINavigationController *navVC = [segue destinationViewController];
        PQTicketListViewController *ticketListVC = (PQTicketListViewController *)navVC.topViewController;
        
        ticketListVC.requestService = [_authService pqRequestingServiceInstance];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
