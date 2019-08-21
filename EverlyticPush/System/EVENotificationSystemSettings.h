#import <Foundation/Foundation.h>

@protocol EVENotificationSystemSettings <NSObject>
- (void) promptForNotifications:(void(^)(BOOL accepted))completionHandler;
- (void) getNotificationAuthorizationStatus:(void(^)(BOOL authorized))completionHandler;
@end