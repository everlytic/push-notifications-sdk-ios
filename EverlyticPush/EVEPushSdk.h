#import <Foundation/Foundation.h>
#import "EVESdkConfiguration.h"

@class EverlyticNotification;

@interface EVEPushSdk : NSObject

- (EVEPushSdk *_Nonnull)initWithConfiguration:(EVESdkConfiguration *_Nonnull)configuration;

- (void)promptForNotificationPermissionWithUserResponse:(void (^ _Nullable)(BOOL consentGranted))completionHandler;

- (void)subscribeUserWithEmailAddress:(NSString *_Nonnull)emailAddress completionHandler:(void (^ _Nullable)(BOOL, NSError *_Nullable))completionHandler;

- (void)publicNotificationHistoryWithCompletionHandler:(void (^_Nonnull)(NSArray<EverlyticNotification *> *_Nonnull))completionHandler;

- (NSNumber *_Nonnull)publicNotificationHistoryCount;
@end
