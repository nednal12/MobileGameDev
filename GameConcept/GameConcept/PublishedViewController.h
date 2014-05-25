//
//  PublishedViewController.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/24/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *playerDataMutableArray;
    IBOutlet UITableView *leaderboardTableView;
    NSArray *playerDataArray;
    IBOutlet UIButton *exitButton;
    
}

-(IBAction)onClick:(id)sender;


@end
