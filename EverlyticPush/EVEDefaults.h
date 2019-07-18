#import <UIKit/UIKit.h>


@interface EVEDefaults : NSObject

@property (atomic) NSString *deviceId;
@property (atomic) NSString *fcmToken;
@property (atomic) NSInteger *contactId;
@property (atomic) NSString *contactEmail;
@property (atomic) NSInteger *subscriptionId;
@property (atomic) NSString *updatedFcmToken;
@property (atomic) NSInteger *dbVersion;
@property (atomic) NSInteger *configurationString;

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
