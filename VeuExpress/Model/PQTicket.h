//
//  PQTicket.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/28/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PQUser;
@class PQRequestingService;

@interface PQTicket : NSObject
@property (nonatomic) NSString *ticketId;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *subject;
@property (nonatomic) NSString *author;

@property (nonatomic) PQUser *user;
@property (nonatomic) NSArray *threads;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *helpTopic;
@property (nonatomic) NSString *createDate;
@property (nonatomic) NSString *dueDate;
@property (nonatomic) NSString *lastMessage;
@property (nonatomic) NSString *lastResponse;

- (id)initWithTicketId:(NSString *)ticketId
            andOrderId:(NSString *)orderId
               andDate:(NSString *)date
            andSubject:(NSString *)subject
             andAuthor:(NSString *)author;

- (id)initWithTicketStatus:(NSString *)status
                 andSource:(NSString *)source
              andHelpTopic:(NSString *)helpTopic
             andCreateDate:(NSString *)createDate
                andDueDate:(NSString *)dueDate
            andLastMessage:(NSString *)lastMessage
           andLastResponse:(NSString *)lastResponse
                andThreads:(NSArray *)threads
                   andUser:(PQUser *)user;

- (void)downloadTicketDetailUsingRequestingService:(PQRequestingService *)requestService
                                           success:(void(^)())successCall
                                           failure:(void(^)(NSError *error))failureCall;


@end
