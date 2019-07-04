#import <UIKit/UIKit.h>


@interface EVEDefaults : NSObject

@property (atomic) NSString *deviceId;
@property (atomic) NSString *fcmToken;
@property (atomic) unsigned long contactId;
@property (atomic) NSString *contactEmail;
@property (atomic) unsigned long subscriptionId;
@property (atomic) NSString *updatedFcmToken;
@property (atomic) unsigned int dbVersion;

+ (NSString *) deviceId;
+ (NSString *) fcmToken;
+ (unsigned long) contactId;
+ (NSString *) contactEmail;
+ (unsigned long) subscriptionId;
+ (NSString *) updatedFcmToken;
+ (unsigned int) dbVersion;
+ (void) setDeviceId:(NSString *)deviceId;
+ (void) setFcmToken:(NSString *)fcmToken;
+ (void) setContactId:(unsigned long)contactId;
+ (void) setContactEmail:(NSString *)contactEmail;
+ (void) setSubscriptionId:(unsigned long)subscriptionId;
+ (void) setUpdatedFcmToken:(NSString *)updatedFcmToken;
+ (void) setDbVersion:(unsigned int)version;

@end