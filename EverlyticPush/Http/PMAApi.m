#import "PMAApi.h"
#import "PMAUnsubscribeEvent.h"
#import "PMAHttp.h"
#import "PMASubscriptionEvent.h"
#import "PMAApiSubscription.h"
#import "PMAApiResponse.h"
#import "PMANotificationEvent.h"

@interface PMAApi ()

@property (strong, nonatomic) PMAHttp *http;

@end

@implementation PMAApi

NSString *const subscribeUrl = @"push-notifications/subscribe";
NSString *const unsubscribeUrl = @"push-notifications/unsubscribe";
NSString *const clicksUrl = @"push-notifications/clicks";
NSString *const deliveriesUrl = @"push-notifications/deliveries";
NSString *const dismissalsUrl = @"push-notifications/dismissals";

- (PMAApi *_Nonnull)initWithHttpInstance:(PMAHttp *_Nonnull)http {
    self.http = http;

    return self;
}

- (void)subscribeWithSubscriptionEvent:(PMASubscriptionEvent *_Nonnull)subscription completionHandler:(void (^ _Nullable)(PMAApiSubscription *_Nullable, NSError *_Nullable))completionHandler {
    [self executeHttpRequestWithModel:subscription urlPath:subscribeUrl completionHandler:^(PMAApiResponse *response, NSError *error) {
        PMAApiSubscription *apiSubscription = nil;

        if (error == nil && response != nil) {
            apiSubscription = [PMAApiSubscription deserializeFromJsonString:response.dataAsJsonString];
        }

        completionHandler(apiSubscription, error);
    }];
}

- (void)unsubscribeWithUnsubscribeEvent:(PMAUnsubscribeEvent *)unsubscribeEvent completionHandler:(void (^)(PMAApiResponse *, NSError *))completionHandler {
    [self executeHttpRequestWithModel:unsubscribeEvent urlPath:unsubscribeUrl completionHandler:completionHandler];
}

- (void)recordClickEvent:(PMANotificationEvent *)event completionHandler:(void (^ _Nullable)(PMAApiResponse *_Nullable, NSError *_Nullable))completionHandler {
    [self executeHttpRequestWithModel:event urlPath:clicksUrl completionHandler:completionHandler];
}


- (void) executeHttpRequestWithModel:(id<PMAModel>)model urlPath:(NSString *)path completionHandler:(void (^)(PMAApiResponse *, NSError *))completionHandler{
    NSURL *subUrl = [self.http urlForPath:path];
    NSString *payload = [model serializeAsJson];
    NSLog(@"payload=%@", payload);
    NSData *bodyData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [self.http createPostRequestForURL:subUrl bodyData:bodyData];

    [self.http performApiRequest:request completionHandler:^(PMAApiResponse *response, NSError *error) {
        PMAApiResponse *apiSubscription = nil;

        if (error == nil && response != nil) {
            apiSubscription = [PMAApiSubscription deserializeFromJsonString:response.dataAsJsonString];
        }

        completionHandler(apiSubscription, error);
    }];
}

@end