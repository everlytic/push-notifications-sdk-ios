#import <Foundation/Foundation.h>
@class FMDatabase;
@class FMDatabaseQueue;

@interface EVEDatabase : NSObject
+ (FMDatabase *) database;

+ (FMDatabaseQueue *)queue;

+ (void)inDatabase:(void (^)(FMDatabase *))block;

+ (BOOL)open;

+ (BOOL)close;
@end
