//
//  PQURLService.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/28/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketViewTypeEnum.h"

@interface PQURLService : NSObject
+ (NSString *)homeControlPanelURL;
+ (NSString *)loginURL;
+ (NSString *)ticketListURLForTicketOfType:(TicketTypeEnum)type withPage:(int)page;
+ (NSString *)ticketURLForTicketId:(NSString *)ticketId;
+ (NSString *)userURLForTicketId:(NSString *)ticketId;
+ (NSString *)replyContentURLForTicketId:(NSString *)ticketId;
+ (NSString *)draftIdURLForTicketId:(NSString *)ticketId;
@end
