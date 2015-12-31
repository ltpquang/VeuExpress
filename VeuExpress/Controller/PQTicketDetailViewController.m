//
//  PQTicketDetailViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/14/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQTicketDetailViewController.h"
#import "PQTicket.h"
#import "PQUser.h"
#import "PQThread.h"
#import "PQRequestingService.h"
#import "PQWebViewViewController.h"
#import "PQConversationDetailViewController.h"
#import "PQReplyTicketViewController.h"
#import "TicketAuthorTableViewCell.h"
#import "TicketDetailTableViewCell.h"
#import "TicketThreadTableViewCell.h"

@interface PQTicketDetailViewController ()

@property (nonatomic) PQTicket *ticket;
@property (nonatomic) PQRequestingService *requestService;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic) UIRefreshControl *loadingIndicator;
@property (nonatomic) UIBarButtonItem *replyButton;


@property (nonatomic) BOOL isLoading;
@property (nonatomic) NSURL *toPassUrl;
@end

@implementation PQTicketDetailViewController

#pragma mark Loading and config
- (void)configUsingTicket:(PQTicket *)ticket
     andRequestingService:(PQRequestingService *)requestService {
    _ticket = ticket;
    _requestService = requestService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self updateNavigationBar];
    [self configRefreshControl];
    [self refreshUserDetail];
    [self setupReplyButton];
}

- (void)configTableView {
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 20.0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateNavigationBar {
    self.title = _ticket.subject;
}

- (void)configRefreshControl {
    _loadingIndicator = [[UIRefreshControl alloc] init];
    [_mainTableView addSubview:_loadingIndicator];
    [_loadingIndicator addTarget:self action:@selector(refreshUserDetail) forControlEvents:UIControlEventValueChanged];
    [_loadingIndicator beginRefreshing];
    [self.mainTableView setContentOffset:CGPointMake(0, _mainTableView.contentOffset.y-_loadingIndicator.frame.size.height) animated:YES];
}

- (void)refreshUserDetail {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    [_replyButton setEnabled:NO];
    [_ticket downloadTicketDetailUsingRequestingService:_requestService
                                                success:^{
                                                    _ticket.threads = [[_ticket.threads reverseObjectEnumerator] allObjects];
                                                    [_mainTableView reloadData];
                                                    [self endLoadingUpdate];
                                                    [_replyButton setEnabled:YES];
                                                }
                                                failure:^(NSError *error) {
                                                    [_replyButton setEnabled:NO];
                                                    [self endLoadingUpdate];
                                                }];
}

- (void)setupReplyButton {
    _replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(reply)];
    [_replyButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = _replyButton;
}

- (void)endLoadingUpdate {
    _isLoading = NO;
    [_loadingIndicator endRefreshing];
}

#pragma mark Outlet actions

- (void)copiedTextToClipboard:(NSString *)toPaste {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:toPaste];
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:@"Hú"
                                                   message:@"Đã copy cho sếp"
                                                  delegate:self
                                         cancelButtonTitle:@"Ờ"
                                         otherButtonTitles:nil];
    [noti show];
}

- (void)call {
    NSString *number = [[_ticket.user.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)reply {
    //NSLog(@"Reply");
    [self performSegueWithIdentifier:@"GoToReplySegue" sender:self];
}

#pragma mark UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    //NSLog(@"handle url");
    _toPassUrl = URL;
    
    //[self performSegueWithIdentifier:@"OpenWebViewSegue" sender:self];
    [[UIApplication sharedApplication] openURL:URL];
    
    return NO;
}

#pragma mark Table view delegate and helpers


- (CGFloat)computeUserRowHeight {
    int topPadding = 0;
    int bottomPadding = 0;
    
    PQUser *user = _ticket.user;
    if (user == nil) {
        return 50;
    }
    
    CGSize nameSize = [user.name sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]}];
    CGSize emailSize = [user.email sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    CGSize phoneSize = [user.phone sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
 
    CGRect addressSize = [user.address boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                 context:nil];
    CGRect noteSize = [user.note boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                              context:nil];
    return topPadding
    + nameSize.height
    + 8
    + nameSize.height
    + emailSize.height
    + phoneSize.height
    + addressSize.size.height
    + noteSize.size.height
    + bottomPadding;
}


- (CGFloat)computeThreadRowHeightForThread:(PQThread *)thread {
    NSString *messageString = thread.content;
    if (messageString.length == 0) {
        return 50 + 30;
    }
    CGRect messageTextViewSize = [messageString boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                             context:nil];
    return messageTextViewSize.size.height + 30 + 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self computeUserRowHeight];
        }
        else {
            return _mainTableView.rowHeight;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 190;
        }
        else {
            return _mainTableView.rowHeight;
        }
    }
    else if (indexPath.section == 2) {
        return [self computeThreadRowHeightForThread:[_ticket.threads objectAtIndex:indexPath.row]];
    }
    return _mainTableView.rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"NGƯỜI MUA";
            break;
        case 1:
            return @"ĐƠN HÀNG";
            break;
        case 2:
            return @"CHUYỆN TRÒ LINH TINH™";
            break;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return [_ticket.threads count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *reuseId = @"TicketAuthorCell";
        TicketAuthorTableViewCell *cell = (TicketAuthorTableViewCell *)[_mainTableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[TicketAuthorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                       reuseIdentifier:reuseId];
        }
        [cell configCellUsingTicket:_ticket
                        andParentVC:self];
        return cell;
    }
    else if (indexPath.section == 1) {
        NSString *reuseId = @"TicketDetailCell";
        TicketDetailTableViewCell *cell = (TicketDetailTableViewCell *)[_mainTableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[TicketDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        [cell configTicketUsingLabel:_ticket];
        return cell;
    }
    else {
        NSString *reuseId = @"TicketThreadCell";
        TicketThreadTableViewCell *cell =  (TicketThreadTableViewCell *)[_mainTableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[TicketThreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        [cell configCellUsingThread:[_ticket.threads objectAtIndex:indexPath.row]
                        andParentVC:self];
        return cell;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier]  isEqual:@"OpenWebViewSegue"]) {
        PQWebViewViewController *vc = (PQWebViewViewController *)[segue destinationViewController];
        [vc configWebViewUrlWithUrl:_toPassUrl];
    }
    else if ([[segue identifier] isEqual:@"GoToReplySegue"]) {
        PQReplyTicketViewController *vc = (PQReplyTicketViewController *)[segue destinationViewController];
        [vc configUsingTicket:_ticket
            andRequestService:[_requestService instanceWithSameCookie]];
    }
}


@end
