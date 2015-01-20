//
//  PQParsingService.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/1/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PQTicket;
@class PQUser;

@interface PQParsingService : NSObject
+ (NSString *)parseLoginPageAndRetrieveCSRFTokenWithData:(NSData *)htmlData;
+ (NSArray *)parseTicketPageAndRetrieveTicketListWithData:(NSData *)htmlData;
+ (BOOL)parseTicketPageAndCheckIfThatPageIsMaxPageOrNotWithData:(NSData *)htmlData;
+ (PQTicket *)parseTicketDetailPageAndRetrieveTicketDetailWithData:(NSData *)htmlData;
+ (PQUser *)parseUserDetailSectionFromTicketDetailPageAndRetrieveUserWithData:(NSData *)htmlData;
+ (NSString *)parseReplyContentAndRetrieveReplyStringWithData:(NSData *)htmlData;
@end
