#import <UIKit/UIKit.h>
#import "../Models/PMASubscriptionEvent.h"
#import "../PMASdkConfiguration.h"

@class PMAApiSubscription;
@class PMAApiResponse;


@interface PMAHttp : NSObject

- (PMAHttp *_Nonnull)initWithSdkConfiguration:(PMASdkConfiguration *_Nonnull)sdkConfiguration;


- (NSMutableURLRequest *)createPostRequestForURL:(NSURL *)subUrl bodyData:(NSData *)bodyData;

- (void)performApiRequest:(NSMutableURLRequest *)request completionHandler:(void (^)(PMAApiResponse *_Nullable, NSError *_Nullable))completionHandler;

- (NSURL *)urlForPath:(NSString *)path;
@end