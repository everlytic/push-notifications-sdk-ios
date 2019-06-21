#import "PMAFIRMessagingDelegate.h"
#import "PMADefaults.h"

NSString *const FCM_TOKEN_KEY = @"_pma_fcm_token";

@implementation PMAFIRMessagingDelegate
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {

    PMADefaults.fcmToken = fcmToken;

#if DEBUG
    NSLog(@"New FCM Token=%@", fcmToken);
#endif
}

- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received remote message, id=%@", remoteMessage.messageID);
}

@end