//
//  IntroScene.m
//  GameConcept
//
//  Created by Brent Marohnic on 4/2/14.
//  Copyright Brent Marohnic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "ImmersiveScene.h"
#import "HelloWorldScene.h"
#import "CreditsScene.h"
#import "InstructionsScene.h"
#import "InternalLeaderboard.h"
#import "LeaderBoardViewController.h"
#import "PlayerSingleton.h"
#import "LeaderBoardDB.h"
#import "PublishedViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
{
    CCSprite *bubbleBackgroundImage;
    ALBuffer *bubblePopSound;
//    CCSprite *userNameTextField;
//    CCTextField *userNameTextField1;
//    CCSpriteFrame *userNameSpriteFrame;
}
// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    PFUser *currentUser = [PFUser currentUser];
    
    [PlayerSingleton CreateInstance];
    
    [LeaderBoardDB CreateInstance];
    
    
    // This is the initial code copied from Parse in order to test the connection.
    // Keeping it here just in case it is needed again.
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    
    // Set the fontMultiplier so that fonts are sized appropriately regardless of whether they are displayed on a Retina iPhone or iPad
    CGSize whichSize = [CCDirector sharedDirector].viewSize;
    NSLog(@"%f", whichSize.width);
    float fontMultiplier;
    if (whichSize.width == 1024) {
        fontMultiplier = 2.0f;
    } else {
        fontMultiplier = 1.0f;
    }
    
    // Preload sounds
    bubblePopSound = [[OALSimpleAudio sharedInstance] preloadEffect:@"bubblePop.wav"];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    
    
    bubbleBackgroundImage = [CCSprite spriteWithImageNamed:@"background.png"];
    bubbleBackgroundImage.anchorPoint = CGPointMake(0, 0);
    [self addChild:bubbleBackgroundImage];
    
//    CCSprite *userNameSprite = [CCSprite spriteWithImageNamed:@"userNameTextField.png"];
//    CCTextField *userNameTextField = [CCTextField textFieldWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"userNameTextField.png"]];
//    userNameTextField.fontSize = 16.0f;
//    userNameTextField.contentSize = CGSizeMake(180.0f, 30.0f);
//    userNameTextField.preferredSize = userNameSprite.contentSize;
//    userNameTextField.positionType = CCPositionTypeNormalized;
//    userNameTextField.position = ccp(0.38f, 0.7f);
//    [self addChild:userNameTextField];
//    NSLog(@"%@", userNameTextField.textField.description);
    
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Bubble Pop" fontName:@"Chalkduster" fontSize:42.0f * fontMultiplier];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.90f); // Upper - Middle of screen
    [self addChild:label];

//    userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(142, 65, 200, 30)];
//    [userNameTextField setDelegate:self];
//    [userNameTextField setText:@""];
//    [[[CCDirector sharedDirector] view] addSubview:userNameTextField];
//    
//    [userNameTextField becomeFirstResponder];
//    userNameTextField.returnKeyType = UIReturnKeyDone;
//    userNameTextField.placeholder = @"Enter User Name";
//    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Save the Bubbles ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.80f);
    [helloWorldButton setTarget:self selector:@selector(onGameStartClicked:)];
    [self addChild:helloWorldButton];

    // Credits scene button
    CCButton *creditsButton = [CCButton buttonWithTitle:@"[ Game Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    creditsButton.positionType = CCPositionTypeNormalized;
    creditsButton.position = ccp(0.5f, 0.68f);
    [creditsButton setTarget:self selector:@selector(onCreditsClicked:)];
    [self addChild:creditsButton];
    
    // Instructions scene button
    CCButton *instructionsButton = [CCButton buttonWithTitle:@"[ Instructions ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructionsButton.positionType = CCPositionTypeNormalized;
    instructionsButton.position = ccp(0.5f, 0.56f);
    [instructionsButton setTarget:self selector:@selector(onInstructionsClicked:)];
    [self addChild:instructionsButton];
    
    // Internal Leader Board scene button
    CCButton *internalLeaderBoardButton = [CCButton buttonWithTitle:@"[ Internal Leaderboard ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    internalLeaderBoardButton.positionType = CCPositionTypeNormalized;
    internalLeaderBoardButton.position = ccp(0.5f, 0.44f);
    [internalLeaderBoardButton setTarget:self selector:@selector(onInternalLeaderBoardClicked:)];
    [self addChild:internalLeaderBoardButton];
    
    // Published Leader Board scene button
    CCButton *publishedLeaderBoardButton = [CCButton buttonWithTitle:@"[ Published Leaderboard ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    publishedLeaderBoardButton.positionType = CCPositionTypeNormalized;
    publishedLeaderBoardButton.position = ccp(0.5f, 0.32f);
    [publishedLeaderBoardButton setTarget:self selector:@selector(onPublishedLeaderBoardClicked:)];
    [self addChild:publishedLeaderBoardButton];
    
    // Login scene button
    CCButton *loginButton = [CCButton buttonWithTitle:@"[ Login ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    loginButton.positionType = CCPositionTypeNormalized;
    loginButton.position = ccp(0.5f, 0.20f);
    [loginButton setTarget:self selector:@selector(onLoginClicked:)];
    [self addChild:loginButton];
    
    // Create Account scene button
    CCButton *creatAccountButton = [CCButton buttonWithTitle:@"[ Create Account ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    creatAccountButton.positionType = CCPositionTypeNormalized;
    creatAccountButton.position = ccp(0.5f, 0.08f);
    [creatAccountButton setTarget:self selector:@selector(onCreateAccountClicked:)];
    [self addChild:creatAccountButton];

    
    // done
    
    // Check to see if there is a currently logged in player. If not, disable the 'Save the Bubbles' button.
    if (!currentUser) {
        helloWorldButton.opacity = 0.50f;
        helloWorldButton.userInteractionEnabled = NO;
    } else {
        PlayerSingleton *playerSingleton = [PlayerSingleton GetInstance];
        playerSingleton.playerName = currentUser.username;
        NSLog(@"%@", currentUser.username);
    }
    
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onGameStartClicked:(id)sender
{
    userNameTextField.hidden = YES;
    
    // start game scene with transition
    [[CCDirector sharedDirector] replaceScene:[ImmersiveScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onCreditsClicked:(id)sender
{
    userNameTextField.hidden = YES;
    // start credits scene with transition
    [[CCDirector sharedDirector] replaceScene:[CreditsScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onInstructionsClicked:(id)sender
{
    userNameTextField.hidden = YES;
    // start instructions scene with transition
    [[CCDirector sharedDirector] replaceScene:[InstructionsScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onInternalLeaderBoardClicked:(id)sender
{
//    userNameTextField.hidden = YES;
    
    // start Internal Leaderboard scene with transition
    LeaderBoardViewController *leaderBoardViewController = [[LeaderBoardViewController alloc] init];
    [[CCDirector sharedDirector] presentViewController:leaderBoardViewController animated:YES completion:nil];

    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onPublishedLeaderBoardClicked:(id)sender
{
    //    userNameTextField.hidden = YES;
    
    // start Internal Leaderboard scene with transition
    PublishedViewController *publishedViewController = [[PublishedViewController alloc] init];
    [[CCDirector sharedDirector] presentViewController:publishedViewController animated:YES completion:nil];
    
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onLoginClicked:(id)sender
{
    //    userNameTextField.hidden = YES;
    
    // start Login scene with transition
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [[CCDirector sharedDirector] presentViewController:loginViewController animated:YES completion:nil];
    
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onCreateAccountClicked:(id)sender
{
    
    // start Create Account scene with transition
    SignupViewController *signupViewController = [[SignupViewController alloc] init];
    [[CCDirector sharedDirector] presentViewController:signupViewController animated:YES completion:nil];
    
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}


// -----------------------------------------------------------------------
#pragma mark - UITextField Methods
// -----------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        PlayerSingleton *playerSingleton = [PlayerSingleton GetInstance];
        playerSingleton.playerName = textField.text;
    }
    
    return YES;
}


// -----------------------------------------------------------------------
@end
