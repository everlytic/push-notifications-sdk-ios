#import "EVEDefaults.h"


@implementation EVEDefaults

NSString *const KEY_FCM_TOKEN = @"__pma_ev_fcm_token";
NSString *const KEY_DEVICE_ID = @"__pma_ev_device_id";
NSString *const KEY_CONTACT_ID = @"__pma_ev_contact_id";
NSString *const KEY_CONTACT_EMAIL = @"__pma_ev_contact_email";
NSString *const KEY_SUBSCRIPTION_ID = @"__pma_ev_subscription_id";
NSString *const KEY_UPDATED_FCM_TOKEN = @"__pma_ev_updated_fcm_token";

+ (NSString *)deviceId {
    return [self.defaults valueForKey:KEY_DEVICE_ID];
}

+ (void)setDeviceId:(NSString *)deviceId {
    [self.defaults setObject:deviceId forKey:KEY_DEVICE_ID];
}

+ (NSString *)fcmToken {
    return [self.defaults valueForKey:KEY_FCM_TOKEN];
}

+ (void)setFcmToken:(NSString *)fcmToken {
    [self.defaults setObject:fcmToken forKey:KEY_FCM_TOKEN];
}

+ (NSString *)contactId {
    return [self.defaults valueForKey:KEY_CONTACT_ID];
}

+ (void)setContactId:(NSString *)contactId {
    [self.defaults setObject:contactId forKey:KEY_CONTACT_ID];
}

+ (NSString *)contactEmail {
    return [self.defaults valueForKey:KEY_CONTACT_EMAIL];
}

+ (void)setContactEmail:(NSString *)contactEmail {
    [self.defaults setObject:contactEmail forKey:KEY_CONTACT_EMAIL];
}

+ (NSString *)subscriptionId {
    return [self.defaults valueForKey:KEY_SUBSCRIPTION_ID];
}

+ (void)setSubscriptionId:(NSString *)subscriptionId {
    [self.defaults setObject:subscriptionId forKey:KEY_SUBSCRIPTION_ID];
}

+ (NSString *)updatedFcmToken {
    return [self.defaults valueForKey:KEY_UPDATED_FCM_TOKEN];
}

+ (void)setUpdatedFcmToken:(NSString *)updatedFcmToken {
    [self.defaults setObject:updatedFcmToken forKey:KEY_UPDATED_FCM_TOKEN];
}

+ (NSUserDefaults *) defaults {
    return [NSUserDefaults standardUserDefaults];
}
@end