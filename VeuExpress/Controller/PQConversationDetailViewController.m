//
//  PQConversationDetailViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/18/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQConversationDetailViewController.h"
#import "PQThreadTableViewCell.h"
#import "PQWebViewViewController.h"
#import "PQRequestingService.h"

@interface PQConversationDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic) PQRequestingService *requestService;
@property (nonatomic) NSArray *threads;
@property (nonatomic) NSURL *toPassUrl;
@end

@implementation PQConversationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    [_mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configThreads:(NSArray *)threads
    andRequestService:(PQRequestingService *)requestService {
    _threads = threads;
    _requestService = requestService;
}

- (void)setupTableView {
    [_mainTableView registerNib:[UINib nibWithNibName:@"PQThreadTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThreadTableViewCell"];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 20.0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)openWebViewWithUrl:(NSURL *)URL {
    _toPassUrl = URL;
    [self performSegueWithIdentifier:@"OpenWebViewSegue" sender:self];
}

#pragma mark Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"ThreadTableViewCell";
    PQThreadTableViewCell *cell = (PQThreadTableViewCell *)[_mainTableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[PQThreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:reuseId];
    }
    [cell configCellUsingThread:[_threads objectAtIndex:indexPath.row]
        andParentViewController:self];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_threads count];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual:@"OpenWebViewSegue"]) {
        PQWebViewViewController *vc = (PQWebViewViewController *)[segue destinationViewController];
        [vc configWebViewUrlWithUrl:_toPassUrl];
    }
}


@end
