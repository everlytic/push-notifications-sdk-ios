
#import <Foundation/Foundation.h>
#import "EVEModel.h"

// ===
@interface EVE_ContactData : NSObject <EVEModel>
@property(strong, nonatomic) NSString *uniqueId;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *pushToken;

- (EVE_ContactData *)initWithEmail:(NSString *)email uniqueId:(NSString *)uniqueId pushToken:(NSString *)pushToken;

@end


// ===
@interface EVE_PlatformData : NSObject <EVEModel>
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *version;

- (EVE_PlatformData *)init;
@end


// ===
@interface EVE_DeviceData : NSObject <EVEModel>
@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *manufacturer;
@property(strong, nonatomic) NSString *model;
@property(strong, nonatomic) NSString *type;

- (EVE_DeviceData *)initWithId:(NSString *)deviceId;

@end


// ===
@interface EVESubscriptionEvent : NSObject <EVEModel>

@property(strong, nonatomic) NSString *pushProjectUuid;
@property(strong, nonatomic) EVE_ContactData *contact;
@property(strong, nonatomic) NSMutableDictionary *metadata;
@property(strong, nonatomic) EVE_PlatformData *platform;
@property(strong, nonatomic) EVE_DeviceData *device;
@property(strong, nonatomic) NSDate *datetime;

- (EVESubscriptionEvent *)initWithPushProjectUuid:(NSString *)projectUuid contactData:(EVE_ContactData *)contactData deviceData:(EVE_DeviceData *)deviceData;

@end