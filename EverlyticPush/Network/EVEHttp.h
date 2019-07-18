#import <UIKit/UIKit.h>
#import "../Models/EVESubscriptionEvent.h"
#import "../EVESdkConfiguration.h"

@class EVEApiSubscription;
@class EVEApiResponse;


@interface EVEHttp : NSObject

- (EVEHttp *_Nonnull)initWithSdkConfiguration:(EVESdkConfiguration *_Nonnull)sdkConfiguration;

- (NSMutableURLRequest *)createPostRequestForURL:(NSURL *)subUrl bodyData:(NSData *)bodyData;

- (NSURLSessionDataTask *)performApiRequest:(NSMutableURLRequest *)request completionHandler:(void (^)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler;

- (NSURL *)urlForPath:(NSString *)path;
@end