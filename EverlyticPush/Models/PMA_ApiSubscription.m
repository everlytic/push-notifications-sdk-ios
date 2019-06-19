#import "PMA_ApiSubscription.h"
#import "PMAHelpers.h"

@implementation PMA_ApiSubscription

- (id) initWithId:(NSString *)id listId:(NSString *)listId customerId:(NSString *)customerId contactId:(NSString *)contactId deviceId:(NSString *)deviceId {
    self.pns_id = id;
    self.pns_list_id = listId;
    self.pns_customer_id = customerId;
    self.pns_contact_id = contactId;
    self.pns_device_id = deviceId;
    return self;
}

- (nonnull NSString *)serializeAsJson {
    return nil;
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {

    NSDictionary *object = (NSDictionary *) [PMAHelpers decodeJSONFromString:string];

    return [[PMA_ApiSubscription alloc]
            initWithId:[object valueForKey:@"pns_id"]
                listId:[object valueForKey:@"pns_list_id"]
            customerId:[object valueForKey:@"pns_customer_id"]
             contactId:[object valueForKey:@"pns_contact_id"]
              deviceId:[object valueForKey:@"pns_device_id"]];
}


@end
