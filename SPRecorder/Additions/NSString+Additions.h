//
//  NSString+Additions.h
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (NSString *)getDocumentDirectory;

+ (NSString *)getAppVersion;

+ (NSString *)getBuildVersion;

- (BOOL)isEmail;

- (BOOL)isPhoneNumber;


@end
