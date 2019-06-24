
#import <UIKit/UIKit.h>
#import "PMA_Subscription.h"
#import "PMAHelpers.h"

@implementation PMA_ContactData

- (PMA_ContactData *)initWithEmail:(NSString *)email pushToken:(NSString *)pushToken {
    self.email = email;
    self.pushToken = pushToken;
    return self;
}


- (nonnull NSDictionary *)serializeAsDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"email"] = self.email;
    dictionary[@"push_token"] = self.pushToken;

    return dictionary;
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end

@implementation PMA_DeviceData
- (PMA_DeviceData *)initWithId:(NSString *)deviceId {
    self.id = deviceId;
    self.manufacturer = @"Apple";
    self.model = [[UIDevice currentDevice] model];

    NSString *deviceType = @"handset";

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        deviceType = @"tablet";
    }

    self.type = deviceType;
    return self;
}


- (nonnull NSDictionary *)serializeAsDictionary {

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"id"] = self.id;
    dictionary[@"manufacturer"] = self.manufacturer;
    dictionary[@"model"] = self.model;
    dictionary[@"type"] = self.type;

    return dictionary;
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end

@implementation PMA_PlatformData

- (PMA_PlatformData *)init {
    self.type = @"ios";
    self.version = [[UIDevice currentDevice] systemVersion];
    return self;
}

- (nonnull NSDictionary *)serializeAsDictionary {

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"type"] = self.type;
    dictionary[@"version"] = self.version;

    return dictionary;
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end

@implementation PMA_Subscription

- (PMA_Subscription *)initWithPushProjectUuid:(NSString *)projectUuid contactData:(PMA_ContactData *)contactData deviceData:(PMA_DeviceData *)deviceData {
    self.pushProjectUuid = projectUuid;
    self.contact = contactData;
    self.device = deviceData;
    self.platform = [[PMA_PlatformData alloc] init];

    return self;
}

- (nonnull NSDictionary *)serializeAsDictionary {

    NSMutableDictionary<NSString *, id> *dictionary = [[NSMutableDictionary alloc] init];

    dictionary[@"push_project_uuid"] = self.pushProjectUuid;
    dictionary[@"contact"] = self.contact.serializeAsDictionary;
    dictionary[@"metadata"] = [[NSDictionary alloc] init];
    dictionary[@"platform"] = self.platform.serializeAsDictionary;
    dictionary[@"device"] = self.device.serializeAsDictionary;
    dictionary[@"datetime"] = [[PMAHelpers iso8601DateFormatter] stringFromDate:[NSDate date]];

    return dictionary;
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end
