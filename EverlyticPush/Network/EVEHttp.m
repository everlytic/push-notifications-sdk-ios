
#import "EVEHttp.h"
#import "EVEApiResponse.h"

@interface EVEHttp ()
@property NSURL *baseUrl;
@property EVESdkConfiguration *sdkConfiguration;
@end

@implementation EVEHttp

NSString *const basePath = @"/servlet/";

- (EVEHttp *)initWithSdkConfiguration:(EVESdkConfiguration *)sdkConfiguration {
    self.sdkConfiguration = sdkConfiguration;
    self.baseUrl = [NSURL URLWithString:basePath relativeToURL:self.sdkConfiguration.installUrl].absoluteURL;
    return self;
}

- (NSMutableURLRequest *)createPostRequestForURL:(NSURL *)subUrl bodyData:(NSData *)bodyData {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:subUrl];
    [request setHTTPMethod:@"POST"];
    [self setHeadersOnRequest:request];
    [request setHTTPBody:bodyData];
    return request;
}

- (void)performApiRequest:(NSMutableURLRequest *)request completionHandler:(void (^)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
            dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (completionHandler != nil) {
                    EVEApiResponse *apiResponse = nil;

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

    [task resume];
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


@end
