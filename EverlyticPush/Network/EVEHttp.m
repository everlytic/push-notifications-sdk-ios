
#import "EVEHttp.h"
#import "EVEApiResponse.h"
#import "EVEReachability.h"

@interface EVEHttp ()
@property NSURL *baseUrl;
@property EVESdkConfiguration *sdkConfiguration;
@property EVEReachability *reachability;
@property(nonatomic) NSNumber *backingEndpointReachable;
@end

@implementation EVEHttp

NSString *const basePath = @"/servlet/";

- (EVEHttp *)initWithSdkConfiguration:(EVESdkConfiguration *)sdkConfiguration reachabilityBlock:(void (^)(EVEReachability *, SCNetworkConnectionFlags))innerReachabilityBlock {
    self.sdkConfiguration = sdkConfiguration;
    self.baseUrl = [NSURL URLWithString:basePath relativeToURL:self.sdkConfiguration.installUrl].absoluteURL;
    self.reachability = [EVEReachability reachabilityWithHostname:self.sdkConfiguration.installUrl.host];
    self.backingEndpointReachable = @NO;
    self.reachability.reachabilityBlock = [self reachabilityBlockWith:innerReachabilityBlock];
    [self.reachability startNotifier];
    return self;
}

- (void (^)(EVEReachability *, SCNetworkConnectionFlags))reachabilityBlockWith:(void (^)(EVEReachability *, SCNetworkConnectionFlags))reachabilityBlock {
    return ^(EVEReachability *reachability, SCNetworkConnectionFlags flags) {
        NSLog(@"Network status changed, reachable: %d", reachability.isReachable);
        @synchronized (_backingEndpointReachable) {
            _backingEndpointReachable = @(reachability.isReachable);

        }
        if (reachabilityBlock != nil) {
            reachabilityBlock(reachability, flags);
        }
    };
}

- (NSMutableURLRequest *)createPostRequestForURL:(NSURL *)subUrl bodyData:(NSData *)bodyData {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:subUrl];
    [request setHTTPMethod:@"POST"];
    [self setHeadersOnRequest:request];
    [request setHTTPBody:bodyData];
    return request;
}

- (NSURLSessionDataTask *)performApiRequest:(NSMutableURLRequest *)request completionHandler:(void (^)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler {

    if (![self endpointReachable]) {
        if (completionHandler != nil)
            completionHandler(nil, [NSError errorWithDomain:@"EVENetwork" code:0 userInfo:nil]);
        return nil;
    }

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
            dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (completionHandler != nil) {
                    EVEApiResponse *apiResponse = nil;
#ifdef DEBUG
                    NSLog(@"response=%@, error=%@", response, error != nil ? error : NO);
#endif
                    if (error == nil) {
                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        apiResponse = [EVEApiResponse deserializeFromJsonString:jsonString];

#ifdef DEBUG
                        NSLog(@"raw=%@;; apiResponse=%@", jsonString, apiResponse);
#endif
                    }
                    completionHandler(apiResponse, error);
                }
            }];

    [task setPriority:0.1f];
    [task resume];
    return task;
}

- (NSURL *)urlForPath:(NSString *)path {
    return [NSURL URLWithString:path relativeToURL:self.baseUrl];
}

- (void)setHeadersOnRequest:(NSMutableURLRequest *)request {
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.sdkConfiguration.projectId forHTTPHeaderField:@"X-EV-Project-UUID"];
    [request setValue:@"ios experimental" forHTTPHeaderField:@"X-EV-SDK-Version-Name"];
    [request setValue:self.sdkConfiguration.sdkVersion forHTTPHeaderField:@"X-EV-SDK-Version-Code"];
}

- (BOOL)endpointReachable {
    return [_backingEndpointReachable boolValue];
}


@end
