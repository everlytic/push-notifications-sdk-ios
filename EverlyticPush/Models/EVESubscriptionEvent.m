
#import <UIKit/UIKit.h>
#import "EVESubscriptionEvent.h"
#import "EVEHelpers.h"
#import "NSDate+EVEDateFormatter.h"

@implementation EVE_ContactData

- (EVE_ContactData *)initWithEmail:(NSString *)email uniqueId:(NSString *)uniqueId pushToken:(NSString *)pushToken {
    self.uniqueId = uniqueId;
    self.email = email;
    self.pushToken = pushToken;
    return self;
}


- (nonnull NSDictionary *)serializeAsDictionary {
    NSMutableDictionary *dictionary = [@{
            @"push_token": self.pushToken
    } mutableCopy];

    if (self.email != nil) {
        dictionary[@"email"] = self.email;
    }

    if (self.uniqueId != nil) {
        dictionary[@"unique_id"] = self.uniqueId;
    }

    return dictionary;
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end

@implementation EVE_DeviceData
- (EVE_DeviceData *)initWithId:(NSString *)deviceId {
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
    return @{
            @"id": self.id,
            @"manufacturer": self.manufacturer,
            @"model": self.model,
            @"type": self.type
    };
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}


@end

@implementation EVE_PlatformData

- (EVE_PlatformData *)init {
    self.type = @"ios";
    self.version = [[UIDevice currentDevice] systemVersion];
    return self;
}

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{@"type": self.type, @"version": self.version};
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end

@implementation EVESubscriptionEvent

- (EVESubscriptionEvent *)initWithPushProjectUuid:(NSString *)projectUuid contactData:(EVE_ContactData *)contactData deviceData:(EVE_DeviceData *)deviceData {
    self.pushProjectUuid = projectUuid;
    self.contact = contactData;
    self.device = deviceData;
    self.platform = [[EVE_PlatformData alloc] init];

    return self;
}

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"push_project_uuid": self.pushProjectUuid,
            @"contact": self.contact.serializeAsDictionary,
            @"metadata": [[NSDictionary alloc] init],
            @"platform": self.platform.serializeAsDictionary,
            @"device": self.device.serializeAsDictionary,
            @"datetime": [[NSDate date] dateToIso8601String]
    };
}

- (nonnull NSString *)serializeAsJson {
    return [EVEHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end
