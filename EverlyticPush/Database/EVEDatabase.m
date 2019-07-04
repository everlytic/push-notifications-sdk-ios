#import <FMDB/FMDatabase.h>
#import "EVEDatabase.h"
#import "FMDatabaseAdditions.h"
#import "EVEDbContract.h"
#import "EVEDefaults.h"

NSString *const kDbName = @"__evpush.db";

@implementation EVEDatabase

static FMDatabase *database;

+ (FMDatabase *)database {

    if (database == nil) {

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kDbName];

        static dispatch_once_t onceToken;

        dispatch_once(&onceToken, ^{
            database = [FMDatabase databaseWithPath:writableDBPath];
        });
    }

    return database;
}

+ (BOOL)open {
    BOOL opened = [[self database] open];

    if (!opened) {
        database = nil;
    } else {
        if ([EVEDefaults dbVersion] < 1) {
            [EVEDbContract initializeDatabase:self.database];
        }

        [EVEDbContract updateDatabase:self.database];
    }

    return opened;
}

+ (BOOL)close {
    BOOL closed = [[self database] close];

    if (closed) {
        database = nil;
    }

    return closed;
}

@end
