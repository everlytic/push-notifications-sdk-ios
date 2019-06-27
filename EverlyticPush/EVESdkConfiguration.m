#import "EVESdkConfiguration.h"

@implementation EVESdkConfiguration
NSString *KEY_PROJECT = @"p";
NSString *KEY_INSTALL = @"i";

- (EVESdkConfiguration *)initWithProjectId:(NSString *)projectId installUrl:(NSURL *)url {
    self.sdkVersion =
    self.projectId = projectId;
    self.installUrl = url;
    return self;
}

+ (EVESdkConfiguration *)initFromConfigString:(NSString *)configString {

    NSString *decoded = [self decodeBase64String:configString];

    NSDictionary<NSString *, NSString *> *properties = [self getConfigurationDictionaryFromString:decoded];

    NSURL *url = [self createUrlFromString:[properties valueForKey:KEY_INSTALL]];

    if (url == nil)
        return nil;

    return [[EVESdkConfiguration alloc]
            initWithProjectId:[properties valueForKey:KEY_PROJECT]
                   installUrl:url
    ];
}

+ (NSDictionary<NSString *, NSString *> *)getConfigurationDictionaryFromString:(NSString *)decoded {
    NSArray<NSString *> *strArr = [decoded componentsSeparatedByString:@";"];

    NSMutableDictionary<NSString *, NSString *> *properties = [[NSMutableDictionary alloc] init];

    for (NSUInteger i = 0; i < [strArr count]; ++i) {
        NSString *key = [strArr[i] substringToIndex:1];
#if DEBUG
        NSLog(@"key=%@, value=%@", key, [strArr[i] substringFromIndex:2]);
#endif
        properties[key] = [strArr[i] substringFromIndex:2];
    }
    
    return properties;
}

+ (NSString *)decodeBase64String:(NSString *)configString {
    NSData *configData = [[NSData alloc] initWithBase64EncodedString:configString options:0];
    NSString *decoded = [[NSString alloc] initWithData:configData encoding:NSUTF8StringEncoding];
    return decoded;
}

+ (NSURL *)createUrlFromString:(NSString *)string {
    return [[NSURL alloc] initWithString:string];
}

@end
