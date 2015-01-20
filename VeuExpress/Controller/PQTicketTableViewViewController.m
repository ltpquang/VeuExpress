//
//  PQTicketTableViewViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/2/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQTicketTableViewViewController.h"
#import "PQTicketCell.h"
#import "PQRequestingService.h"
#import "PQTicketDetailViewController.h"

@interface PQTicketTableViewViewController ()
@property (nonatomic) TicketTypeEnum ticketType;
@property (nonatomic) PQRequestingService *requestService;
@property (nonatomic) NSMutableArray *tickets;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic) UIRefreshControl *loadingIndicator;
@property (nonatomic) UIActivityIndicatorView *loadMoreIndicator;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) int selectedTicketIndex;
@end

@implementation PQTicketTableViewViewController

- (id)withRequestService:(PQRequestingService *)requestService
                 andType:(TicketTypeEnum)ticketType {
    _requestService = requestService;
    _ticketType = ticketType;
    [_requestService setTicketType:ticketType];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tickets = [[NSMutableArray alloc] init];
    
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ([_tickets count] == 0) {
        [self loadData];
        [self setupLoadingIndicator];
        [self initFooterView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLoadingIndicator {
    _loadingIndicator = [[UIRefreshControl alloc] init];
    [_mainTableView addSubview:_loadingIndicator];
    [_loadingIndicator addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_loadingIndicator beginRefreshing];
    [self.mainTableView setContentOffset:CGPointMake(0, _mainTableView.contentOffset.y-_loadingIndicator.frame.size.height) animated:YES];
}

-(void)initFooterView
{
    _loadMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_loadMoreIndicator stopAnimating];
    _loadMoreIndicator.hidesWhenStopped = YES;
    _loadMoreIndicator.frame = CGRectMake(0, 0, 320, 44);
    //_mainTableView.tableFooterView = _loadMoreIndicator;
}

- (void)loadData {
    _isLoading = YES;
    [_requestService downloadTicketsWithSuccess:^(NSArray *resultArray) {
        [_tickets addObjectsFromArray:resultArray];
        [_mainTableView reloadData];
        [_loadingIndicator endRefreshing];
        [_loadMoreIndicator stopAnimating];
        _isLoading = NO;
    }
                                        failure:^(NSError *error) {
                                            
                                            [_loadingIndicator endRefreshing];
                                            [_loadMoreIndicator stopAnimating];
                                            _isLoading = NO;
                                        }];
}

- (void)refresh {
    _isLoading = YES;
    [_requestService reset];
    [_requestService downloadTicketsWithSuccess:^(NSArray *resultArray) {
        [_tickets removeAllObjects];
        [_tickets addObjectsFromArray:resultArray];
        [_mainTableView reloadData];
        [_loadingIndicator endRefreshing];
        _isLoading = NO;
    }
                                        failure:^(NSError *error) {
                                            
                                            [_loadingIndicator endRefreshing];
                                            _isLoading = NO;
                                        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PQTicketCell *cell = (PQTicketCell *)[tableView dequeueReusableCellWithIdentifier:@"TicketCell" forIndexPath:indexPath];
    [cell setupCellContentWithTicket:[_tickets objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedTicketIndex = indexPath.row;
    [self.parentViewController performSegueWithIdentifier:@"GoToTicketDetailSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tickets count];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    BOOL endOfTable = (scrollView.contentOffset.y >= ((_tickets.count * 70) - scrollView.frame.size.height)); // Here 40 is row height
    if (endOfTable) {
        NSLog(@"eot");
    }
    if (!_requestService.isMaxPageReached && endOfTable && !_isLoading && !scrollView.dragging && !scrollView.decelerating)
    {
        _mainTableView.tableFooterView = _loadMoreIndicator;
        [self loadData];
        [_loadMoreIndicator startAnimating];
    }
    
}

- (void)configTicketDetailViewController:(PQTicketDetailViewController *)toVC {
    [toVC configUsingTicket:[_tickets objectAtIndex:_selectedTicketIndex]
       andRequestingService:[_requestService instanceWithSameCookie]];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([[segue identifier] isEqual: @"GoToTicketDetailSegue"]) {
         PQTicketDetailViewController *toVC = (PQTicketDetailViewController *)[segue destinationViewController];
         [toVC configUsingTicket:[_tickets objectAtIndex:_selectedTicketIndex]
            andRequestingService:[_requestService instanceWithSameCookie]];
     }
 }


@end
