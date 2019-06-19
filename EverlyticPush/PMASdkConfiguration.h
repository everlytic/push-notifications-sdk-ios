#import <Foundation/Foundation.h>

@interface PMASdkConfiguration : NSObject

@property (strong, nonatomic) NSString *projectId;
@property (strong, nonatomic) NSURL *installUrl;

+ (PMASdkConfiguration *) initFromConfigString:(NSString *) configString;
@end