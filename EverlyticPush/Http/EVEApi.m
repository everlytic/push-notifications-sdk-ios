#import "EVEApi.h"
#import "EVEUnsubscribeEvent.h"
#import "EVEHttp.h"
#import "EVESubscriptionEvent.h"
#import "EVEApiSubscription.h"
#import "EVEApiResponse.h"
#import "EVENotificationEvent.h"

@interface EVEApi ()

@property (strong, nonatomic) EVEHttp *http;

@end

@implementation EVEApi

NSString *const subscribeUrl = @"push-notifications/subscribe";
NSString *const unsubscribeUrl = @"push-notifications/unsubscribe";
NSString *const clicksUrl = @"push-notifications/clicks";
NSString *const deliveriesUrl = @"push-notifications/deliveries";
NSString *const dismissalsUrl = @"push-notifications/dismissals";

- (EVEApi *_Nonnull)initWithHttpInstance:(EVEHttp *_Nonnull)http {
    self.http = http;

    return self;
}

- (void)subscribeWithSubscriptionEvent:(EVESubscriptionEvent *_Nonnull)subscription completionHandler:(void (^ _Nullable)(EVEApiSubscription *_Nullable, NSError *_Nullable))completionHandler {
    [self executeHttpRequestWithModel:subscription urlPath:subscribeUrl completionHandler:^(EVEApiResponse *response, NSError *error) {
        EVEApiSubscription *apiSubscription = nil;

        if (error == nil && response != nil) {
            apiSubscription = [EVEApiSubscription deserializeFromJsonString:response.dataAsJsonString];
        }

        completionHandler(apiSubscription, error);
    }];
}

- (void)unsubscribeWithUnsubscribeEvent:(EVEUnsubscribeEvent *)unsubscribeEvent completionHandler:(void (^)(EVEApiResponse *, NSError *))completionHandler {
    [self executeHttpRequestWithModel:unsubscribeEvent urlPath:unsubscribeUrl completionHandler:completionHandler];
}

- (void)recordClickEvent:(EVENotificationEvent *)event completionHandler:(void (^ _Nullable)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler {
    [self executeHttpRequestWithModel:event urlPath:clicksUrl completionHandler:completionHandler];
}


- (void) executeHttpRequestWithModel:(id<EVEModel>)model urlPath:(NSString *)path completionHandler:(void (^)(EVEApiResponse *, NSError *))completionHandler{
    NSURL *subUrl = [self.http urlForPath:path];
    NSString *payload = [model serializeAsJson];
    NSLog(@"payload=%@", payload);
    NSData *bodyData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [self.http createPostRequestForURL:subUrl bodyData:bodyData];

    [self.http performApiRequest:request completionHandler:completionHandler];
}

@end