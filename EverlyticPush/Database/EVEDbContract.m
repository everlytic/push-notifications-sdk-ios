#import "EVEDbContract.h"
#import "EVENotificationLog.h"
#import "EVENotificationEventsLog.h"
#import "FMDatabase.h"
#import "EVEDefaults.h"

@implementation EVEDbContract

static unsigned short version = 1;

+ (void)initializeDatabase:(FMDatabase *)database {

    for (NSString *statement in [self tableCreateStatements]) {
        [database executeUpdate:statement];
    }
}

+ (void)updateDatabase:(FMDatabase *)database {

    id migrationSets = [self migrations];

    id migrationSqlStatements = [self createMigrationStatementsFromSets:migrationSets];

    NSNumber *oldVersion = [EVEDefaults dbVersion];

    for (int i = [oldVersion intValue]; i < version; ++i) {
        for (NSString *statement in migrationSqlStatements[@(i)]) {
            [database executeUpdate:statement];
        }
        [EVEDefaults setDbVersion:@(i + 1)];
    }

    [EVEDefaults setDbVersion:@(version)];
}

+ (NSMutableDictionary<NSNumber *, NSArray *> *)createMigrationStatementsFromSets:(id)migrationSets {
    NSMutableDictionary<NSNumber *, NSArray *> *mergedMigrations = [[NSMutableDictionary alloc] init];

    for (int v = 0; v < version; v++) {
        mergedMigrations[@(v)] = @[];
    }

    for (id migrationSet in migrationSets) {
        for (NSNumber *key in migrationSet) {
            id mCopy = [mergedMigrations[key] mutableCopy];
            [mCopy addObjectsFromArray:EVENotificationLog.migrations[key]];
            mergedMigrations[key] = mCopy;
        }
    }

    return mergedMigrations;
}

+ (NSArray<NSString *> *)tableCreateStatements {

    return @[
            [EVENotificationLog createTableStatement],
            [EVENotificationEventsLog createTableStatement]
    ];
}

+ (NSArray<NSDictionary<NSNumber *, NSArray<NSString *> *> *> *)migrations {
    return @[
            EVENotificationLog.migrations,
            EVENotificationEventsLog.migrations
    ];
}


@end