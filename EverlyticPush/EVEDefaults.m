#import "EVEDefaults.h"


@implementation EVEDefaults

NSString *const kFcmToken = @"__eve_kv_fcm_token";
NSString *const kDeviceId = @"__eve_kv_device_id";
NSString *const kContactId = @"__eve_kv_contact_id";
NSString *const kContactEmail = @"__eve_kv_contact_email";
NSString *const kSubscriptionId = @"__eve_kv_subscription_id";
NSString *const kUpdatedFcmToken = @"__eve_kv_updated_fcm_token";
NSString *const kDbVersion = @"__eve_kv_db_version";

+ (unsigned int)dbVersion {
    return (unsigned int) [self.defaults integerForKey:kDbVersion];
}

+ (void)setDbVersion:(unsigned int)version {
    [self.defaults setInteger:version forKey:kDbVersion];
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

+ (unsigned long)contactId {
    return (unsigned long) [self.defaults integerForKey:kContactId];
}

+ (void)setContactId:(unsigned long)contactId {
    [self.defaults setInteger:contactId forKey:kContactId];
}

+ (NSString *)contactEmail {
    return [self.defaults valueForKey:kContactEmail];
}

+ (void)setContactEmail:(NSString *)contactEmail {
    [self.defaults setObject:contactEmail forKey:kContactEmail];
}

+ (unsigned long)subscriptionId {
    return (unsigned long) [self.defaults integerForKey:kSubscriptionId];
}

+ (void)setSubscriptionId:(unsigned long)subscriptionId {
    [self.defaults setInteger:subscriptionId forKey:kSubscriptionId];
}

+ (NSString *)updatedFcmToken {
    return [self.defaults valueForKey:kUpdatedFcmToken];
}

+ (void)setUpdatedFcmToken:(NSString *)updatedFcmToken {
    [self.defaults setObject:updatedFcmToken forKey:kUpdatedFcmToken];
}

+ (NSUserDefaults *) defaults {
    return [NSUserDefaults standardUserDefaults];
}
@end