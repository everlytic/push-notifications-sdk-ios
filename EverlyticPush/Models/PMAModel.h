
#import <Foundation/Foundation.h>

@protocol PMAModel <NSObject>
- (nonnull NSDictionary *) serializeAsDictionary;
- (nonnull NSString *) serializeAsJson;
+ (id) deserializeFromJsonString:(NSString *_Nonnull)string;
@end