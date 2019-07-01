#import <Foundation/Foundation.h>
@class FMDatabase;


@interface EVEDatabase : FMDatabase

@property (strong, nonatomic) FMDatabase *database;

- (EVEDatabase *) init;

@end