//
//  VoiceConverter.m
//  ULNotes
//
//  Created by Roselifeye on 15/5/22.
//  Copyright (c) 2015年 uPP Labs Inc. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation VoiceConverter

+ (NSString *)amrToWav:(NSString*)filePath {
    
    NSString *savePath = [filePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
    
    if (! DecodeAMRFileToWAVEFile([filePath cStringUsingEncoding:NSASCIIStringEncoding], [savePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return nil;
    
    return savePath;
}

+ (NSString *)wavToAmr:(NSString *)filePath {
    NSString *savePath = [filePath stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
    NSLog(@"预期存储路径:%@",savePath);
    if (EncodeWAVEFileToAMRFile([filePath cStringUsingEncoding:NSASCIIStringEncoding], [savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return savePath;
    return nil;
}


@end
