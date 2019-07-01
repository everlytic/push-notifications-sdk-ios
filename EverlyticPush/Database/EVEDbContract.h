#import <Foundation/Foundation.h>

@interface EVEDbContract : NSObject

- (NSArray<NSString *> *) tableCreateStatements;

- (NSArray<NSArray *> *) migrations;

@end