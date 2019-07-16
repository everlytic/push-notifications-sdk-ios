#import <FMDB/FMDatabase.h>
#import "EVEDatabase.h"
#import "EVEDbContract.h"
#import "EVEDefaults.h"
#import "FMDatabaseQueue.h"
#import "EVEHelpers.h"

NSString *const kDbName = @"__evpush.db";

@implementation EVEDatabase

static FMDatabase *database;
static FMDatabaseQueue *queue;
static unsigned int openCount = 0;

+ (FMDatabase *)database {

    if (database == nil) {
        openCount = 0;
        NSString *writableDBPath = [self getDatabasePath];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            database = [FMDatabase databaseWithPath:writableDBPath];
        });
    }

    return database;
}

+ (NSString *)getDatabasePath {
    NSURL *containerURL = [[NSFileManager defaultManager]
            containerURLForSecurityApplicationGroupIdentifier:EVEHelpers.appGroupName];

    NSString *storeURL = [[containerURL path] stringByAppendingPathComponent:kDbName];

    return storeURL;
}

+ (FMDatabaseQueue *)queue {

    if (queue == nil) {
        openCount = 0;
        NSString *writableDBPath = [self getDatabasePath];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            queue = [FMDatabaseQueue databaseQueueWithPath:writableDBPath];
        });
    }

    return queue;
}

+ (void) inDatabase:(void(^)(FMDatabase *))block {
    [[self queue] inDatabase:^(FMDatabase *db) {
        [self upgradeDatabase:db];
        block(db);
    }];
}

+ (BOOL)open {
    BOOL opened = [[self database] open];
    openCount++;

    if (!opened) {
        database = nil;
        openCount = 0;
    } else {
        [self upgradeDatabase:self.database];
    }

    return opened;
}

+ (void)upgradeDatabase:(FMDatabase *)db {
    if ([EVEDefaults dbVersion] < 1) {
        [EVEDbContract initializeDatabase:db];
    }

    [EVEDbContract updateDatabase:db];
}

+ (BOOL)close {

    openCount--;

    if (openCount < 1) {
        BOOL closed = [[self database] close];

        if (closed) {
            database = nil;
        }

        return closed;
    }

    NSLog(@"Database open count still above 1, not closing yet");
    return NO;
}

@end
