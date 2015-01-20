//
//  PQAuthenticatingService.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/28/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQAuthenticatingService.h"
#import "PQRequestingService.h"
#import <AFNetworking.h>
#import "PQURLService.h"
#import "PQParsingService.h"

@interface PQAuthenticatingService()

@property NSString *userid;
@property NSString *passwd;
@property NSString *cookie;

@end

@implementation PQAuthenticatingService

- (void)sendLoginCredentialUsingCSRFToken:(NSString *)token
                                  success:(void(^)())successCall
                                  failure:(void(^)(NSError *error))failureCall
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:_cookie forHTTPHeaderField:@"Cookie"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *body = @{@"__CSRFToken__":token,
                           @"do":@"scplogin",
                           @"userid":_userid,
                           @"passwd":_passwd,
                           @"submit":@"Log In"
                           };
    
    
    [manager POST:[PQURLService loginURL]
       parameters:body
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([operation.response statusCode] == 302
                  || [operation.response statusCode] == 200) {
                  successCall();
              }
              else {
                  NSError *error = [[NSError alloc] init];
                  failureCall(error);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
              failureCall(error);
          }];
    
}



- (void)firstGetAndRetrieveCSRFTokenFromURL:(NSString *)homeControlPanelUrl
                                    success:(void(^)())successCall
                                    failure:(void(^)(NSError *error))failureCall
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:_cookie forHTTPHeaderField:@"Cookie"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:homeControlPanelUrl
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSHTTPURLResponse *response = operation.response;
         NSDictionary *headers = [response allHeaderFields];
         _cookie = [headers valueForKey:@"Set-Cookie"];
         
         NSString *htmlString = [[NSString alloc] initWithData:responseObject
                                                      encoding:NSUTF8StringEncoding];
         NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
         NSString *csrfToken = [PQParsingService parseLoginPageAndRetrieveCSRFTokenWithData:htmlData];
         [self sendLoginCredentialUsingCSRFToken:csrfToken
                                         success:successCall
                                         failure:failureCall];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
         failureCall(error);
     }];
}

- (void)loginWithUserId:(NSString *)userid
            andPassword:(NSString *)passwd
                success:(void(^)())successCall
                failure:(void(^)(NSError *error))failureCall
{
    _userid = userid;
    _passwd = passwd;
    
    [self firstGetAndRetrieveCSRFTokenFromURL:[PQURLService homeControlPanelURL]
                                      success:successCall
                                      failure:failureCall];
}

- (PQRequestingService *)pqRequestingServiceInstance
{
    return [[PQRequestingService alloc] initWithCookie:_cookie];
}

@end
