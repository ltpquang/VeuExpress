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
    
    [_manager.requestSerializer setValue:_cookie forHTTPHeaderField:@"Cookie"];
    
    //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
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

- (void)downloadTicketForSearchTerm:(NSString *)searchTerm
                            success:(void(^)(NSArray *resultArray))successCall
                            failure:(void(^)(NSError *error))failureCall {
    
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

- (void)downloadTicketReplyContentWithTicketId:(NSString *)ticketId
                                       success:(void(^)(NSString *resultContent))successCall
                                       failure:(void(^)(NSError *error))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:YES];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [_manager GET:[PQURLService replyContentURLForTicketId:ticketId]
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSDictionary *resultDic = (NSDictionary *)responseObject;
              successCall([resultDic objectForKey:@"response"]);
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              //
          }];
}

- (void)downloadTicketDraftIdWithTicket:(PQTicket *)ticket
                                 success:(void(^)(NSString *resultDraftId))successcall
                                 failure:(void(^)(NSError *error))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:YES];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:ticket.csrfToken forHTTPHeaderField:@"X-CSRFToken"];
    [_manager POST:[PQURLService draftIdURLForTicketId:ticket.ticketId]
        parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[@"response" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
    [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"response"];
}
           success:^(NSURLSessionDataTask *task, id responseObject) {
               NSNumber *result = (NSNumber *)[responseObject objectForKey:@"draft_id"];
               successcall([result stringValue]);
           }
           failure:^(NSURLSessionDataTask *task, NSError *error) {
               failureCall(error);
           }];
}

- (void)postReplyForTicketWithTicket:(PQTicket *)ticket
                         withMessage:(NSString *)message
                             success:(void(^)())successCall
                             failure:(void(^)(NSError *))failureCall {
    [self configManagerWithJsonRequestExpected:NO
                       andJsonResponseExpected:NO];
    [_manager.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
    [_manager POST:[PQURLService ticketURLForTicketId:ticket.ticketId]
        parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:[ticket.csrfToken dataUsingEncoding:NSUTF8StringEncoding] name:@"__CSRFToken__"];
    [formData appendPartWithFormData:[ticket.ticketId dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
    [formData appendPartWithFormData:[ticket.msgId dataUsingEncoding:NSUTF8StringEncoding] name:@"msgId"];
    [formData appendPartWithFormData:[@"reply" dataUsingEncoding:NSUTF8StringEncoding] name:@"a"];
    [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"emailreply"];
    [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"emailcollab"];
    [formData appendPartWithFormData:[@"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"cannedResp"];
    [formData appendPartWithFormData:[ticket.draftId dataUsingEncoding:NSUTF8StringEncoding] name:@"draft_id"];
    [formData appendPartWithFormData:[message dataUsingEncoding:NSUTF8StringEncoding] name:@"response"];
    [formData appendPartWithFormData:[@"none" dataUsingEncoding:NSUTF8StringEncoding] name:@"signature"];
    [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"reply_status_id"];
    [formData appendPartWithFormData:[ticket.draftId dataUsingEncoding:NSUTF8StringEncoding] name:@"draft_id"];
}
           success:^(NSURLSessionDataTask *task, id responseObject) {
               successCall();
           }
           failure:^(NSURLSessionDataTask *task, NSError *error) {
               failureCall(error);
           }];
}
@end
