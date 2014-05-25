//
//  InternalLeaderboard.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/17/14.
//  Copyright 2014 Brent Marohnic. All rights reserved.
//


#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface InternalLeaderboard : CCScene <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *leaderBoardTableView;
}

// -----------------------------------------------------------------------

+ (InternalLeaderboard *)scene;
- (id)init;

// -----------------------------------------------------------------------

@end
