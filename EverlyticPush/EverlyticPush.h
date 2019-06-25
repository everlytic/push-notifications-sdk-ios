#import <UIKit/UIKit.h>

@interface EverlyticPush : NSObject

+ (id _Nonnull)initWithPushConfig:(nonnull NSString *)pushConfig;

+ (void)promptForNotificationWithUserResponse:(void (^ _Nullable)(BOOL consentGranted))completionHandler;

+ (void)subscribeUserWithEmail:(nonnull NSString *)emailAddress completionHandler:(void (^ _Nullable)(BOOL subscriptionSuccess, NSError *_Nullable error))handler;

+ (void)unsubscribeUserWithCompletionHandler:(void (^ _Nonnull)(BOOL subscriptionSuccess, NSError *_Nullable error))handler;

+ (BOOL)contactIsSubscribed;

+ (void)fetchNotificationHistoryWithCompletionListener:(void (^ _Nonnull)(void))completionHandler;
@end
