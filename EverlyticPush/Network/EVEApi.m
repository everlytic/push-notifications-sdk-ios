#import "EVEApi.h"
#import "EVEUnsubscribeEvent.h"
#import "EVEHttp.h"
#import "EVEApiSubscription.h"
#import "EVEApiResponse.h"
#import "EVENotificationEvent.h"
#import "../EVEHelpers.h"

@interface EVEApi ()

@property(strong, nonatomic) EVEHttp *http;

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

- (NSURLSessionDataTask *)subscribeWithSubscriptionEvent:(EVESubscriptionEvent *_Nonnull)subscription completionHandler:(void (^ _Nullable)(EVEApiSubscription *_Nullable, NSError *_Nullable))completionHandler {
    return [self executeHttpRequestWithModel:subscription urlPath:subscribeUrl completionHandler:^(EVEApiResponse *response, NSError *error) {
        EVEApiSubscription *apiSubscription = nil;

        if (error == nil && response != nil && response.data[@"subscription"] != nil) {
            apiSubscription = [EVEApiSubscription deserializeFromJsonString:[EVEHelpers encodeJSONFromObject:response.data[@"subscription"]]];
        }

        completionHandler(apiSubscription, error);
    }];
}

- (NSURLSessionDataTask *)unsubscribeWithUnsubscribeEvent:(EVEUnsubscribeEvent *)unsubscribeEvent completionHandler:(void (^)(EVEApiResponse *, NSError *))completionHandler {
    return [self executeHttpRequestWithModel:unsubscribeEvent urlPath:unsubscribeUrl completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)recordClickEvent:(EVENotificationEvent *)event completionHandler:(void (^ _Nullable)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler {
    return [self executeHttpRequestWithModel:event urlPath:clicksUrl completionHandler:completionHandler];
}

- (NSURLSessionDataTask *_Nonnull)recordDeliveryEvent:(EVENotificationEvent *_Nonnull)event completionHandler:(void (^ _Nullable)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler {
    return [self executeHttpRequestWithModel:event urlPath:deliveriesUrl completionHandler:completionHandler];
}

- (NSURLSessionDataTask *_Nonnull)recordDismissEvent:(EVENotificationEvent *_Nonnull)event completionHandler:(void (^ _Nullable)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler {
    return [self executeHttpRequestWithModel:event urlPath:dismissalsUrl completionHandler:completionHandler];
}


- (NSURLSessionDataTask *)executeHttpRequestWithModel:(id <EVEModel>)model urlPath:(NSString *)path completionHandler:(void (^)(EVEApiResponse *, NSError *))completionHandler {
    NSURL *subUrl = [self.http urlForPath:path];
    NSString *payload = [model serializeAsJson];
#ifdef DEBUG
    NSLog(@"payload=%@", payload);
#endif
    NSData *bodyData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [self.http createPostRequestForURL:subUrl bodyData:bodyData];

    return [self.http performApiRequest:request completionHandler:completionHandler];
}

@end
