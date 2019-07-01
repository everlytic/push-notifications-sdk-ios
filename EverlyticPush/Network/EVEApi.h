#import <Foundation/Foundation.h>

@class EVEUnsubscribeEvent;
@class EVEHttp;
@class EVESubscriptionEvent;
@class EVEApiSubscription;
@class EVEApiResponse;
@class EVENotificationEvent;

@interface EVEApi : NSObject

- (EVEApi *_Nonnull)initWithHttpInstance:(EVEHttp *_Nonnull)http;

- (void)subscribeWithSubscriptionEvent:(EVESubscriptionEvent *_Nonnull)subscription completionHandler:(void (^ _Nullable)(EVEApiSubscription *_Nullable, NSError *_Nullable))completionHandler;

- (void)unsubscribeWithUnsubscribeEvent:(EVEUnsubscribeEvent *_Nonnull)unsubscribeEvent completionHandler:(void (^ _Nullable)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler;

- (void)recordClickEvent:(EVENotificationEvent *_Nonnull)event completionHandler:(void (^ _Nullable)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler;
@end
