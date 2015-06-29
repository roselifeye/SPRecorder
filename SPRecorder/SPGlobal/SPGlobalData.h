//
//  SPGlobalData.h
//  iBusinessLocation
//
//  Created by Roselifeye on 14-5-8.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPDBManager.h"


@interface SPGlobalData : NSObject

@property (nonatomic, strong) SPDBManager *dbManager;

+ (SPGlobalData *)shareInstance;

@end
