#import <Foundation/Foundation.h>
#import "EVEModel.h"


@interface EVEUnsubscribeEvent : NSObject<EVEModel>

@property (strong, nonatomic) NSString *subscription_id;
@property (strong, nonatomic) NSString *device_id;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSDictionary<NSString *, id> *metadata;

@end