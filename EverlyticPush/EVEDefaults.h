#import <UIKit/UIKit.h>


@interface EVEDefaults : NSObject

@property (atomic) NSString *deviceId;
@property (atomic) NSString *fcmToken;
@property (atomic) NSInteger *contactId;
@property (atomic) NSString *contactEmail;
@property (atomic) NSInteger *subscriptionId;
@property (atomic) NSString *updatedFcmToken;
@property (atomic) NSInteger *dbVersion;

+ (NSString *) deviceId;
+ (NSString *) fcmToken;
+ (NSInteger *) contactId;
+ (NSString *) contactEmail;
+ (NSInteger *) subscriptionId;
+ (NSString *) updatedFcmToken;
+ (NSInteger *) dbVersion;
+ (void) setDeviceId:(NSString *)deviceId;
+ (void) setFcmToken:(NSString *)fcmToken;
+ (void) setContactId:(NSInteger *)contactId;
+ (void) setContactEmail:(NSString *)contactEmail;
+ (void) setSubscriptionId:(NSInteger *)subscriptionId;
+ (void) setUpdatedFcmToken:(NSString *)updatedFcmToken;
+ (void) setDbVersion:(NSNumber *)version;

@end
