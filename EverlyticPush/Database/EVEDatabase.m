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
    NSString *storagePath = [[[NSFileManager defaultManager]
            containerURLForSecurityApplicationGroupIdentifier:EVEHelpers.appGroupName] path];

    if (storagePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        storagePath = paths[0];
    }

    NSString *storeURL = [storagePath stringByAppendingPathComponent:kDbName];

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

+ (void)inDatabase:(void (^)(FMDatabase *))block {
    [[self queue] inDatabase:^(FMDatabase *db) {
        [self upgradeDatabase:db];
        block(db);
        [db closeOpenResultSets];
        [db close];
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
    id dbVersion = [EVEDefaults dbVersion];
    NSLog(@"DB Version=%@ compared=%d", dbVersion, [dbVersion compare:@1]);
    if ([@1 compare:dbVersion] == NSOrderedDescending) {
        NSLog(@"Initializing database");
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
