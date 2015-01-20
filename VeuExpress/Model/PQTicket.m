//
//  PQTicket.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/28/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQTicket.h"
#import "PQUser.h"
#import "PQRequestingService.h"

@interface PQTicket()

@end

@implementation PQTicket

- (id)initWithTicketId:(NSString *)ticketId
            andOrderId:(NSString *)orderId
               andDate:(NSString *)date
            andSubject:(NSString *)subject
             andAuthor:(NSString *)author
{
    if (self = [super init]) {
        _ticketId = ticketId;
        _orderId = orderId;
        _date = date;
        _subject = subject;
        _author = author;
    }
    return self;
}

- (id)initWithTicketStatus:(NSString *)status
                 andSource:(NSString *)source
              andHelpTopic:(NSString *)helpTopic
             andCreateDate:(NSString *)createDate
                andDueDate:(NSString *)dueDate
            andLastMessage:(NSString *)lastMessage
           andLastResponse:(NSString *)lastResponse
                andThreads:(NSArray *)threads
                   andUser:(PQUser *)user {
    if (self = [super init]) {
        _status = status;
        _source = source;
        _helpTopic = helpTopic;
        _createDate = createDate;
        _dueDate = dueDate;
        _lastMessage = lastMessage;
        _lastResponse = lastResponse;
        _user = user;
        _threads = threads;
    }
    return self;
}


- (void)downloadTicketDetailUsingRequestingService:(PQRequestingService *)requestService
                                           success:(void(^)())successCall
                                           failure:(void(^)(NSError *error))failureCall {
    [requestService downloadTicketDetailWithTicketId:_ticketId
                                             success:^(PQTicket *resultTicket) {
                                                 [self updateDetailForCurrentTicketUsingTicket:resultTicket];
                                                 successCall();
                                             }
                                             failure:^(NSError *error) {
                                                 //
                                             }];
}

- (void)updateDetailForCurrentTicketUsingTicket:(PQTicket *)ticket {
    _user = ticket.user;
    _threads = ticket.threads;
    _status = ticket.status;
    _source = ticket.source;
    _helpTopic = ticket.helpTopic;
    _createDate = ticket.createDate;
    _dueDate = ticket.dueDate;
    _lastMessage  = ticket.lastMessage;
    _lastResponse = ticket.lastResponse;
}

@end
