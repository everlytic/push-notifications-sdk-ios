#import "EverlyticNotification.h"


@implementation EverlyticNotification

- (instancetype)initWithMessageId:(NSNumber *_Nonnull)messageId title:(NSString *_Nullable)title body:(NSString *_Nonnull)body receivedAt:(NSDate *_Nonnull)receivedAt readAt:(NSDate *_Nullable)readAt dismissedAt:(NSDate *_Nullable)dismissedAt customAttributes:(NSDictionary<NSString *, NSString *> *_Nonnull)customAttributes {
    self.messageId = messageId;
    self.title = title;
    self.body = body;
    self.receivedAt = receivedAt;
    self.readAt = readAt;
    self.dismissedAt = dismissedAt;
    self.customAttributes = customAttributes;
    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString
            stringWithFormat:@"<%@: messageId=%@ title=%@ body=%@ receivedAt=%@ readAt=%@ dismissedAt=%@ customAttributes=%@",
                             NSStringFromClass([self class]),
                             self.messageId,
                             self.title,
                             self.body,
                             self.receivedAt,
                             self.readAt,
                             self.dismissedAt,
                             self.customAttributes
    ];

    [description appendString:@">"];
    return description;
}

@end