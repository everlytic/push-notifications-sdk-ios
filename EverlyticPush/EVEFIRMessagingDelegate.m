#import "EVEFIRMessagingDelegate.h"
#import "EVEDefaults.h"

NSString *const FCM_TOKEN_KEY = @"_pma_fcm_token";

@implementation EVEFIRMessagingDelegate
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {

    EVEDefaults.fcmToken = fcmToken;

#if DEBUG
    NSLog(@"New FCM Token=%@", fcmToken);
#endif
}

- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received remote message, id=%@", remoteMessage.messageID);
}

@end