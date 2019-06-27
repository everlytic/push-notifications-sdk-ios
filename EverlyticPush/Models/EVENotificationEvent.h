#import <Foundation/Foundation.h>
#import "EVEModel.h"


@interface EVENotificationEvent : NSObject<EVEModel>

@property (strong, nonatomic) NSNumber *subscription_id;
@property (strong, nonatomic) NSNumber *message_id;
@property (strong, nonatomic) NSDictionary *metadata;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSNumber *type;

@end