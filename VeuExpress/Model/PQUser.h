//
//  PQUser.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/10/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PQUser : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *note;

- (id)initWithName:(NSString *)name
          andEmail:(NSString *)email
          andPhone:(NSString *)phone
        andAddress:(NSString *)address
           andNote:(NSString *)note;

@end
