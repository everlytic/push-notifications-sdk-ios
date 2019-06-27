
#import <Foundation/Foundation.h>

@protocol EVEModel <NSObject>
- (nonnull NSDictionary *) serializeAsDictionary;
- (nonnull NSString *) serializeAsJson;
+ (id _Nonnull) deserializeFromJsonString:(NSString *_Nonnull)string;
@end