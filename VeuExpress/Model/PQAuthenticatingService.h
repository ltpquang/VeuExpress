//
//  PQAuthenticatingService.h
//  VeuExpress
//
//  Created by Le Thai Phuc Quang on 11/28/14.
//  Copyright (c) 2014 Le Thai Phuc Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PQRequestingService;

@interface PQAuthenticatingService : NSObject

- (void)loginWithUserId:(NSString *)userid
            andPassword:(NSString *)passwd
                success:(void(^)())successCall
                failure:(void(^)(NSError *error))failureCall;

- (PQRequestingService *)pqRequestingServiceInstance;

@end
