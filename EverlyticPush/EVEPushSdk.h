#import <Foundation/Foundation.h>
#import "EVESdkConfiguration.h"

@class EverlyticNotification;

@interface EVEPushSdk : NSObject

- (EVEPushSdk *_Nonnull)initWithConfiguration:(EVESdkConfiguration *_Nonnull)configuration;

- (void)promptForNotificationPermissionWithUserResponse:(void (^ _Nullable)(BOOL consentGranted))completionHandler;

- (void)subscribeUserWithUniqueId:(NSString *_Nullable)uniqueId emailAddress:(NSString *_Nullable)emailAddress completionHandler:(void (^)(BOOL, NSError *))completionHandler;

- (void)unsubscribeUserWithCompletionHandler:(void(^_Nullable)(BOOL))completionHandler;

- (void)publicNotificationHistoryWithCompletionHandler:(void (^_Nonnull)(NSArray<EverlyticNotification *> *_Nonnull))completionHandler;

- (NSNumber *_Nonnull)publicNotificationHistoryCount;
@end
