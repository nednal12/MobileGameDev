//
//  LeaderBoardViewController.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/22/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *leaderboardTableView;
    NSArray *playerDataArray;
    IBOutlet UIButton *exitButton;
    IBOutlet UIButton *lastHourButton;
    IBOutlet UIButton *lastSixHoursButton;
    IBOutlet UIButton *lastTwelveHoursButton;
    IBOutlet UIButton *allTimeButton;
}

-(IBAction)onClick:(id)sender;



@end
