#import "EVEDbRepository.h"

@interface EVEDbRepository ()
@property(strong, nonatomic) FMDatabase *database;
@end

@implementation EVEDbRepository

- (instancetype)initWithDatabase:(FMDatabase *)database {
    self.database = database;
    return self;
}

@end