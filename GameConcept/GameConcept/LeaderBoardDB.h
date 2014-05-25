//
//  LeaderBoardDB.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/23/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LeaderBoardDB : NSObject
{
    sqlite3 *database;
    NSMutableArray *playerDataMutableArray;
}


- (NSString *) filePath;
- (void) insertNewScore;
- (NSArray *) getAllDBInfoByScore:(NSInteger)queryNumber;

+(void)CreateInstance;
+(LeaderBoardDB *)GetInstance;

@end
