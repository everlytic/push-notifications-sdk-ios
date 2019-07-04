#import <Foundation/Foundation.h>
@class FMDatabase;

@interface EVEDatabase : NSObject
+ (FMDatabase *) database;

+ (BOOL)open;

+ (BOOL)close;
@end
