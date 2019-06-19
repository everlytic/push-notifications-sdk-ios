//
//  EverlyticPush.h
//  EverlyticPush
//
//  Created by Jason Dantuma on 2019/06/18.
//  Copyright © 2019 Everlytic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EverlyticPush : NSObject

+ (id)initWithPushConfig:(NSString *)pushConfig;

+ (void)promptForNotificationWithUserResponse:(void (^)(BOOL consentGranted))completionHandler;

+ (BOOL)hasNotificationConsent;

@end
