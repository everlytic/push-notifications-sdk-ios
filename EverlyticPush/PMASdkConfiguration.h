//
// Created by Jason Dantuma on 2019-06-18.
// Copyright (c) 2019 Everlytic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMASdkConfiguration : NSObject

@property (strong, nonatomic) NSString *projectId;
@property (strong, nonatomic) NSURL *installUrl;

+ (PMASdkConfiguration *) initFromConfigString:(NSString *) configString;
@end