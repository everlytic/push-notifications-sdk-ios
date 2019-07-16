#import "EVEDefaults.h"
#import "EVEHelpers.h"

@implementation EVEDefaults

NSString *const kFcmToken = @"__eve_kv_fcm_token";
NSString *const kDeviceId = @"__eve_kv_device_id";
NSString *const kContactId = @"__eve_kv_contact_id";
NSString *const kContactEmail = @"__eve_kv_contact_email";
NSString *const kSubscriptionId = @"__eve_kv_subscription_id";
NSString *const kUpdatedFcmToken = @"__eve_kv_updated_fcm_token";
NSString *const kDbVersion = @"__eve_kv_db_version";

+ (NSInteger *)dbVersion {
    return (NSInteger *) [[self.defaults objectForKey:kDbVersion] intValue];
}

+ (void)setDbVersion:(NSNumber *)version {
    [self.defaults setObject:version forKey:kDbVersion];
}

+ (NSString *)deviceId {
    return [self.defaults valueForKey:kDeviceId];
}

+ (void)setDeviceId:(NSString *)deviceId {
    [self.defaults setObject:deviceId forKey:kDeviceId];
}

+ (NSString *)fcmToken {
    return [self.defaults valueForKey:kFcmToken];
}

+ (void)setFcmToken:(NSString *)fcmToken {
    [self.defaults setObject:fcmToken forKey:kFcmToken];
}

+ (NSInteger *)contactId {
    return (NSInteger *) [[self.defaults objectForKey:kContactId] intValue];
}

+ (void)setContactId:(NSInteger *)contactId {
    [self.defaults setObject:@((int) contactId) forKey:kContactId];
}

+ (NSString *)contactEmail {
    return [self.defaults valueForKey:kContactEmail];
}

+ (void)setContactEmail:(NSString *)contactEmail {
    [self.defaults setObject:contactEmail forKey:kContactEmail];
}

+ (NSInteger *)subscriptionId {
    id objForK = [self.defaults objectForKey:kSubscriptionId];
    NSInteger *value = (NSInteger *) [objForK intValue];
    NSLog(@"retrieved subId from defaults=%p", value);
    return value;
}

+ (void)setSubscriptionId:(NSInteger *)subscriptionId {
    NSLog(@"setting subId = %p", subscriptionId);
    [self.defaults setObject:@((int) subscriptionId) forKey:kSubscriptionId];
}

+ (NSString *)updatedFcmToken {
    return [self.defaults valueForKey:kUpdatedFcmToken];
}

+ (void)setUpdatedFcmToken:(NSString *)updatedFcmToken {
    [self.defaults setObject:updatedFcmToken forKey:kUpdatedFcmToken];
}

+ (NSUserDefaults *) defaults {
    return [[NSUserDefaults alloc] initWithSuiteName:EVEHelpers.appGroupName];
}
@end
