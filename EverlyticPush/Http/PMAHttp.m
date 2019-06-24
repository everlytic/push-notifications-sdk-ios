
#import "PMAHttp.h"

@interface PMAHttp ()
@property NSURL *baseUrl;
@property PMASdkConfiguration *sdkConfiguration;
@end

@implementation PMAHttp

NSString *const basePath = @"/servlet/";
NSString *const subscribeUrl = @"push-notifications/subscribe";

- (PMAHttp *)initWithSdkConfiguration:(PMASdkConfiguration *)sdkConfiguration {
    self.sdkConfiguration = sdkConfiguration;
    self.baseUrl = [NSURL URLWithString:basePath relativeToURL:self.sdkConfiguration.installUrl].absoluteURL;
    return self;
}

- (void)subscribeWithSubscription:(PMA_Subscription *_Nonnull)subscription completionHandler:(void (^ _Nullable)(void))completionHandler {

    NSURL *subUrl = [NSURL URLWithString:subscribeUrl relativeToURL:self.baseUrl];

    NSLog(@"built url=%@", subUrl);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:subUrl];

    NSString *payload = [subscription serializeAsJson];

    NSLog(@"payload=%@", payload);

    NSData *bodyData = [payload dataUsingEncoding:NSUTF8StringEncoding];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.sdkConfiguration.projectId forHTTPHeaderField:@"X-EV-Project-UUID"];
    [request setValue:@"ios experimental" forHTTPHeaderField:@"X-EV-SDK-Version-Name"];
    [request setValue:@"00000000" forHTTPHeaderField:@"X-EV-SDK-Version-Code"];
    [request setHTTPBody:bodyData];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
            dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"data=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                NSLog(@"response=%@", response);
                NSLog(@"error=%@", error);
            }];

    [task resume];
}


@end
