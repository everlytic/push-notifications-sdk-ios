#import <Foundation/Foundation.h>

@interface EVEEventsHelpers : NSObject

+ (void) storeDeliveryEventWithUserInfo:(NSDictionary *)userInfo;
+ (void) storeClickEventWithUserInfo:(NSDictionary *)userInfo;
+ (void) storeDismissEventWithUserInfo:(NSDictionary *)userInfo;
+ (void) uploadPendingEventsWithCompletionHandler:(void(^)())completionHandler;

@end