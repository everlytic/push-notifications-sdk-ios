//
//  NotificationService.m
//  EverlyticPushNotificationServiceExtension
//
//  Created by Jason Dantuma on 2019/07/01.
//  Copyright © 2019 Everlytic. All rights reserved.
//

#import <EverlyticPush/EverlyticPush.h>
#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic, strong) UNNotificationRequest *request;

@end

@implementation NotificationService 

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.request = request;
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    NSLog(@"badge=%@ title=%@ body=<%@> subtitle=<%@> summaryArgument=%@ catIdentifier=%@ launchImage=%@ userInfo=%@",
            request.content.badge,
            request.content.title,
            request.content.body,
            request.content.subtitle,
            request.content.summaryArgument,
            request.content.categoryIdentifier,
            request.content.launchImageName,
            request.content.userInfo
    );

    [EverlyticNotificationServiceExtensionHandler
            didReceiveNotificationRequest:request
           withMutableNotificationContent:self.bestAttemptContent
    ];

    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {

    [EverlyticNotificationServiceExtensionHandler
            serviceExtensionTimeWillExpireWithRequest:self.request
                       withMutableNotificationContent:self.bestAttemptContent
    ];

    self.contentHandler(self.bestAttemptContent);
}

@end
