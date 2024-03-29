#import <Foundation/Foundation.h>
#import "EVEModel.h"


@interface EVEUnsubscribeEvent : NSObject<EVEModel>

- (instancetype)initWithSubscriptionId:(NSNumber *)subscriptionId deviceId:(NSString *)deviceId;

@property (strong, nonatomic) NSNumber *subscription_id;
@property (strong, nonatomic) NSString *device_id;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSDictionary<NSString *, id> *metadata;

@end