//
// Created by Jason Dantuma on 2019-06-18.
// Copyright (c) 2019 Everlytic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMASdkConfiguration.h"

@interface PMAPushSdk : NSObject

- (PMAPushSdk *) initWithConfiguration:(PMASdkConfiguration *)configuration;
- (void) promptForNotificationWithUserResponse:(void (^)(BOOL consentGranted))completionHandler;
@end