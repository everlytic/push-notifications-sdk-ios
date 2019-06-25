#import <Foundation/Foundation.h>
#import "PMAModel.h"

@interface PMAApiResponse : NSObject<PMAModel>

@property (strong, nonatomic) NSString *status;
@property (nonatomic) BOOL *isSuccessful;
@property (strong, nonatomic) NSDictionary<NSString *, id> *data;

- (NSString *)dataAsJsonString;

@end