//
//  TBUserDefaults.h
//  TechBrowser
//
//  Created by Todd Ditchendorf on 3/29/12.
//  Copyright (c) 2012 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTBRootURLStringKey;
extern NSString *const kTBRootURLPatternStringsKey;

@interface TBUserDefaults : NSObject

+ (TBUserDefaults *)instance;

@property (nonatomic, copy) NSString *rootURLString;
@property (nonatomic, copy) NSArray *rootURLPatternStrings;
@end
