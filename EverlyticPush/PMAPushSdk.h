#import <Foundation/Foundation.h>
#import "PMASdkConfiguration.h"

@interface PMAPushSdk : NSObject

- (PMAPushSdk *_Nonnull)initWithConfiguration:(PMASdkConfiguration *_Nonnull)configuration;

- (void)promptForNotificationPermissionWithUserResponse:(void (^ _Nullable)(BOOL consentGranted))completionHandler;

- (void)subscribeUserWithEmailAddress:(NSString *_Nonnull)emailAddress completionHandler:(void (^ _Nullable)(BOOL, NSError *_Nullable))completionHandler;
@end
