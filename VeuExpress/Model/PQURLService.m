//
//  PQURLService.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/28/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQURLService.h"

@implementation PQURLService

+ (NSString *)homeControlPanelURL {
    return @"http://veuexpress.com/ticket/scp/";
}

+ (NSString *)loginURL {
    NSString *result = [NSString stringWithFormat:@"%@login.php", [self homeControlPanelURL]];
    return result;
}

+ (NSString *)ticketListURLForTicketOfType:(TicketTypeEnum)type withPage:(int)page {
    NSString *urlWithoutPage;
    switch (type) {
        case TicketTypeOpen:
            urlWithoutPage = [self openTicketsURL];
            break;
        case TicketTypeAnswered:
            urlWithoutPage = [self answeredTicketsURL];
            break;
        case TicketTypeAssigned:
            urlWithoutPage = [self assignedTicketsURL];
            break;
        case TicketTypeOverdue:
            urlWithoutPage = [self overdueTicketsURL];
            break;
        case TicketTypeClosed:
            urlWithoutPage = [self closedTicketsURL];
            break;
    }
    return [NSString stringWithFormat:@"%@&p=%i", urlWithoutPage, page];
}

+ (NSString *)openTicketsURL {
    NSString *result = [NSString stringWithFormat:@"%@tickets.php?status=open", [self homeControlPanelURL]];
    return result;
}

+ (NSString *)answeredTicketsURL {
    NSString *result = [NSString stringWithFormat:@"%@tickets.php?status=answered", [self homeControlPanelURL]];
    return result;
}

+ (NSString *)assignedTicketsURL {
    NSString *result = [NSString stringWithFormat:@"%@tickets.php?status=assigned", [self homeControlPanelURL]];
    return result;
}

+ (NSString *)overdueTicketsURL {
    NSString *result = [NSString stringWithFormat:@"%@tickets.php?status=overdue", [self homeControlPanelURL]];
    return result;
}

+ (NSString *)closedTicketsURL {
    NSString *result = [NSString stringWithFormat:@"%@tickets.php?status=closed", [self homeControlPanelURL]];
    return result;
}

+ (NSString *)ticketURLForTicketId:(NSString *)ticketId {
    //veuexpress.com/scp/tickets.php?id=263
    NSString *result = [NSString stringWithFormat:@"%@tickets.php?id=%@", [self homeControlPanelURL], ticketId];
    return result;
}

+ (NSString *)userURLForTicketId:(NSString *)ticketId {
    //veuexpress.com/scp/ajax.php/tickets/48/user
    NSString *result = [NSString stringWithFormat:@"%@ajax.php/tickets/%@/user", [self homeControlPanelURL], ticketId];
    return result;
}

+ (NSString *)replyContentURLForTicketId:(NSString *)ticketId {
    //veuexpress.com/scp/ajax.php/tickets/263/canned-resp/2.json
    NSString *result = [NSString stringWithFormat:@"%@ajax.php/tickets/%@/canned-resp/2.json", [self homeControlPanelURL], ticketId];
    return result;
}

+ (NSString *)draftIdURLForTicketId:(NSString *)ticketId {
    //veuexpress.com/scp/ajax.php/draft/ticket.response.297
    NSString *result = [NSString stringWithFormat:@"%@ajax.php/draft/ticket.response.%@", [self homeControlPanelURL], ticketId];
    return result;
}

@end
