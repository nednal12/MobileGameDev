//
//  LeaderBoardViewController.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/22/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "IntroScene.h"
#import "LeaderBoardDB.h"


@interface LeaderBoardViewController ()

@end

@implementation LeaderBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    playerDataArray = [[NSArray alloc] initWithArray:[[LeaderBoardDB GetInstance] getAllDBInfoByScore:4]];
    
    
//    [[LeaderBoardDB GetInstance] getAllDBInfoByScore];
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


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(IBAction)onClick:(id)sender
{
    
    switch ([sender tag]) {
        case 0:
            playerDataArray = [[NSArray alloc] initWithArray:[[LeaderBoardDB GetInstance] getAllDBInfoByScore:0]];
            [leaderboardTableView reloadData];
            break;
        
        case 1:
            playerDataArray = [[NSArray alloc] initWithArray:[[LeaderBoardDB GetInstance] getAllDBInfoByScore:1]];
            [leaderboardTableView reloadData];
            break;
            
        case 2:
            playerDataArray = [[NSArray alloc] initWithArray:[[LeaderBoardDB GetInstance] getAllDBInfoByScore:2]];
            [leaderboardTableView reloadData];
            break;
            
        case 3:
            playerDataArray = [[NSArray alloc] initWithArray:[[LeaderBoardDB GetInstance] getAllDBInfoByScore:3]];
            [leaderboardTableView reloadData];
            break;
            
        default:
            // Dismiss the UIViewController in order to go back to the Intro Scene
            [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
            break;
    }
    
}

@end
