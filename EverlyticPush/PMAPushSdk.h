#import <Foundation/Foundation.h>
#import "PMASdkConfiguration.h"

@interface PMAPushSdk : NSObject

- (PMAPushSdk *_Nonnull)initWithConfiguration:(PMASdkConfiguration *_Nonnull)configuration;

- (void)promptForNotificationWithUserResponse:(void (^ _Nullable)(BOOL consentGranted))completionHandler;

- (void)subscribeUserWithEmailAddress:(NSString *_Nonnull)emailAddress;
@end