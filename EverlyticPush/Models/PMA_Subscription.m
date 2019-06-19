
#import <UIKit/UIKit.h>
#import "PMA_Subscription.h"

@implementation PMA_ContactData

- (PMA_ContactData *)initWithEmail:(NSString *)email pushToken:(NSString *)pushToken {
    self.email = email;
    self.pushToken = pushToken;
    return self;
}


- (nonnull NSString *)serializeAsJson {
    return nil;
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


- (nonnull NSString *)serializeAsJson {
    return nil;
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


- (nonnull NSString *)serializeAsJson {
    return nil;
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end

@implementation PMA_Subscription
- (PMA_Subscription *)initWithPushProjectUuid:(NSString *)projectUuid contactData:(PMA_ContactData *)contactData deviceData:(PMA_DeviceData *)deviceData {
    return nil;
}

- (nonnull NSString *)serializeAsJson {
    return nil;
}

+ (id)deserializeFromJsonString:(NSString *_Nonnull)string {
    return nil;
}

@end