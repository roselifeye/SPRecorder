//
//  SPDBManager.h
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRecordDataModel.h"

#define DB_FOLDER       (@"DB")
#define DB_FILEPATH     (@"DB/recordInfo.sqlite")

@interface SPDBManager : NSObject

- (BOOL)insertRecordInfo:(SPRecordDataModel *)info;

- (NSMutableArray *)queryAllRecordInfos;

- (BOOL)deleteRecordInfoWithAddr:(NSString *)recordAddr;

@end
