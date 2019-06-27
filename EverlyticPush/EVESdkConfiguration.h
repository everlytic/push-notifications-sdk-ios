#import <Foundation/Foundation.h>

@interface EVESdkConfiguration : NSObject

@property (strong, nonatomic) NSString *projectId;
@property (strong, nonatomic) NSURL *installUrl;
@property (strong, nonatomic) NSString *sdkVersion;

+ (EVESdkConfiguration *) initFromConfigString:(NSString *) configString;
@end