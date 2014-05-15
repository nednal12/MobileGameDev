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

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
{
    CCSprite *bubbleBackgroundImage;
    ALBuffer *bubblePopSound;
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
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Bubble Pop" fontName:@"Chalkduster" fontSize:42.0f * fontMultiplier];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.85f); // Upper - Middle of screen
    [self addChild:label];
    /*
    CCLabelTTF *instructions1 = [CCLabelTTF labelWithString:@"Get 10 bubbles to the top" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions1.positionType = CCPositionTypeNormalized;
    instructions1.color = [CCColor redColor];
    instructions1.position = ccp(0.5f, 0.70f); // Below the game title
    [self addChild:instructions1];
    
    CCLabelTTF *instructions2 = [CCLabelTTF labelWithString:@"before 5 bubbles are popped by" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions2.positionType = CCPositionTypeNormalized;
    instructions2.color = [CCColor redColor];
    instructions2.position = ccp(0.5f, 0.60f); // Below the game title
    [self addChild:instructions2];

    CCLabelTTF *instructions3 = [CCLabelTTF labelWithString:@"the bombs and spikes." fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions3.positionType = CCPositionTypeNormalized;
    instructions3.color = [CCColor redColor];
    instructions3.position = ccp(0.5f, 0.50f); // Below the game title
    [self addChild:instructions3];
    
    CCLabelTTF *instructions4 = [CCLabelTTF labelWithString:@"You may pop the bubbles without penalty" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions4.positionType = CCPositionTypeNormalized;
    instructions4.color = [CCColor redColor];
    instructions4.position = ccp(0.5f, 0.40f); // Below the game title
    [self addChild:instructions4];
    
    CCLabelTTF *instructions5 = [CCLabelTTF labelWithString:@"in order to save them from being popped." fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions5.positionType = CCPositionTypeNormalized;
    instructions5.color = [CCColor redColor];
    instructions5.position = ccp(0.5f, 0.30f); // Below the game title
    [self addChild:instructions5];
    
    */
     
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Save the Bubbles ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.60f);
    [helloWorldButton setTarget:self selector:@selector(onGameStartClicked:)];
    [self addChild:helloWorldButton];

    // Credits scene button
    CCButton *creditsButton = [CCButton buttonWithTitle:@"[ Game Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    creditsButton.positionType = CCPositionTypeNormalized;
    creditsButton.position = ccp(0.5f, 0.45f);
    [creditsButton setTarget:self selector:@selector(onCreditsClicked:)];
    [self addChild:creditsButton];
    
    // Instructions scene button
    CCButton *instructionsButton = [CCButton buttonWithTitle:@"[ Instructions ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructionsButton.positionType = CCPositionTypeNormalized;
    instructionsButton.position = ccp(0.5f, 0.30f);
    [instructionsButton setTarget:self selector:@selector(onInstructionsClicked:)];
    [self addChild:instructionsButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onGameStartClicked:(id)sender
{
    // start game scene with transition
    [[CCDirector sharedDirector] replaceScene:[ImmersiveScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onCreditsClicked:(id)sender
{
    // start credits scene with transition
    [[CCDirector sharedDirector] replaceScene:[CreditsScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

- (void)onInstructionsClicked:(id)sender
{
    // start instructions scene with transition
    [[CCDirector sharedDirector] replaceScene:[InstructionsScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

// -----------------------------------------------------------------------
@end
