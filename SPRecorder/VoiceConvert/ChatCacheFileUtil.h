//
//  ChatCacheFileUtil.h
//  ULNotes
//
//  Created by Roselifeye on 15/5/22.
//  Copyright (c) 2015年 uPP Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatCacheFileUtil : NSObject

+ (ChatCacheFileUtil*)sharedInstance;
- (NSString *)userDocPath;
- (BOOL)deleteWithContentPath:(NSString *)thePath;
- (NSString*)chatCachePathWithFriendId:(NSString*)theFriendId andType:(NSInteger)theType;
- (void)deleteFriendChatCacheWithFriendId:(NSString*)theFriendId;
- (void)deleteAllFriendChatDoc;

@end
