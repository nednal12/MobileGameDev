//
//  PlayerSingleton.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/23/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "PlayerSingleton.h"

@implementation PlayerSingleton

@synthesize playerName, playerScore, playerDate;

// Create a pointer to itself
static PlayerSingleton *_playerInstance = nil;

+(void)CreateInstance
{
    if (_playerInstance == nil)
    {
        (void)[[self alloc] init];
        
    }

}

+(PlayerSingleton *)GetInstance
{
    return _playerInstance;
}

+(id)alloc
{
    _playerInstance = [super alloc];
    
    return _playerInstance;
}

-(id)init
{
    if (self = [super init])
    {
        return self;
    }
    
    return nil;
}

@end
