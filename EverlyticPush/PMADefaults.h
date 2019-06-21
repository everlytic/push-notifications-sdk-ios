#import <UIKit/UIKit.h>


@interface PMADefaults : NSObject

@property (atomic) NSString *deviceId;
@property (atomic) NSString *fcmToken;
@property (atomic) NSString *contactId;
@property (atomic) NSString *contactEmail;
@property (atomic) NSString *subscriptionId;
@property (atomic) NSString *updatedFcmToken;

+ (NSString *) deviceId;
+ (NSString *) fcmToken;
+ (NSString *) contactId;
+ (NSString *) contactEmail;
+ (NSString *) subscriptionId;
+ (NSString *) updatedFcmToken;
+ (void) setDeviceId:(NSString *)deviceId;
+ (void) setFcmToken:(NSString *)fcmToken;
+ (void) setContactId:(NSString *)contactId;
+ (void) setContactEmail:(NSString *)contactEmail;
+ (void) setSubscriptionId:(NSString *)subscriptionId;
+ (void) setUpdatedFcmToken:(NSString *)updatedFcmToken;

@end