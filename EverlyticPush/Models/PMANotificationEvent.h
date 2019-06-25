#import <Foundation/Foundation.h>
#import "PMAModel.h"


@interface PMANotificationEvent : NSObject<PMAModel>

@property (strong, nonatomic) NSNumber *subscription_id;
@property (strong, nonatomic) NSNumber *message_id;
@property (strong, nonatomic) NSDictionary *metadata;
@property (strong, nonatomic) NSDate *datetime;
@property (strong, nonatomic) NSNumber *type;

@end