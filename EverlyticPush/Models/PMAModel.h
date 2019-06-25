
#import <Foundation/Foundation.h>

@protocol PMAModel <NSObject>
- (nonnull NSDictionary *) serializeAsDictionary;
- (nonnull NSString *) serializeAsJson;
+ (id _Nonnull) deserializeFromJsonString:(NSString *_Nonnull)string;
@end