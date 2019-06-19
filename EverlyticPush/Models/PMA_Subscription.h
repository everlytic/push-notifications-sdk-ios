
#import <Foundation/Foundation.h>
#import "PMAModel.h"

// ===
@interface PMA_ContactData : NSObject <PMAModel>
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *pushToken;

- (PMA_ContactData *)initWithEmail:(NSString *)email pushToken:(NSString *)pushToken;

@end


// ===
@interface PMA_PlatformData : NSObject <PMAModel>
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *version;

- (PMA_PlatformData *)init;
@end


// ===
@interface PMA_DeviceData : NSObject <PMAModel>
@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *manufacturer;
@property(strong, nonatomic) NSString *model;
@property(strong, nonatomic) NSString *type;

- (PMA_DeviceData *)initWithId:(NSString *)deviceId;

@end


// ===
@interface PMA_Subscription : NSObject <PMAModel>

@property(strong, nonatomic) NSString *pushProjectUuid;
@property(strong, nonatomic) PMA_ContactData *contact;
@property(strong, nonatomic) NSMutableDictionary *metadata;
@property(strong, nonatomic) PMA_PlatformData *platform;
@property(strong, nonatomic) PMA_DeviceData *device;
@property(strong, nonatomic) NSDate *datetime;

- (PMA_Subscription *)initWithPushProjectUuid:(NSString *)projectUuid contactData:(PMA_ContactData *)contactData deviceData:(PMA_DeviceData *)deviceData;

@end