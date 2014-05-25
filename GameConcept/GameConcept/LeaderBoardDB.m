//
//  LeaderBoardDB.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/23/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "LeaderBoardDB.h"
#import "PlayerSingleton.h"

#define sqlFileName @"leaderBoard.sqlDB"

@implementation LeaderBoardDB

// Create a pointer to itself
static LeaderBoardDB *_leaderBoardInstance = nil;

+(void)CreateInstance
{
    if (_leaderBoardInstance == nil)
    {
        NSLog(@"LeaderBoardDB CreateInstance");
        (void)[[self alloc] init];
        
    }
    
}

+(LeaderBoardDB *)GetInstance
{
    return _leaderBoardInstance;
}

+(id)alloc
{
    _leaderBoardInstance = [super alloc];
    
    return _leaderBoardInstance;
}

-(id)init
{
    if (self != [super init])
    {
        return nil;
    }
    
    // Allocate a new SQLite database
//    sqlite3 *db;
    
    // Attempt to open the database. If unsuccessful, close it and perform the assert.
    if (sqlite3_open([[self filePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open DB");
        
    }
    
    NSString *createLeaderBoardTable = @"CREATE TABLE IF NOT EXISTS LEADERBOARD (ROW INTEGER PRIMARY KEY AUTOINCREMENT, USER_NAME TEXT, SCORE INTEGER, GAME_DATE DOUBLE);";
    
    // Allocate errorMessage to hold any errors related to creating the SQL table. Hopefully it will never be initialized within the sqlite3_exec statement.
    char *errorMessage;
    
    // Attempt to create the table. If unsuccessful, close it and perform the assert.
    if (sqlite3_exec(database, [createLeaderBoardTable UTF8String], NULL, NULL, &errorMessage) != SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"LeaderBoard init: %s", errorMessage);
    }
    else
    {
        NSLog(@"LeaderBoard created successfully");
    }
    
    return self;
}


// ------------------------------------------------------------------------------
#pragma mark - SQLite Methods
// ------------------------------------------------------------------------------

- (NSString *) filePath {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *directory = [filePaths objectAtIndex:0];
    
    return [directory stringByAppendingPathComponent:sqlFileName];
    
}

- (void) insertNewScore
{
    NSLog(@"insertNewScore");
    
    PlayerSingleton *playerSingleton = [PlayerSingleton GetInstance];
//    sqlite3 *database;
    if (sqlite3_open([[self filePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"insertNewScore failed to open DB");
    }
    
//    char *insert = "INSERT OR REPLACE INTO LEADERBOARD (ROW, USER_NAME, SCORE, GAME_DATE) VALUES (?, ?, ?, ?);";
    char *insert = "INSERT OR REPLACE INTO LEADERBOARD (USER_NAME, SCORE, GAME_DATE) VALUES (?, ?, ?);";
    
    char *errorMsg;
    
    sqlite3_stmt *insertStatement;
    
    if (sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK)
    {
//        sqlite3_bind_int(insertStatement, 1, NULL);
        sqlite3_bind_text(insertStatement, 1, [playerSingleton.playerName UTF8String], -1, NULL);
        sqlite3_bind_int(insertStatement, 2, playerSingleton.playerScore);
        sqlite3_bind_double(insertStatement, 3, playerSingleton.playerDate);
    }
    
    if (sqlite3_step(insertStatement) != SQLITE_DONE)
    {
        NSAssert(0,@"insertNewScore failed to insert record: %s", errorMsg);
        
    }
    else
    {
        NSLog(@"insertNewScore successfully inserted record");
    }
    
    sqlite3_finalize(insertStatement);
    sqlite3_close(database);
}




- (NSArray *) getAllDBInfoByScore:(NSInteger)queryNumber
{
//    sqlite3 *database;
    if (sqlite3_open([[self filePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"insertNewScore failed to open DB");
    }
    
    playerDataMutableArray = [NSMutableArray array];
    
    
    // secondsFromGMT actually returns an NSInteger but iOS does mind it too much if the value is placed in a double
    // The reason for doing that is so the offset can be used as the input to the NSDate method dateByAddingTimeInterval
    // Doing this actually returns the correct time for the user specific locale
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    double offset = timeZone.secondsFromGMT;
    NSDate *now = [[NSDate date] dateByAddingTimeInterval: offset];
    double tempDouble = [now timeIntervalSinceReferenceDate];
    NSLog(@"tempDouble equals: %f", tempDouble);
    
    
    NSString *queryLeaderBoard;
    
    switch (queryNumber) {
        case 0:
            NSLog(@"Case 0 was called");
            queryLeaderBoard = [NSString stringWithFormat:@"SELECT ROW, USER_NAME, SCORE, GAME_DATE FROM LEADERBOARD WHERE GAME_DATE > %f ORDER BY SCORE DESC, USER_NAME", tempDouble - 3600.0];
            break;
            
        case 1:
            queryLeaderBoard = [NSString stringWithFormat:@"SELECT ROW, USER_NAME, SCORE, GAME_DATE FROM LEADERBOARD WHERE GAME_DATE > %f ORDER BY SCORE DESC, USER_NAME", tempDouble - 21600.0];
            break;
            
        case 2:
            queryLeaderBoard = [NSString stringWithFormat:@"SELECT ROW, USER_NAME, SCORE, GAME_DATE FROM LEADERBOARD WHERE GAME_DATE > %f ORDER BY SCORE DESC, USER_NAME", tempDouble - 43200.0];
            break;
            
        default:
            queryLeaderBoard = @"SELECT ROW, USER_NAME, SCORE, GAME_DATE FROM LEADERBOARD ORDER BY SCORE DESC, USER_NAME";
            break;
    }
//    NSString *queryLeaderBoard = @"SELECT ROW, USER_NAME, SCORE, GAME_DATE FROM LEADERBOARD ORDER BY SCORE DESC, USER_NAME";

    
    sqlite3_stmt *queryResults;
    
    if (sqlite3_prepare_v2(database, [queryLeaderBoard UTF8String], -1, &queryResults, nil) == SQLITE_OK) {
        while (sqlite3_step(queryResults) == SQLITE_ROW) {
            
            char *userName = (char *)sqlite3_column_text(queryResults, 1);
            
            int score = sqlite3_column_int(queryResults, 2);
            
            double gameDateSeconds = sqlite3_column_double(queryResults, 3);

            NSDate *gameDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gameDateSeconds];

            NSDictionary *playerData = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithUTF8String:userName], @"userName", [NSNumber numberWithInt:score], @"score", gameDate, @"gameDate", nil];
            
            [playerDataMutableArray addObject:playerData];
            
        }
        
        sqlite3_finalize(queryResults);
    }
    
    sqlite3_close(database);
    
    NSArray *playerDataArray = [[NSArray alloc] initWithArray:playerDataMutableArray];
    
    return playerDataArray;
}

@end
