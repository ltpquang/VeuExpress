//
//  PQTicketListViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/1/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQTicketListViewController.h"
#import "PQAuthenticatingService.h"
#import "PQTicketTableViewViewController.h"
#import "TicketViewTypeEnum.h"
#import "PQRequestingService.h"
#import "PQTicketDetailViewController.h"

@interface PQTicketListViewController ()

@property NSArray *tableViewVCArray;
@property UIViewController *currentTableViewVC;
@property (weak, nonatomic) IBOutlet UIView *containingView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) BOOL setupDone;

@end

@implementation PQTicketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    if (_setupDone == NO) {
        [self childViewControllerFirstTimeSetup];
    }
}

- (void)viewDidLayoutSubviews {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)childViewControllerFirstTimeSetup {
    _tableViewVCArray = @[
                          [[self.storyboard instantiateViewControllerWithIdentifier:@"TicketTableView"] withRequestService:[_requestService instanceWithSameCookie]
                                                                                                                   andType:TicketTypeOpen],
                          [[self.storyboard instantiateViewControllerWithIdentifier:@"TicketTableView"] withRequestService:[_requestService instanceWithSameCookie]
                                                                                                                   andType:TicketTypeAnswered],
                          [[self.storyboard instantiateViewControllerWithIdentifier:@"TicketTableView"] withRequestService:[_requestService instanceWithSameCookie]
                                                                                                                   andType:TicketTypeAssigned],
                          [[self.storyboard instantiateViewControllerWithIdentifier:@"TicketTableView"] withRequestService:[_requestService instanceWithSameCookie]
                                                                                                                   andType:TicketTypeOverdue],
                          [[self.storyboard instantiateViewControllerWithIdentifier:@"TicketTableView"] withRequestService:[_requestService instanceWithSameCookie]
                                                                                                                   andType:TicketTypeClosed]
                          ];
    [self presentTableViewVC:[_tableViewVCArray objectAtIndex:0]];
    _setupDone = true;
}

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = fromViewController.view.bounds;                           //  1
    [self addChildViewController:toViewController];                                     //
    [fromViewController willMoveToParentViewController:nil];                            //
    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0.4
                               options:UIViewAnimationOptionTransitionNone
                            animations:nil
                            completion:^(BOOL finished) {
                                [toViewController didMoveToParentViewController:self];  //  2
                                [fromViewController removeFromParentViewController];    //  3
                                _currentTableViewVC = (UIViewController *)toViewController;
                            }];
}

- (void)presentTableViewVC:(UIViewController *)tableViewVC {
    if (_currentTableViewVC) {
        [self removeCurrentTableViewVC];
    }
    
    [self addChildViewController:tableViewVC];
    
    [tableViewVC.view setFrame:[self frameForTableViewVC]];
    [self.view addSubview:tableViewVC.view];
    _currentTableViewVC = tableViewVC;
    
    [tableViewVC didMoveToParentViewController:self];
}

- (void)removeCurrentTableViewVC {
    [_currentTableViewVC willMoveToParentViewController:nil];
    [_currentTableViewVC.view removeFromSuperview];
    [_currentTableViewVC removeFromParentViewController];
}

- (CGRect)frameForTableViewVC {
    return self.view.bounds;
}

- (IBAction)segmentedValueChanged:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0: //open
            [self transitionFromViewController:_currentTableViewVC
                              toViewController:[_tableViewVCArray objectAtIndex:0]];
            break;
        case 1: //answered
            [self transitionFromViewController:_currentTableViewVC
                              toViewController:[_tableViewVCArray objectAtIndex:1]];
            break;
        case 2: //assigned
            [self transitionFromViewController:_currentTableViewVC
                              toViewController:[_tableViewVCArray objectAtIndex:2]];
            break;
        case 3: //overdue
            [self transitionFromViewController:_currentTableViewVC
                              toViewController:[_tableViewVCArray objectAtIndex:3]];
            break;
        case 4: //closed
            [self transitionFromViewController:_currentTableViewVC
                              toViewController:[_tableViewVCArray objectAtIndex:4]];
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual: @"GoToTicketDetailSegue"]) {
        PQTicketDetailViewController *toVC = (PQTicketDetailViewController *)[segue destinationViewController];
        [(PQTicketTableViewViewController *)self.currentTableViewVC configTicketDetailViewController:toVC];
    }
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
