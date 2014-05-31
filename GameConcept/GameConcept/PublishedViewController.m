//
//  PublishedViewController.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/24/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "PublishedViewController.h"
#import <Parse/Parse.h>
#import "IntroScene.h"
#import "AchievementsViewController.h"


@interface PublishedViewController ()

@end

@implementation PublishedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    playerDataMutableArray = [NSMutableArray array];
    PFQuery *query = [PFQuery queryWithClassName:@"LeaderBoardData"];
    [query whereKey:@"playerName" notEqualTo:@""];
    [query addDescendingOrder:@"score"];
    [query addAscendingOrder:@"userName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSLog(@"%@", object);
                NSString *userName = object[@"userName"];
                int score = [[object objectForKey:@"score"] intValue];
                NSDate *gameDate = object[@"gameDate"];
                NSDictionary *playerData = [[NSDictionary alloc] initWithObjectsAndKeys:userName, @"userName", [NSNumber numberWithInt:score], @"score", gameDate, @"gameDate", nil];
                
                NSLog(@"playerData: %@", playerData);
                [playerDataMutableArray addObject:playerData];
                
                NSLog(@"playerDataMutableArray contains %lu", (unsigned long)playerDataMutableArray.count);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        playerDataArray = [[NSArray alloc] initWithArray:playerDataMutableArray];
        [leaderboardTableView reloadData];
    }];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [leaderboardTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// -----------------------------------------------------------------------
#pragma mark - TableView Methods
// -----------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection is: %lu", (unsigned long)playerDataArray.count);
    return playerDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //    cell.textLabel.text = @"Hello";
    //    cell.detailTextLabel.text = @"Hello Again";
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [playerDataArray objectAtIndex:row];
    
    NSLog(@"%@", rowData);
    cell.textLabel.text = [rowData objectForKey:@"userName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [rowData objectForKey:@"score"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementsViewController *achievementsViewController = [[AchievementsViewController alloc] initWithNibName:@"AchievementsViewController" bundle:nil];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    achievementsViewController.playerNameString = [[NSString alloc] initWithString: [selectedCell textLabel].text];
    
    if (achievementsViewController != nil)
    {
        
        [self presentViewController:achievementsViewController animated:TRUE completion:nil];
    }
    
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(IBAction)onClick:(id)sender
{
    
    // Dismiss the UIViewController in order to go back to the Intro Scene
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    
}

@end
