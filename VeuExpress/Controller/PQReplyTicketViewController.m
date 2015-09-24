//
//  PQReplyTicketViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/20/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQReplyTicketViewController.h"
#import "PQRequestingService.h"
#import "PQTicket.h"
#import <QuartzCore/QuartzCore.h>

@interface PQReplyTicketViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (nonatomic) PQRequestingService *requestService;
@property (nonatomic) PQTicket *ticket;
@property (nonatomic) NSString *replyTemplate;
@property (nonatomic) NSString *replyMessage;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *useTemplateSwitch;

@property (nonatomic) UIBarButtonItem *indicatorItem;
@property (nonatomic) UIActivityIndicatorView *indicatorView;

@property (nonatomic) UIRefreshControl *loadingIndicator;

@property (nonatomic) UIBarButtonItem *postButton;
@end

@implementation PQReplyTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTextView];
    [self configInputViews];
    [self configUseTemplateSwitch];
    [self setupSendButton];
    [self downloadMessageTemplate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUsingTicket:(PQTicket *)ticket
        andRequestService:(PQRequestingService *)requestService {
    _ticket = ticket;
    _requestService = requestService;
}

- (void)configTextView {
    [_messageTextView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [_messageTextView.layer setBorderWidth:0.5];
    
    //The rounded corner part, where you specify your view's corner radius:
    _messageTextView.layer.cornerRadius = 5;
    _messageTextView.clipsToBounds = YES;
}

- (void)configInputViews {
    [_messageTextView setUserInteractionEnabled:YES];
    [_priceTextField setUserInteractionEnabled:NO];
}

- (void)configUseTemplateSwitch {
    [_useTemplateSwitch setEnabled:NO];
}

- (void)setupSendButton {
    _postButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(postMessage)];
    //self.navigationItem.rightBarButtonItem = _postButton;
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView startAnimating];
    [_indicatorView setHidden:NO];
    _indicatorItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
    self.navigationItem.rightBarButtonItem = _postButton;
    }

- (void)configViewBeforePosting {
    self.navigationItem.rightBarButtonItem = _indicatorItem;
}

- (void)configViewAfterPosting {
    self.navigationItem.rightBarButtonItem = _postButton;
}

- (void)configRefreshControl {
    _loadingIndicator = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_loadingIndicator];
    [_loadingIndicator addTarget:self action:@selector(downloadMessageTemplate) forControlEvents:UIControlEventValueChanged];
    [_loadingIndicator beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-_loadingIndicator.frame.size.height) animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)switchValueChanged:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (sw.isOn) {
        [_messageTextView setUserInteractionEnabled:NO];
        [_priceTextField setUserInteractionEnabled:YES];
    }
    else {
        [_messageTextView setUserInteractionEnabled:YES];
        [_priceTextField setUserInteractionEnabled:NO];
    }
}


- (void)downloadMessageTemplate {
    [_requestService downloadTicketReplyContentWithTicketId:_ticket.ticketId
                                                    success:^(NSString *resultContent) {
                                                        _replyTemplate = resultContent;
                                                        NSLog(@"Downloaded");
                                                        [_useTemplateSwitch setEnabled:YES];
                                                    }
                                                    failure:^(NSError *error) {
                                                        //
                                                    }];
}

- (void)postMessage {
    [self configViewBeforePosting];
    NSString *message = [[NSString alloc] init];
    if ([_useTemplateSwitch isOn]) {
        NSString *price = _priceTextField.text;
        self.replyTemplate = [self.replyTemplate stringByReplacingOccurrencesOfString:@"###"
                                                            withString:price];
    }
    else {
        message = _messageTextView.text;
    }
    [_ticket postReplyWithMessage:message
           usingRequestingService:_requestService
                          success:^{
                              [self configViewAfterPosting];
                              UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Yep!"
                                                                           message:@"Anh hả, em vừa post rồi nha :adore:"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Okay"
                                                                 otherButtonTitles:nil];
                              [al show];
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                          failure:^(NSError *error) {
                              [self configViewAfterPosting];
                              UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                           message:@"Chả hiểu sao không post được anh ạ :'( thử lại xem sao"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Okay"
                                                                 otherButtonTitles:nil];
                              [al show];
                          }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect messageTextViewSize = [_messageTextView.text boundingRectWithSize:CGSizeMake(292, MAXFLOAT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                             context:nil];
    if (messageTextViewSize.size.height > 170) {
        return messageTextViewSize.size.height + 115 + 34;
    }
    return 320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _contentCell;
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
