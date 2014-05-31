//
//  AchievementsViewController.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/30/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "AchievementsViewController.h"
#import <Parse/Parse.h>

@interface AchievementsViewController ()

@end


@implementation AchievementsViewController
@synthesize playerNameString;

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
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:playerNameString];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *players, NSError *error) {
        if(!error) {
            for (PFObject *player in players) {
                if ([player[@"negAchievement"] boolValue] == TRUE) {
                    NSLog(@"Players neg value is: %tu", [player[@"negAchievement"] boolValue]);
                    
                    negAchievementImage.hidden = false;
                    
                }
                
                if ([player[@"meaAchievement"] boolValue] == TRUE) {
                    NSLog(@"Players mea value is: %tu", [player[@"meaAchievement"] boolValue]);
                    
                    meaAchievementImage.hidden = false;
                    
                }
                
                if ([player[@"comAchievement"] boolValue] == TRUE) {
                    NSLog(@"Players com value is: %tu", [player[@"comAchievement"] boolValue]);
                    
                    comAchievementImage.hidden = false;
                    
                }
                
                incAchievementLabel.text = [[NSString alloc] initWithFormat:@"%d", [player[@"incAchievement"] intValue]];
                
                if ([player[@"incAchievement"] intValue] > 0) {
                    incAchievementImage.hidden = false;
                }
            }
        }
    
    }];
    
    
    NSLog(@"AchievementsViewController playerNameString is: %@", playerNameString);
    playerNameLabel.text = [NSString stringWithFormat:@"%@'s", playerNameString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(IBAction)onCancelButtonClicked:(id)sender
{
    
    // Dismiss the UIViewController in order to go back to the Leaderboard
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
@end
