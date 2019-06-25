#import <Foundation/Foundation.h>
#import "PMAModel.h"


@interface PMAUnsubscribeEvent : NSObject<PMAModel>

@property (strong, nonatomic) NSString *subscription_id;
@property (strong, nonatomic) NSString *device_id;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSDictionary<NSString *, id> *metadata;

@end