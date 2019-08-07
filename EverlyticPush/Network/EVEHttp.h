#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "../Models/EVESubscriptionEvent.h"
#import "../EVESdkConfiguration.h"

@class EVEApiSubscription;
@class EVEApiResponse;
@class EVEReachability;


@interface EVEHttp : NSObject

- (EVEHttp *_Nonnull)initWithSdkConfiguration:(EVESdkConfiguration *_Nonnull)sdkConfiguration reachabilityBlock:(void(^)(EVEReachability *, SCNetworkConnectionFlags))innerReachabilityBlock;

- (NSMutableURLRequest *)createPostRequestForURL:(NSURL *)subUrl bodyData:(NSData *)bodyData;

- (NSURLSessionDataTask *)performApiRequest:(NSMutableURLRequest *)request completionHandler:(void (^)(EVEApiResponse *_Nullable, NSError *_Nullable))completionHandler;

- (NSURL *)urlForPath:(NSString *)path;
@end