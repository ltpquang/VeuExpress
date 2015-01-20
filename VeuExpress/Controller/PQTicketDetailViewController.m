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

@interface PQTicketDetailViewController ()

@property (nonatomic) PQTicket *ticket;
@property (nonatomic) PQRequestingService *requestService;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic) UIRefreshControl *loadingIndicator;

@property (weak, nonatomic) IBOutlet UIButton *getInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNoteLabel;

@property (weak, nonatomic) IBOutlet UILabel *ticketIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketHelpTopicLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCreateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketDueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketLastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketLastResponseLabel;

@property (weak, nonatomic) IBOutlet UITextView *firstMessageTextView;

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
    [self updateUserDetail];
    [self updateNavigationBar];
    [self configRefreshControl];
    [self refreshUserDetail];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUserDetail {
    _userNameLabel.text = _ticket.user.name;
    _userEmailLabel.text = _ticket.user.email;
    _userPhoneNumberLabel.text = _ticket.user.phone;
    _userAddressLabel.text = _ticket.user.address;
    _userNoteLabel.text = _ticket.user.note;
    
    _ticketIdLabel.text = _ticket.orderId;
    _ticketStatusLabel.text = _ticket.status;
    _ticketHelpTopicLabel.text = _ticket.helpTopic;
    _ticketCreateDateLabel.text = _ticket.createDate;
    _ticketDueDateLabel.text = _ticket.dueDate;
    _ticketLastMessageLabel.text = _ticket.lastMessage;
    _ticketLastResponseLabel.text = _ticket.lastResponse;
    
    //_firstMessageTextView.attributedText = ((PQThread *)[_ticket.threads objectAtIndex:0]).content;
    _firstMessageTextView.text = ((PQThread *)[_ticket.threads objectAtIndex:0]).content;
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
    [_ticket downloadTicketDetailUsingRequestingService:_requestService
                                                success:^{
                                                    [self updateUserDetail];
                                                    [self configOtherControls];
                                                    [_mainTableView reloadData];
                                                    //[self enableButtons];
                                                    [self endLoadingUpdate];
                                                }
                                                failure:^(NSError *error) {
                                                    [self endLoadingUpdate];
                                                }];
}

- (void)configLabelForWordWrapping:(UILabel *)label {
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [label sizeToFit];
}

- (void)configOtherControls {
    [self configLabelForWordWrapping:_userAddressLabel];
    [self configLabelForWordWrapping:_userNoteLabel];
}

- (void)enableButtons {
    _getInfoButton.hidden = NO;
    _callButton.hidden = NO;
}

- (void)endLoadingUpdate {
    _isLoading = NO;
    [_loadingIndicator endRefreshing];
}

#pragma mark Outlet actions
- (IBAction)getInfoButton:(id)sender {
    NSString *toPaste = [NSString stringWithFormat:@"%@\n%@\n%@",
                         _ticket.user.name,
                         _ticket.user.phone,
                         _ticket.user.address];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:toPaste];
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:@"Hú"
                                                   message:@"Đã copy cho sếp"
                                                  delegate:self
                                         cancelButtonTitle:@"Ờ"
                                         otherButtonTitles:nil];
    [noti show];
}

- (IBAction)callButtonTUI:(id)sender {
    NSString *number = [[_ticket.user.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)copyMessageButtonTUI:(id)sender {
    NSString *toPaste = _firstMessageTextView.text;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:toPaste];
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:@"Hú"
                                                   message:@"Đã copy cho sếp"
                                                  delegate:self
                                         cancelButtonTitle:@"Ờ"
                                         otherButtonTitles:nil];
    [noti show];
}

- (IBAction)seeFullConversationButtonTUI:(id)sender {
    [self performSegueWithIdentifier:@"GoToConversationDetailSegue" sender:self];
}


#pragma mark UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    //NSLog(@"handle url");
    _toPassUrl = URL;
    
    [self performSegueWithIdentifier:@"OpenWebViewSegue" sender:self];
    
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
    
    CGSize nameSize = [user.name sizeWithAttributes:@{NSFontAttributeName:_userNameLabel.font}];
    CGSize emailSize = [user.email sizeWithAttributes:@{NSFontAttributeName:_userEmailLabel.font}];
    CGSize phoneSize = [user.phone sizeWithAttributes:@{NSFontAttributeName:_userPhoneNumberLabel.font}];
    CGRect addressSize = [user.address boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:_userAddressLabel.font}
                                                 context:nil];
    CGRect noteSize = [user.note boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:_userNoteLabel.font}
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

- (CGFloat)computeFirstMessageRowHeight {
    PQThread *firstMessage = [_ticket.threads objectAtIndex:0];
    NSString *messageContentAttString = firstMessage.content;
    if (messageContentAttString.length == 0) {
        return 50 + 30;
    }
    CGRect messageTextViewSize = [messageContentAttString boundingRectWithSize:CGSizeMake(292, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_firstMessageTextView.font} context:nil];
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
        if (indexPath.row == 0) {
            return [self computeFirstMessageRowHeight];
        }
    }
    return _mainTableView.rowHeight;
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
    else if ([[segue identifier] isEqual:@"GoToConversationDetailSegue"]) {
        PQConversationDetailViewController *vc = (PQConversationDetailViewController *)[segue destinationViewController];
        [vc configThreads:_ticket.threads
        andRequestService:[_requestService instanceWithSameCookie]];
    }
}


@end
