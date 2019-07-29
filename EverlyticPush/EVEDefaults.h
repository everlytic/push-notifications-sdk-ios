#import <UIKit/UIKit.h>


@interface EVEDefaults : NSObject

@property (atomic) NSString *deviceId;
@property (atomic) NSString *fcmToken;
@property (atomic) NSNumber *contactId;
@property (atomic) NSString *contactEmail;
@property (atomic) NSNumber *subscriptionId;
@property (atomic) NSString *updatedFcmToken;
@property (atomic) NSNumber *dbVersion;
@property (atomic) NSNumber *configurationString;

+ (NSString *) deviceId;
+ (NSString *) fcmToken;
+ (NSNumber *) contactId;
+ (NSString *) contactEmail;
+ (NSNumber *) subscriptionId;
+ (NSString *) updatedFcmToken;
+ (NSNumber *) dbVersion;
+ (NSString *) configurationString;
+ (void) setDeviceId:(NSString *)deviceId;
+ (void) setFcmToken:(NSString *)fcmToken;
+ (void) setContactId:(NSNumber *)contactId;
+ (void) setContactEmail:(NSString *)contactEmail;
+ (void) setSubscriptionId:(NSNumber *)subscriptionId;
+ (void) setUpdatedFcmToken:(NSString *)updatedFcmToken;
+ (void) setDbVersion:(NSNumber *)version;
+ (void) setConfigurationString:(NSString *)configurationString;

@end
