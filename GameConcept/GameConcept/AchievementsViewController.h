//
//  AchievementsViewController.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/30/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementsViewController : UIViewController
{
    IBOutlet UILabel *playerNameLabel;
    IBOutlet UIImageView *incAchievementImage;
    IBOutlet UIImageView *meaAchievementImage;
    IBOutlet UIImageView *comAchievementImage;
    IBOutlet UIImageView *negAchievementImage;
    IBOutlet UIButton *cancelButton;
    IBOutlet UILabel *incAchievementLabel;
    
    NSString *playerNameString;
}

@property(nonatomic) NSString *playerNameString;

- (IBAction)onCancelButtonClicked:(id)sender;

@end
