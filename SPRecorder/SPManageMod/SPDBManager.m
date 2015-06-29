//
//  SPDBManager.m
//  SPRecorder
//
//  Created by Roselifeye on 2015-06-28.
//  Copyright © 2015 roselife. All rights reserved.
//

#import "SPDBManager.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>

@interface SPDBManager ()

@property (nonatomic, copy) NSString *recordDBPath;
@property (nonatomic, strong) FMDatabase *recordInfoDB;
@property (nonatomic, strong) FMDatabaseQueue *recordDBQueue;

@end

@implementation SPDBManager

- (id)init {
    if ((self = [super init])) {
        
        self.recordDBPath = [[NSString getDocumentDirectory] stringByAppendingPathComponent:DB_FILEPATH];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:_recordDBPath]) {
            self.recordInfoDB = [FMDatabase databaseWithPath:_recordDBPath];
            if ([_recordInfoDB open]) {
                [_recordInfoDB setShouldCacheStatements:YES];
            } else {
                NSLog(@"Fail to open DB customerInfo.db!!");
            }
        } else {
            if (![fileManager fileExistsAtPath:[[NSString getDocumentDirectory] stringByAppendingPathComponent:DB_FOLDER]]) {
                [fileManager createDirectoryAtPath:[[NSString getDocumentDirectory] stringByAppendingPathComponent:DB_FOLDER]
                       withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [self createRecordInfoDB];
        }
        self.recordDBQueue = [FMDatabaseQueue databaseQueueWithPath:_recordDBPath];
    }
    
    return self;
}

- (BOOL)deleteTable:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![self.recordInfoDB executeUpdate:sqlstr]) {
        NSLog(@"Delete table error!");
        return NO;
    }
    return YES;
}

- (void)createRecordInfoDB {
    self.recordInfoDB = [FMDatabase databaseWithPath:_recordDBPath];
    NSString *sql = @"CREATE TABLE IF NOT EXISTS RecordInfoList (recordDate date, recordAuthor text, recordAddr text, recordLenth text)";

    if (![_recordInfoDB open]) {
        return;
    }
    [_recordInfoDB setShouldCacheStatements:YES];
    if (![_recordInfoDB executeUpdate:sql]) {
    }else {
    }
}

#pragma -
#pragma Database Manipulation
- (BOOL)insertRecordInfo:(SPRecordDataModel *)info {
    __block BOOL result = NO;
    
    [self.recordDBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //[db open];
        NSString *sql = @"INSERT INTO RecordInfoList (recordDate, recordAuthor, recordAddr, recordLenth) values(?, ?, ?, ?)";
        [db executeUpdate:sql, info.recordDate, info.recordAuthor, info.recordAddr, info.recordLenth];
        
        if ([db hadError]) {
            NSLog(@"Fail to insert RecordInfoList to recordInfo.sqlite, %d, %@", [db lastErrorCode], [db lastErrorMessage]);
            *rollback = YES;
            result = NO;
        }
        result = YES;
        //[db close];
    }];

    return result;
}

- (NSMutableArray *)queryAllRecordInfos {
    __block NSMutableArray *newsInfoArray = [[NSMutableArray alloc] init];
    [self.recordDBQueue inDatabase:^(FMDatabase *db) {
        //[db open];
        NSString *sql = @"SELECT * FROM RecordInfoList order by recordDate desc";
        FMResultSet *resultSet = [db executeQuery:sql];
        while([resultSet next]) {
            SPRecordDataModel *info = [[SPRecordDataModel alloc] init];
            info.recordDate = [resultSet stringForColumn:@"recordDate"];
            info.recordAuthor = [resultSet stringForColumn:@"recordAuthor"];
            info.recordAddr = [resultSet stringForColumn:@"recordAddr"];
            info.recordLenth = [resultSet stringForColumn:@"recordLenth"];
            
            [newsInfoArray addObject:info];
        }
        [resultSet close];
        
        if (0 == [newsInfoArray count]) {
            newsInfoArray = nil;
        }
        //[db close];
    }];
    return newsInfoArray;
}

- (BOOL)deleteRecordInfoWithAddr:(NSString *)recordAddr {
    __block BOOL result = NO;
    [self.recordDBQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //[db open];
        NSString *sql = @"DELETE FROM RecordInfoList WHERE recordAddr = ?";
        [db executeUpdate:sql, recordAddr];
        if ([db hadError]) {
            NSLog(@"Fail to insert RecordInfoList to recordInfo.sqlite, %d, %@", [db lastErrorCode], [_recordInfoDB lastErrorMessage]);
            *rollback = YES;
            result = NO;
        }
        result = YES;
        //[db close];

    }];
    
    return result;
}

@end
