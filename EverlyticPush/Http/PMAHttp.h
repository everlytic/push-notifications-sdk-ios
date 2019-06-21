#import <UIKit/UIKit.h>
#import "../Models/PMA_Subscription.h"
#import "../PMASdkConfiguration.h"


@interface PMAHttp : NSObject

- (PMAHttp *_Nonnull) initWithSdkConfiguration:(PMASdkConfiguration *_Nonnull)sdkConfiguration;

- (void) subscribeWithSubscription:(PMA_Subscription *_Nonnull)subscription completionHandler:(void(^_Nullable)(void))completionHandler;
@end