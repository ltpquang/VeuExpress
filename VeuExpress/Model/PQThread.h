//
//  PQThread.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/10/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PQThread : NSObject
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *content;

- (id)initWithAuthor:(NSString *)author
             andDate:(NSString *)date
          andContent:(NSString *)content;
@end
