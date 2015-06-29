//
//  VoiceConverter.h
//  ULNotes
//
//  Created by Roselifeye on 15/5/22.
//  Copyright (c) 2015年 uPP Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceConverter : NSObject

+ (NSString *)amrToWav:(NSString*)filePath;
+ (NSString *)wavToAmr:(NSString*)filePath;

@end
