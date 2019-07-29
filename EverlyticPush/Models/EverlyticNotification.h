#import <Foundation/Foundation.h>

@interface EverlyticNotification : NSObject

@property(strong, nonatomic) NSNumber *const _Nonnull messageId;
@property(strong, nonatomic) NSString *const _Nullable title;
@property(strong, nonatomic) NSString *const _Nonnull body;
@property(strong, nonatomic) NSDate *const _Nonnull receivedAt;
@property(strong, nonatomic) NSDate *const _Nullable readAt;
@property(strong, nonatomic) NSDate *const _Nullable dismissedAt;
@property(strong, nonatomic) NSDictionary<NSString *, NSString *> *const _Nonnull customAttributes;

- (instancetype _Nonnull)initWithMessageId:(NSNumber *_Nonnull)messageId
                                     title:(NSString *_Nullable)title
                                      body:(NSString *_Nonnull)body
                                receivedAt:(NSDate *_Nonnull)receivedAt
                                    readAt:(NSDate *_Nullable)readAt
                               dismissedAt:(NSDate *_Nullable)dismissedAt
                          customAttributes:(NSDictionary<NSString *, NSString *> *_Nonnull)customAttributes;

@end