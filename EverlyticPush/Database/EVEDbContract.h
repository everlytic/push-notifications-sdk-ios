#import <Foundation/Foundation.h>

@class FMDatabase;

@interface EVEDbContract : NSObject

+ (void) initializeDatabase:(FMDatabase *)database;

+ (void)updateDatabase: (FMDatabase *)database;

@end
