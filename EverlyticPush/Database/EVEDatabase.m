#import <FMDB/FMDatabase.h>
#import "EVEDatabase.h"
#import "EVEDbContract.h"

NSString *const DB_NAME = @"__evpush.db";

@implementation EVEDatabase

- (EVEDatabase *) init {
    self = [super init];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:DB_NAME];
    self.database = [FMDatabase databaseWithPath:path];
    return self;
}

@end
