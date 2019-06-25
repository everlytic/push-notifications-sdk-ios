#import <Foundation/Foundation.h>

@interface PMASdkConfiguration : NSObject

@property (strong, nonatomic) NSString *projectId;
@property (strong, nonatomic) NSURL *installUrl;
@property (strong, nonatomic) NSString *sdkVersion;

+ (PMASdkConfiguration *) initFromConfigString:(NSString *) configString;
@end