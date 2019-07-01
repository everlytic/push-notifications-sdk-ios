//
//  NotificationService.m
//  EverlyticPushNotificationServiceExtension
//
//  Created by Jason Dantuma on 2019/07/01.
//  Copyright © 2019 Everlytic. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    self.bestAttemptContent.title = @"This is a title";
    
    NSLog(@"badge=%@ title=%@ body=<%@> subtitle=<%@> summaryArgument=%@ catIdentifier=%@ launchImage=%@",
            request.content.badge,
            request.content.title,
            request.content.body,
            request.content.subtitle,
            request.content.summaryArgument,
            request.content.categoryIdentifier,
            request.content.launchImageName
    );
    
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
