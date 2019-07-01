#import <Foundation/Foundation.h>

@class FMDatabase;

@interface EVEDbRepository : NSObject

- (instancetype)initWithDatabase:(FMDatabase *)database;

+ (NSString *)createTableStatement;

+ (NSDictionary<NSNumber *, NSArray<NSString *> *> *)migrations;

@end
