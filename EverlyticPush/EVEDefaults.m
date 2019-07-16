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
NSUserDefaults *sharedDefaults = nil;

+ (NSInteger *)dbVersion {
    NSInteger *const version = (NSInteger *) [[self.defaults objectForKey:kDbVersion] intValue];
    NSLog(@"retrieved dbVersion=%@", [NSValue valueWithPointer:version]);
    return version;
}

+ (void)setDbVersion:(NSNumber *)version {
    [self.defaults setObject:version forKey:kDbVersion];
    [self.defaults synchronize];
}

+ (NSString *)deviceId {
    NSString *devId = [self.defaults valueForKey:kDeviceId];
    NSLog(@"retrieved deviceId=%@", devId);
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

+ (NSInteger *)contactId {
    return (NSInteger *) [[self.defaults objectForKey:kContactId] intValue];
}

+ (void)setContactId:(NSInteger *)contactId {
    [self.defaults setObject:@((int) contactId) forKey:kContactId];
    [self.defaults synchronize];
}

+ (NSString *)contactEmail {
    return [self.defaults valueForKey:kContactEmail];
}

+ (void)setContactEmail:(NSString *)contactEmail {
    [self.defaults setObject:contactEmail forKey:kContactEmail];
    [self.defaults synchronize];
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
    [self.defaults synchronize];
    NSLog(@"will sync sub id");
}

+ (NSString *)updatedFcmToken {
    return [self.defaults valueForKey:kUpdatedFcmToken];
}

+ (void)setUpdatedFcmToken:(NSString *)updatedFcmToken {
    [self.defaults setObject:updatedFcmToken forKey:kUpdatedFcmToken];
    [self.defaults synchronize];
}

+ (NSUserDefaults *) defaults {
    if (sharedDefaults == nil) {
        NSLog(@"init sharedDefaults");
        sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:EVEHelpers.appGroupName];
    }
    
    return sharedDefaults;
}
@end
