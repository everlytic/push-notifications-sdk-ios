#import <Foundation/Foundation.h>
#import "PMASdkConfiguration.h"

@interface PMAPushSdk : NSObject

- (PMAPushSdk *_Nonnull) initWithConfiguration:(PMASdkConfiguration *_Nonnull)configuration;
- promptForNotificationWithUserResponse:(void (^_Nullable)(BOOL consentGranted))completionHandler;
- subscribeUserWithEmailAddress:(NSString *_Nonnull)emailAddress;
@end