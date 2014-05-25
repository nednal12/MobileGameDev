//
//  PlayerSingleton.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/23/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerSingleton : NSObject
{
    @private
    NSString *playerName;
    int playerScore;
    double playerDate;
}

@property (strong) NSString *playerName;
@property (readwrite) int playerScore;
@property (readwrite) double playerDate;

+(void)CreateInstance;
+(PlayerSingleton *)GetInstance;

@end
