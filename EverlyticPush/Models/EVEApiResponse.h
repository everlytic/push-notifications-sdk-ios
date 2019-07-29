#import <Foundation/Foundation.h>
#import "EVEModel.h"

@interface EVEApiResponse : NSObject<EVEModel>

@property (strong, nonatomic) NSString *status;
@property (nonatomic) BOOL isSuccessful;
@property (strong, nonatomic) NSDictionary<NSString *, id> *data;

- (NSString *)dataAsJsonString;

@end