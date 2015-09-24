//
//  PQRequestingService.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/1/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "TicketViewTypeEnum.h"

@class PQTicket;

@interface PQRequestingService : NSObject

@property (nonatomic) BOOL isMaxPageReached;
@property TicketTypeEnum ticketType;

- (id)initWithCookie:(NSString *)cookie;
- (PQRequestingService *)instanceWithSameCookie;
- (void)reset;
- (void)downloadTicketsWithSuccess:(void(^)(NSArray *resultArray))successCall
                           failure:(void(^)(NSError *error))failureCall;
- (void)downloadTicketDetailWithTicketId:(NSString *)ticketId
                                 success:(void(^)(PQTicket *resultTicket))successCall
                                 failure:(void(^)(NSError *error))failureCall;
- (void)downloadTicketReplyContentWithTicketId:(NSString *)ticketId
                                       success:(void(^)(NSString *resultContent))successCall
                                       failure:(void(^)(NSError *error))failureCall;
- (void)downloadTicketDraftIdWithTicket:(PQTicket *)ticket
                                 success:(void(^)(NSString *resultDraftId))successcall
                                 failure:(void(^)(NSError *error))failureCall;
- (void)postReplyForTicketWithTicket:(PQTicket *)ticket
                         withMessage:(NSString *)message
                             success:(void(^)())successCall
                             failure:(void(^)(NSError *))failureCall;
@end
