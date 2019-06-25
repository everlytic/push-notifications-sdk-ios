
#import <UIKit/UIKit.h>
#import "PMASubscriptionEvent.h"
#import "PMAHelpers.h"

@implementation PMA_ContactData

- (PMA_ContactData *)initWithEmail:(NSString *)email pushToken:(NSString *)pushToken {
    self.email = email;
    self.pushToken = pushToken;
    return self;
}


- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"email": self.email,
            @"push_token": self.pushToken
    };
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
    return @{
            @"id": self.id,
            @"manufacturer": self.manufacturer,
            @"model": self.model,
            @"type": self.type
    };
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
    return @{@"type": self.type, @"version": self.version};
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end

@implementation PMASubscriptionEvent

- (PMASubscriptionEvent *)initWithPushProjectUuid:(NSString *)projectUuid contactData:(PMA_ContactData *)contactData deviceData:(PMA_DeviceData *)deviceData {
    self.pushProjectUuid = projectUuid;
    self.contact = contactData;
    self.device = deviceData;
    self.platform = [[PMA_PlatformData alloc] init];

    return self;
}

- (nonnull NSDictionary *)serializeAsDictionary {
    return @{
            @"push_project_uuid": self.pushProjectUuid,
            @"contact": self.contact.serializeAsDictionary,
            @"metadata": [[NSDictionary alloc] init],
            @"platform": self.platform.serializeAsDictionary,
            @"device": self.device.serializeAsDictionary,
            @"datetime": [[PMAHelpers iso8601DateFormatter] stringFromDate:[NSDate date]]
    };
}

- (nonnull NSString *)serializeAsJson {
    return [PMAHelpers encodeJSONFromObject:self.serializeAsDictionary];
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end
