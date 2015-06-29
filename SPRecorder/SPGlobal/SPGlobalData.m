//
//  SPGlobalData.m
//  iBusinessLocation
//
//  Created by Roselifeye on 14-5-8.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import "SPGlobalData.h"

@implementation SPGlobalData

+ (SPGlobalData *)shareInstance {
    static SPGlobalData *golobalData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        golobalData = [[SPGlobalData alloc] init];
    });
    return golobalData;
}

- (void)dealloc {
    [self setDbManager:nil];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    _dbManager = [[SPDBManager alloc] init];
    
    return self;
}

@end
