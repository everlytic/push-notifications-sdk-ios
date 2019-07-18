#import "EVEDefaults.h"
#import "EVEHelpers.h"

@interface EVEDefaults ()

@end

@implementation EVEDefaults

NSString *const kFcmToken = @"__eve_kv_fcm_token";
NSString *const kDeviceId = @"__eve_kv_device_id";
NSString *const kContactId = @"__eve_kv_contact_id";
NSString *const kContactEmail = @"__eve_kv_contact_email";
NSString *const kSubscriptionId = @"__eve_kv_subscription_id";
NSString *const kUpdatedFcmToken = @"__eve_kv_updated_fcm_token";
NSString *const kDbVersion = @"__eve_kv_db_version";
NSString *const kConfigurationString = @"__eve_kv_configuration_string";
NSUserDefaults *sharedDefaults = nil;

+ (NSNumber *)dbVersion {
    return [[NSNumber alloc] initWithInt:[[self.defaults objectForKey:kDbVersion] intValue]];
}

+ (void)setDbVersion:(NSNumber *)version {
    [self.defaults setObject:version forKey:kDbVersion];
    [self.defaults synchronize];
}

+ (NSString *)deviceId {
    NSString *devId = [self.defaults valueForKey:kDeviceId];
    return devId;
}

+ (void)setDeviceId:(NSString *)deviceId {
    [self.defaults setObject:deviceId forKey:kDeviceId];
    [self.defaults synchronize];
}

+ (NSString *)fcmToken {
    return [self.defaults valueForKey:kFcmToken];
}

+ (void)setFcmToken:(NSString *)fcmToken {
    [self.defaults setObject:fcmToken forKey:kFcmToken];
    [self.defaults synchronize];
}

+ (NSNumber *)contactId {
    return [[NSNumber alloc] initWithInt:[[self.defaults objectForKey:kContactId] intValue]];
}

+ (void)setContactId:(NSNumber *)contactId {
    [self.defaults setObject:contactId forKey:kContactId];
    [self.defaults synchronize];
}

+ (NSString *)contactEmail {
    return [self.defaults valueForKey:kContactEmail];
}

+ (void)setContactEmail:(NSString *)contactEmail {
    [self.defaults setObject:contactEmail forKey:kContactEmail];
    [self.defaults synchronize];
}

+ (NSNumber *)subscriptionId {
    id objForK = [self.defaults objectForKey:kSubscriptionId];
    return [[NSNumber alloc] initWithInt:[objForK intValue]];
}

+ (void)setSubscriptionId:(NSNumber *)subscriptionId {
    [self.defaults setObject:subscriptionId forKey:kSubscriptionId];
    [self.defaults synchronize];
}

+ (NSString *)updatedFcmToken {
    return [self.defaults valueForKey:kUpdatedFcmToken];
}

+ (void)setUpdatedFcmToken:(NSString *)updatedFcmToken {
    [self.defaults setObject:updatedFcmToken forKey:kUpdatedFcmToken];
    [self.defaults synchronize];
}

+ (NSString *)configurationString {
    return [self.defaults stringForKey:kConfigurationString];
}

+ (void)setConfigurationString:(NSString *)configurationString {
    [self.defaults setObject:configurationString forKey:kConfigurationString];
    [self.defaults synchronize];
}


+ (NSUserDefaults *) defaults {
    if (sharedDefaults == nil) {
#ifdef DEBUG
        NSLog(@"Init sharedDefaults");
#endif
        sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:EVEHelpers.appGroupName];
    }
    
    return sharedDefaults;
}
@end
