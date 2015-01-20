//
//  PQUser.m
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 1/10/15.
//  Copyright (c) 2015 Le Thai Phuc Quang. All rights reserved.
//

#import "PQUser.h"

@implementation PQUser
- (id)initWithName:(NSString *)name
          andEmail:(NSString *)email
          andPhone:(NSString *)phone
        andAddress:(NSString *)address
           andNote:(NSString *)note {
    if (self = [super init]) {
        _name = name;
        _email = email;
        _phone = phone;
        _address = address;
        _note = note;
    }
    return self;
}
@end
