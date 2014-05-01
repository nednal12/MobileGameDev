//
//  CreditsScene.m
//  GameConcept
//
//  Created by Brent Marohnic on 4/2/14.
//  Copyright Brent Marohnic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "CreditsScene.h"

// -----------------------------------------------------------------------
#pragma mark - CreditsScene
// -----------------------------------------------------------------------

@implementation CreditsScene
{
    CCSprite *bubbleBackgroundImage;
    ALBuffer *bubblePopSound;
}
// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (CreditsScene *)scene
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
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"CREDITS" fontName:@"Chalkduster" fontSize:38.0f * fontMultiplier];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.95f); // Upper - Middle of screen
    [self addChild:label];
    
    CCLabelTTF *instructions1 = [CCLabelTTF labelWithString:@"Background" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions1.positionType = CCPositionTypeNormalized;
    instructions1.color = [CCColor redColor];
    instructions1.position = ccp(0.5f, 0.85f); // Below the game title
    [self addChild:instructions1];
    
    CCLabelTTF *instructions2 = [CCLabelTTF labelWithString:@"TheWallPapers" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    instructions2.positionType = CCPositionTypeNormalized;
    instructions2.color = [CCColor redColor];
    instructions2.position = ccp(0.5f, 0.80f); // Below the game title
    [self addChild:instructions2];
    
    CCLabelTTF *instructions3 = [CCLabelTTF labelWithString:@"http://www.thewallpapers.org/desktop/23048/-blue-one-and-bubbles-wallpaper#.U0-nGl4qn6k" fontName:@"Verdana-Bold" fontSize:8.0f * fontMultiplier];
    instructions3.positionType = CCPositionTypeNormalized;
    instructions3.color = [CCColor redColor];
    instructions3.position = ccp(0.5f, 0.75f); // Below the game title
    [self addChild:instructions3];
    
    CCLabelTTF *instructions4 = [CCLabelTTF labelWithString:@"Both Bubbles Seen During Game Play" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions4.positionType = CCPositionTypeNormalized;
    instructions4.color = [CCColor redColor];
    instructions4.position = ccp(0.5f, 0.70f); // Below the game title
    [self addChild:instructions4];
    
    CCLabelTTF *instructions5 = [CCLabelTTF labelWithString:@"ziutu" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    instructions5.positionType = CCPositionTypeNormalized;
    instructions5.color = [CCColor redColor];
    instructions5.position = ccp(0.5f, 0.65f); // Below the game title
    [self addChild:instructions5];
    
    CCLabelTTF *instructions6 = [CCLabelTTF labelWithString:@"http://www.ipadniks.com/two-blue-bubbles-open-walls-10552.html" fontName:@"Verdana-Bold" fontSize:8.0f * fontMultiplier];
    instructions6.positionType = CCPositionTypeNormalized;
    instructions6.color = [CCColor redColor];
    instructions6.position = ccp(0.5f, 0.60f); // Below the game title
    [self addChild:instructions6];
    
    CCLabelTTF *instructions7 = [CCLabelTTF labelWithString:@"Reb Bomb Seen During Game Play" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions7.positionType = CCPositionTypeNormalized;
    instructions7.color = [CCColor redColor];
    instructions7.position = ccp(0.5f, 0.55f); // Below the game title
    [self addChild:instructions7];
    
    CCLabelTTF *instructions8 = [CCLabelTTF labelWithString:@"ClipArtBest" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    instructions8.positionType = CCPositionTypeNormalized;
    instructions8.color = [CCColor redColor];
    instructions8.position = ccp(0.5f, 0.50f); // Below the game title
    [self addChild:instructions8];
    
    CCLabelTTF *instructions9 = [CCLabelTTF labelWithString:@"http://www.clipartbest.com/mad-cartoon-face" fontName:@"Verdana-Bold" fontSize:8.0f * fontMultiplier];
    instructions9.positionType = CCPositionTypeNormalized;
    instructions9.color = [CCColor redColor];
    instructions9.position = ccp(0.5f, 0.45f); // Below the game title
    [self addChild:instructions9];
    
    CCLabelTTF *instructions10 = [CCLabelTTF labelWithString:@"Crying Baby Seen in Logo" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions10.positionType = CCPositionTypeNormalized;
    instructions10.color = [CCColor redColor];
    instructions10.position = ccp(0.5f, 0.40f); // Below the game title
    [self addChild:instructions10];
    
    CCLabelTTF *instructions11 = [CCLabelTTF labelWithString:@"Afranko Blog" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    instructions11.positionType = CCPositionTypeNormalized;
    instructions11.color = [CCColor redColor];
    instructions11.position = ccp(0.5f, 0.35f); // Below the game title
    [self addChild:instructions11];
    
    CCLabelTTF *instructions12 = [CCLabelTTF labelWithString:@"http://www.afranko.com/2013/11/crying-cartoon/" fontName:@"Verdana-Bold" fontSize:8.0f * fontMultiplier];
    instructions12.positionType = CCPositionTypeNormalized;
    instructions12.color = [CCColor redColor];
    instructions12.position = ccp(0.5f, 0.30f); // Below the game title
    [self addChild:instructions12];
    
    CCLabelTTF *instructions13 = [CCLabelTTF labelWithString:@"Sound Effects" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    instructions13.positionType = CCPositionTypeNormalized;
    instructions13.color = [CCColor redColor];
    instructions13.position = ccp(0.5f, 0.25f); // Below the game title
    [self addChild:instructions13];
    
    CCLabelTTF *instructions14 = [CCLabelTTF labelWithString:@"Westarmusic" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    instructions14.positionType = CCPositionTypeNormalized;
    instructions14.color = [CCColor redColor];
    instructions14.position = ccp(0.5f, 0.20f); // Below the game title
    [self addChild:instructions14];
    
    CCLabelTTF *instructions15 = [CCLabelTTF labelWithString:@"http://www.westarmusic.com/sound_effects" fontName:@"Verdana-Bold" fontSize:8.0f * fontMultiplier];
    instructions15.positionType = CCPositionTypeNormalized;
    instructions15.color = [CCColor redColor];
    instructions15.position = ccp(0.5f, 0.15f); // Below the game title
    [self addChild:instructions15];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Main Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.05f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:helloWorldButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
}

// -----------------------------------------------------------------------
@end

