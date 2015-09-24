//
//  PQParsingService.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 12/1/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import "PQParsingService.h"
#import "TFHpple.h"
#import "PQTicket.h"
#import "PQUser.h"
#import "PQThread.h"
#import <UIKit/UIKit.h>

@implementation PQParsingService

#pragma mark Parse Replying Content
+ (NSString *)parseReplyContentAndRetrieveReplyStringWithData:(NSData *)htmlData {
    return [[NSString  alloc] init];
}

#pragma mark Parse Ticket Detail Page
+ (NSString *)retrieveTicketStatusFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[2]/tr/td[1]/table/tr[1]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    //NSString *xPath = @"//*[@id='content']/table[@class='ticket_info']";
    //TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result;
}

+ (NSString *)retrieveTicketSourceFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[2]/tr/td[2]/table/tr[4]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *device = [[[[tdNode children] objectAtIndex:0] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *ip = [[[[[tdNode children] objectAtIndex:1] children] firstObject] content];
    NSString *result = [NSString stringWithFormat:@"%@ %@", device, ip];
    return result;
}

+ (NSString *)retrieveTicketHelpTopicFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[3]/tr/td[2]/table/tr[1]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result;
}

+ (NSString *)retrieveTicketCreateDateFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[2]/tr/td[1]/table/tr[4]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result;
}

+ (NSString *)retrieveTicketDueDateFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[3]/tr/td[1]/table/tr[3]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result;
}

+ (NSString *)retrieveTicketLastMessageFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[3]/tr/td[2]/table/tr[2]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result;
}

+ (NSString *)retrieveTicketLastResponseFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='content']/table[3]/tbody/tr/td[2]/table/tbody/tr[3]/td";
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result.length == 0 ? @"------" : result;
}

+ (NSString *)retrieveTicketCsrfTokenFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//meta[@name='csrf_token']";
    TFHppleElement *metaNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[metaNode attributes] objectForKey:@"content"];
    return result;
}

+ (NSString *)retrieveTicketMsgIdFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//input[@name='msgId']";
    TFHppleElement *inputNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[inputNode attributes] objectForKey:@"value"];
    return result;
}

+ (NSString *)retrieveThreadAuthorFromtableNode:(TFHppleElement *)tableNode {
    NSString *xPath = @"//span[@class='pull-right']/span[2]";
    TFHppleElement *spanWithContent = [[tableNode searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[spanWithContent children] firstObject] content];
    return result;
}

+ (NSString *)retrieveThreadDateFromtableNode:(TFHppleElement *)tableNode {
    NSString *xPath = @"//span[@class='pull-left']/span[1]";
    TFHppleElement *spanWithContent = [[tableNode searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[spanWithContent children] firstObject] content];
    return result;
}

+ (NSString *)retrieveThreadContentFromtableNode:(TFHppleElement *)tableNode {
    NSString *xPath = @"//td[@class='thread-body']/div";
    TFHppleElement *divWithContent = [[tableNode searchWithXPathQuery:xPath] firstObject];
    NSString *divRawString = [[divWithContent raw] stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"<br/>"];
    divRawString = [divRawString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                              @"Helvetica Neue",
                                              15.0]];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:[divRawString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                 documentAttributes:nil
                                                                    error:nil];
    NSMutableAttributedString *mAttString = [attString mutableCopy];
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range           = [mAttString.string rangeOfCharacterFromSet:charSet
                                              options:NSBackwardsSearch];
    while (range.length != 0 && NSMaxRange(range) == mAttString.length)
    {
        [mAttString replaceCharactersInRange:range
                                 withString:@""];
        range = [mAttString.string rangeOfCharacterFromSet:charSet
                                                  options:NSBackwardsSearch];
    }
    
    return [mAttString string];
}

+ (PQThread *)retrieveThreadFromtableNode:(TFHppleElement *)tableNode {
    return [[PQThread alloc] initWithAuthor:[self retrieveThreadAuthorFromtableNode:tableNode]
                                    andDate:[self retrieveThreadDateFromtableNode:tableNode]
                                 andContent:[self retrieveThreadContentFromtableNode:tableNode]];
}

+ (NSArray *)retrieveTicketThreadListFromHtml:(TFHpple *) parser {
    NSString *xPath = @"//div[@id='ticket_thread']/table[@class='thread-entry message' or @class='thread-entry response']";
    NSArray *tableNodes = [parser searchWithXPathQuery:xPath];
    NSMutableArray *threads = [[NSMutableArray alloc] init];
    for (TFHppleElement *tableNode in tableNodes) {
        [threads addObject:[self retrieveThreadFromtableNode:tableNode]];
    }
    return threads;
}

+ (PQTicket *)parseTicketDetailPageAndRetrieveTicketDetailWithData:(NSData *)htmlData {
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    return [[PQTicket alloc] initWithTicketStatus:[self retrieveTicketStatusFromHtml:htmlParser]
                                        andSource:[self retrieveTicketSourceFromHtml:htmlParser]
                                     andHelpTopic:[self retrieveTicketHelpTopicFromHtml:htmlParser]
                                    andCreateDate:[self retrieveTicketCreateDateFromHtml:htmlParser]
                                       andDueDate:[self retrieveTicketDueDateFromHtml:htmlParser]
                                   andLastMessage:[self retrieveTicketLastMessageFromHtml:htmlParser]
                                  andLastResponse:[self retrieveTicketLastResponseFromHtml:htmlParser]
                                     andCsrfToken:[self retrieveTicketCsrfTokenFromHtml:htmlParser]
                                         andMsgId:[self retrieveTicketMsgIdFromHtml:htmlParser]
                                       andThreads:[self retrieveTicketThreadListFromHtml:htmlParser]
                                          andUser:nil];
}

#pragma mark Parse User Detail Section
+ (NSString *)retrieveUserNameFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='user-profile']/div[1]/b";
    TFHppleElement *bNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[bNode children] firstObject] content];
    return result;
}

+ (NSString *)retrieveUserEmailFromHtml:(TFHpple *)parser {
    NSString *xPath = @"//*[@id='user-profile']/div[2]";
    TFHppleElement *divNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[divNode children] firstObject] content];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    return result;
}

+ (NSString *)retrieveCustomInfoAtRow:(NSUInteger)row fromHtml:(TFHpple *)parser {
    NSString *xPath = [NSString stringWithFormat:@"//*[@id='info-tab']/table/tr[%lu]/td[2]", row+2];//1 for header row, 1 for 1-based xpath indexing
    TFHppleElement *tdNode = [[parser searchWithXPathQuery:xPath] firstObject];
    NSString *result = [[[tdNode children] firstObject] content];
    return result;
}

+ (PQUser *)parseUserDetailSectionFromTicketDetailPageAndRetrieveUserWithData:(NSData *)htmlData {
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    NSString *userName = [self retrieveUserNameFromHtml:htmlParser];
    NSString *userEmail = [self retrieveUserEmailFromHtml:htmlParser];
    NSString *userPhone = [self retrieveCustomInfoAtRow:0 fromHtml:htmlParser];
    NSString *userNote = [self retrieveCustomInfoAtRow:1 fromHtml:htmlParser];
    if ([userNote length] == 0) {
        userNote = @"Không có ghi chú";
    }
    else {
        userNote = [NSString stringWithFormat:@"\"%@\"", userNote];
    }
    NSString *userAddress = [self retrieveCustomInfoAtRow:2 fromHtml:htmlParser];
    
    return [[PQUser alloc] initWithName:userName
                               andEmail:userEmail
                               andPhone:userPhone
                             andAddress:userAddress
                                andNote:userNote];
}

#pragma mark Parse Ticket List Page
+ (NSString *)retrieveOrderIdFromtdNode:(TFHppleElement *)tdNode {
    TFHppleElement *aNode = [[tdNode searchWithXPathQuery:@"//a"] firstObject];
    NSArray *bNodes = [aNode searchWithXPathQuery:@"//b"];
    if ([bNodes count] == 0) {
        return [[[aNode children] firstObject] content];
    }
    else {
        TFHppleElement *bNode = [bNodes firstObject];
        return [[[bNode children] firstObject] content];
    }
}

+ (NSString *)retrieveDateFromtdNode:(TFHppleElement *)tdNode {
    return [[[tdNode children] firstObject] content];
}

+ (NSString *)retrieveSubjectFromtdNode:(TFHppleElement *)tdNode {
    TFHppleElement *aNode = [[tdNode children] firstObject];
    return [[[aNode children] firstObject] content];
}

+ (NSString *)retrieveAuthorFromtdNode:(TFHppleElement *)tdNode {
    return [[[tdNode children] firstObject] content];
}

+ (PQTicket *)pqTicketInstanceFromtrNode:(TFHppleElement *)trNode {
    NSArray *tdNodes = [trNode searchWithXPathQuery:@"//td"];
    
    return [[PQTicket alloc] initWithTicketId:[trNode objectForKey:@"id"]
                                   andOrderId:[self retrieveOrderIdFromtdNode:[tdNodes objectAtIndex:1]]
                                      andDate:[self retrieveDateFromtdNode:[tdNodes objectAtIndex:2]]
                                   andSubject:[self retrieveSubjectFromtdNode:[tdNodes objectAtIndex:3]]
                                    andAuthor:[self retrieveAuthorFromtdNode:[tdNodes objectAtIndex:4]]];
}

+ (NSArray *)parseTicketPageAndRetrieveTicketListWithData:(NSData *)htmlData {
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *tbodyXPath = @"//*[@id='tickets']/table/tbody";
    NSArray *tbodyNodes = [htmlParser searchWithXPathQuery:tbodyXPath];
    
    TFHppleElement *tbodyNode = [tbodyNodes firstObject];
    
    NSArray *trTicketNode = [tbodyNode searchWithXPathQuery:@"//tr"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in trTicketNode) {
        [result addObject:[self pqTicketInstanceFromtrNode:element]];
    }
    
    return result;
}

+ (BOOL)parseTicketPageAndCheckIfThatPageIsMaxPageOrNotWithData:(NSData *)htmlData {
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *indicatePageString = [[[htmlParser searchWithXPathQuery:@"//*[@id='content']/div[3]/div[1]/div[1]/h2/a/text()"] firstObject] content];
    
    NSArray *wordArray = [indicatePageString componentsSeparatedByString:@" "];
    
    NSString *currentPageMax = [wordArray objectAtIndex:wordArray.count-3];
    NSString *totalPageMax = [wordArray objectAtIndex:wordArray.count-1];
    
    if ([currentPageMax compare:totalPageMax] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

#pragma mark Parse Login Page
+ (NSString *)parseLoginPageAndRetrieveCSRFTokenWithData:(NSData *)htmlData {
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xPath = @"//*[@id='loginBox']/form/input[1]";
    NSArray *CSRFTokenNodes = [htmlParser searchWithXPathQuery:xPath];
    
    TFHppleElement *element = [CSRFTokenNodes firstObject];
    
    
    NSString *csrfToken = [element objectForKey:@"value"];
    
    return csrfToken;
}




@end
