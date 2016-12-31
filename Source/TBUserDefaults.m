//
//  TBUserDefaults.m
//  TechBrowser
//
//  Created by Todd Ditchendorf on 3/29/12.
//  Copyright (c) 2012 Yahoo. All rights reserved.
//

#import "TBUserDefaults.h"

NSString *const kTBRootURLStringKey = @"TBRootURLString";
NSString *const kTBRootURLPatternStringsKey = @"TBRootURLPatternStrings";

@interface TBUserDefaults ()
+ (void)setUpUserDefaults;
@end

@implementation TBUserDefaults

+ (void)load {
    if ([TBUserDefaults class] == self) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [self setUpUserDefaults];
        
        [pool release];
    }
}


+ (void)setUpUserDefaults {
    NSString *path = [[NSBundle mainBundle] pathForResource:DEFAULT_VALUES_FILE_NAME ofType:@"plist"];
    NSAssert([path length], @"could not find DefaultValues.plist");
    
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSAssert([defaultValues count], @"could not load DefaultValues.plist");
    
    //[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}


+ (id)instance {
    static id instance = nil;
    @synchronized (self) {
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}


- (NSString *)rootURLString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kTBRootURLStringKey];
}
- (void)setRootURLString:(NSString *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kTBRootURLStringKey];
}


- (NSArray *)rootURLPatternStrings {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kTBRootURLPatternStringsKey];
}
- (void)setRootURLPatternStrings:(NSArray *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:kTBRootURLPatternStringsKey];
}

@end
