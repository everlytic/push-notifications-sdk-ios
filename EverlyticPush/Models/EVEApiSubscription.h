#import <UIKit/UIKit.h>
#import "EVEModel.h"

@interface EVEApiSubscription : NSObject<EVEModel>

@property (strong, nonatomic) NSString *_Nonnull pns_id;
@property (strong, nonatomic) NSString *_Nonnull pns_list_id;
@property (strong, nonatomic) NSString *_Nonnull pns_customer_id;
@property (strong, nonatomic) NSString *_Nonnull pns_contact_id;
@property (strong, nonatomic) NSString *_Nonnull pns_device_id;

@end