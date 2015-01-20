//
//  PQWebViewViewController.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/17/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQWebViewViewController.h"

@interface PQWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) NSURL *url;
@end

@implementation PQWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sendRequest];
    [_loadingIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configWebViewUrlWithUrl:(NSURL *)url {
    _url = url;
}

- (void)sendRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_url];
    [_mainWebView loadRequest:request];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)reloadButtonTUI:(id)sender {
    [_mainWebView reload];
}

- (IBAction)backButtonTUI:(id)sender {
    [_mainWebView goBack];
}

- (IBAction)forwardButtonTUI:(id)sender {
    [_mainWebView goForward];
}

- (IBAction)doneButtonTUI:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_loadingIndicator stopAnimating];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Hú" message:@"Chả hiểu sao mà load lỗi rồi anh eei, có gì reload lại hộ em." delegate:self cancelButtonTitle:@"Ờ" otherButtonTitles:nil];
    [al show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loadingIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_loadingIndicator startAnimating];
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
