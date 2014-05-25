//
//  InternalLeaderboard.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/17/14.
//  Copyright 2014 Brent Marohnic. All rights reserved.
//

#import "InternalLeaderboard.h"
#import "IntroScene.h"


@implementation InternalLeaderboard
{
    CCSprite *bubbleBackgroundImage;

}

+ (InternalLeaderboard *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommends assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Set the fontMultiplier so that fonts are sized appropriately regardless of whether they are displayed on a Retina iPhone or iPad
    CGSize whichSize = [CCDirector sharedDirector].viewSize;
    NSLog(@"%f", whichSize.width);
    float fontMultiplier;
    if (whichSize.width == 1024) {
        fontMultiplier = 2.0f;
    } else {
        fontMultiplier = 1.0f;
    }
    
    bubbleBackgroundImage = [CCSprite spriteWithImageNamed:@"background.png"];
    bubbleBackgroundImage.anchorPoint = CGPointMake(0, 0);
    [self addChild:bubbleBackgroundImage];
    
    leaderBoardTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 70, 300, 200)];
    [leaderBoardTableView setDelegate:self];
    [leaderBoardTableView setDataSource:self];
    leaderBoardTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [[[CCDirector sharedDirector] view] addSubview:leaderBoardTableView];
    
    
    // Helloworld scene button
    CCButton *introSceneButton = [CCButton buttonWithTitle:@"[ Main Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    introSceneButton.positionType = CCPositionTypeNormalized;
    introSceneButton.position = ccp(0.5f, 0.15f);
    [introSceneButton setTarget:self selector:@selector(onMainMenuClicked:)];
    [self addChild:introSceneButton];
    return self;
}


// -----------------------------------------------------------------------
#pragma mark - Dealloc
// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    
    leaderBoardTableView = nil;
    
}

// -----------------------------------------------------------------------
#pragma mark - TableView Methods
// -----------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Hello";
    cell.detailTextLabel.text = @"Hello Again";
    
    return cell;
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onMainMenuClicked:(id)sender
{
    leaderBoardTableView.hidden = YES;
    // start Intro Scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    
}

@end
