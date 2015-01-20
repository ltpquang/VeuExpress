//
//  PQThread.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/10/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQThread.h"

@implementation PQThread

- (id)initWithAuthor:(NSString *)author
             andDate:(NSString *)date
          andContent:(NSString *)content {
    if (self = [super init]) {
        _author = author;
        _date = date;
        _content = content;
    }
    return self;
}
@end
