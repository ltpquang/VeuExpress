//
//  PQRequestingService.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/1/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQRequestingService.h"
#import "PQURLService.h"
#import "PQParsingService.h"
#import "TicketViewTypeEnum.h"
#import "PQTicket.h"
#import "PQUser.h"

@interface PQRequestingService()

@property NSString *cookie;
@property AFHTTPSessionManager *manager;
@property (nonatomic) int loadedPageCount;
@end

@implementation PQRequestingService

- (id)initWithCookie:(NSString *)cookie
{
    if (self = [super init]) {
        _cookie = cookie;
    }
    _loadedPageCount = 0;
    [self setupManager];
    return self;
}

- (PQRequestingService *)instanceWithSameCookie {
    return [[PQRequestingService alloc] initWithCookie:_cookie];
}

- (void)setupManager {
    _manager = [[AFHTTPSessionManager alloc] init];
    
    //_manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [_manager.requestSerializer setValue:_cookie forHTTPHeaderField:@"Cookie"];
    
    //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
}

- (void)configManagerWithJsonRequestExpected:(BOOL)isJsonInRequest
                     andJsonResponseExpected:(BOOL)isJsonInResponse {
    _manager.requestSerializer = isJsonInRequest?[AFJSONRequestSerializer serializer]:[AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = isJsonInResponse?[AFJSONResponseSerializer serializer]:[AFHTTPResponseSerializer serializer];
}

- (void)reset {
    _loadedPageCount = 0;
    _isMaxPageReached = false;
}

- (NSData *)htmlDataFromResponseObject:(id)responseObject {
    NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    return htmlData;
}

- (void)downloadTicketsWithSuccess:(void(^)(NSArray *resultArray))successCall
                           failure:(void(^)(NSError *error))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:NO];
    [_manager GET:[PQURLService ticketListURLForTicketOfType:_ticketType
                                                    withPage:_loadedPageCount+1]
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSData *htmlData = [self htmlDataFromResponseObject:responseObject];
              //Check and set if reach max page
              _isMaxPageReached = [PQParsingService parseTicketPageAndCheckIfThatPageIsMaxPageOrNotWithData:htmlData];
              NSArray *ticketArray = [PQParsingService parseTicketPageAndRetrieveTicketListWithData:htmlData];
              ++_loadedPageCount;
              successCall(ticketArray);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              //
          }];
}

- (void)downloadTicketDetailWithTicketId:(NSString *)ticketId
                                 success:(void(^)(PQTicket *resultTicket))successCall
                                 failure:(void(^)(NSError *error))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:NO];
    [_manager GET:[PQURLService ticketURLForTicketId:ticketId]
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSData *htmlData = [self htmlDataFromResponseObject:responseObject];
              PQTicket *resultTicket = [PQParsingService parseTicketDetailPageAndRetrieveTicketDetailWithData:htmlData];
              [self downloadTicketAuthorWithTicketId:ticketId
                                             success:^(PQUser *resultUser) {
                                                 resultTicket.user = resultUser;
                                                 successCall(resultTicket);
                                             }
                                             failure:^(NSError *error) {
                                                 //
                                             }];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              //
          }];
}

- (void)downloadTicketAuthorWithTicketId:ticketId
                                 success:(void(^)(PQUser *resultUser))successCall
                                 failure:(void(^)(NSError *error))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:NO];
    [_manager GET:[PQURLService userURLForTicketId:ticketId]
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSData *htmlData = [self htmlDataFromResponseObject:responseObject];
              PQUser *resultUser = [PQParsingService parseUserDetailSectionFromTicketDetailPageAndRetrieveUserWithData:htmlData];
              successCall(resultUser);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              //
          }];
}

- (void)downloadTicketReplyContentWithTicketId:ticketId
                                       success:(void(^)(NSString *resultContent))successCall
                                       failure:(void(^)(NSError *error))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:YES];
    [_manager GET:[PQURLService replyContentURLForTicketId:ticketId]
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSData *htmlData = [self htmlDataFromResponseObject:responseObject];
              NSString *result = [PQParsingService parseReplyContentAndRetrieveReplyStringWithData:htmlData];
              successCall(result);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              //
          }];
}
@end
