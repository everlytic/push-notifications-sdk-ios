#import <Foundation/Foundation.h>

@class PMAUnsubscribeEvent;
@class PMAHttp;
@class PMASubscriptionEvent;
@class PMAApiSubscription;
@class PMAApiResponse;
@class PMANotificationEvent;

@interface PMAApi : NSObject

- (PMAApi *_Nonnull)initWithHttpInstance:(PMAHttp *_Nonnull)http;

- (void)subscribeWithSubscriptionEvent:(PMASubscriptionEvent *_Nonnull)subscription completionHandler:(void (^ _Nullable)(PMAApiSubscription *_Nullable, NSError *_Nullable))completionHandler;

- (void)unsubscribeWithUnsubscribeEvent:(PMAUnsubscribeEvent *_Nonnull)unsubscribeEvent completionHandler:(void (^ _Nullable)(PMAApiResponse *_Nullable, NSError *_Nullable))completionHandler;

- (void)recordClickEvent:(PMANotificationEvent *_Nonnull)event completionHandler:(void (^ _Nullable)(PMAApiResponse *_Nullable, NSError *_Nullable))completionHandler;
@end
