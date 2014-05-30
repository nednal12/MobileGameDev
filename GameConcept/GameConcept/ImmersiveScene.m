//
//  HelloWorldScene.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/7/14.
//  Copyright Brent Marohnic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "ImmersiveScene.h"
#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "CCAnimation.h"
#import "PlayerSingleton.h"
#import "LeaderBoardDB.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>



// -----------------------------------------------------------------------
#pragma mark - ImmersiveScene
// -----------------------------------------------------------------------

@implementation ImmersiveScene
{
    int deadBubbles;
    int successfulBubbles;
    float fontMultiplier;
    CCSprite *bubbleBackgroundImage;
    CCSprite *largeBubble;
    CCSprite *smallBubble;
    CCSprite *smallBomb;
    CCSprite *explosion;
    CCSprite *ceilingSpikes;
    CCSprite *ceilingSpikes2;
    CCSprite *toolbar;
    CCSprite *pauseButton;
    CCSprite *powerButton;
    ALBuffer *bubblePopSound;
    ALBuffer *explosionSound;
    ALBuffer *trumpetFanfare;
    ALBuffer *tubaSadSound;
    
    CCLabelTTF *successfulLabel;
    CCLabelTTF *failureLabel;
    
    //    CCSpriteFrame *explodeFrame;
    CCSpriteFrameCache *explodeFrameCache;
    CCSpriteBatchNode *explodeBatchNode;
    CCAnimation *explodeAnimation;
    CCSprite *explodeSprite;
    CCSprite *feedBack1;
    CCSprite *feedBack2;
    
    CCButton *pauseButton1;
    CCButton *powerButton1;
    
    CCSpriteFrame *pauseButtonFrame;
    CCSpriteFrame *powerButtonFrame;
    
    // Declare the physics node that will be used to detect collisions between the bubbles and the bombs
    CCPhysicsNode *physicsNode;
    
    NSMutableArray *explodeAnimArray;
    
    // The CGPoints for userInteractionEnabled and the CCAction variables are created with global scope so that they are accessible within the various touch methods.
    CGPoint tappedSpot;
    CGPoint tappedSpot2;
    
    CCAction *showSmallBubble;
    CCAction *showLargeBubble;
    
    int successBubbleLimit;
    
    BOOL negAchievement;
    BOOL comAchievement;
    BOOL meaAchievement;
    int incAchievement;
    
    int successfulWOIntervention;
    BOOL awardComAchievement;
    BOOL awardMeaAchievement;
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (ImmersiveScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommends assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    successBubbleLimit = 5;
    awardComAchievement = FALSE;
    awardMeaAchievement = FALSE;
    
    
    // The player information needs to be retrieved here every time the level is played in order to keep the player data in-sync with the Parse backend service. Otherwise, some very frustrating bugs occur and they take forever to figure out.
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    PFObject *object = currentUser;
    [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *player, NSError *error) {
        
        negAchievement = [player[@"negAchievement"] boolValue];
        comAchievement = [player[@"comAchievement"] boolValue];
        meaAchievement = [player[@"meaAchievement"] boolValue];
        incAchievement = [player[@"incAchievement"] intValue];
        NSLog(@"The value for negAchievement is: %tu", negAchievement);
        
    }];
    
    // Set the fontMultiplier so that fonts are sized appropriately regardless of whether they are displayed on a Retina iPhone or iPad
    CGSize whichSize = [CCDirector sharedDirector].viewSize;
    
    if (whichSize.width == 1024) {
        fontMultiplier = 2.0f;
    } else {
        fontMultiplier = 1.0f;
    }
    
    // Set the number of times the player is allowed to have a bubble popped by bombs and spikes
    deadBubbles = 5;
    
    NSString *physicsNodeTag = [NSString stringWithFormat:@"physicsNodeTag"];
    
    // Preload sounds
    bubblePopSound = [[OALSimpleAudio sharedInstance] preloadEffect:@"bubblePop.wav"];
    explosionSound = [[OALSimpleAudio sharedInstance] preloadEffect:@"explosion3.mp3"];
    trumpetFanfare = [[OALSimpleAudio sharedInstance] preloadEffect:@"trumpetFanfare.wav"];
    tubaSadSound = [[OALSimpleAudio sharedInstance] preloadEffect:@"tubaSadSound.wav"];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Set the background image
    bubbleBackgroundImage = [CCSprite spriteWithImageNamed:@"background.png"];
    bubbleBackgroundImage.anchorPoint = CGPointMake(0, 0);
    bubbleBackgroundImage.opacity = 0.90;
    [self addChild:bubbleBackgroundImage];
    
    // Initialize the physics node. This node will be responsible for controlling the collisions between the bubbles and the bombs
    physicsNode = [CCPhysicsNode node];
    physicsNode.gravity = ccp(0,0);
    physicsNode.debugDraw = NO;
    physicsNode.collisionDelegate = self;
    [self addChild:physicsNode z:1 name:physicsNodeTag];
    
    // Initialize the largeBubble sprite
    largeBubble = [CCSprite spriteWithImageNamed:@"largeBubble.png"];
    largeBubble.position = CGPointMake(-largeBubble.contentSize.height, -largeBubble.contentSize.width);
    [physicsNode addChild:largeBubble];
    
    // Define the largeBubble bounding box and add it to the bubbleGroup collisionGroup
    largeBubble.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:largeBubble.contentSize.width/2.0f andCenter:largeBubble.anchorPointInPoints];
    largeBubble.physicsBody.collisionGroup = @"bubbleGroup";
    largeBubble.physicsBody.collisionType = @"largeBubbleCollision";
    
    // Initialize the smallBubble sprite
    smallBubble = [CCSprite spriteWithImageNamed:@"smallBubble.png"];
    smallBubble.position = CGPointMake(-smallBubble.contentSize.height, -smallBubble.contentSize.width);
    [physicsNode addChild:smallBubble];
    
    // Define the smallBubble bounding box and add it to the bubbleGroup collisionGroup
    smallBubble.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:smallBubble.contentSize.width/2.0f andCenter:smallBubble.anchorPointInPoints];
    smallBubble.physicsBody.collisionGroup = @"bubbleGroup";
    smallBubble.physicsBody.collisionType = @"smallBubbleCollision";
    
    // Initialize the smallBomb sprite
    smallBomb = [CCSprite spriteWithImageNamed:@"smallBomb.png"];
    smallBomb.position = CGPointMake(-smallBomb.contentSize.height, -smallBomb.contentSize.width);
    [physicsNode addChild:smallBomb];
    
    // Define the smallBomb bounding box and add it to the bombGroup collisionGroup
    smallBomb.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:smallBomb.contentSize.width/2.0f andCenter:smallBomb.anchorPointInPoints];
    smallBomb.physicsBody.collisionGroup = @"enemyGroup";
    smallBomb.physicsBody.collisionType = @"smallBombCollision";
    
    // Initialize the explosion sprite
    explosion = [CCSprite spriteWithImageNamed:@"explosion.png"];
    explosion.position = CGPointMake(-explosion.contentSize.height, -explosion.contentSize.width);
    [self addChild:explosion];
    
    // Initialize the feedBack1 sprite
    feedBack1 = [CCSprite spriteWithImageNamed:@"feedBack.png"];
    feedBack1.position = CGPointMake(-feedBack1.contentSize.height, -feedBack1.contentSize.width);
    [self addChild:feedBack1];
    
    // Initialize the feedBack2 sprite
    feedBack2 = [CCSprite spriteWithImageNamed:@"feedBack.png"];
    feedBack2.position = CGPointMake(-feedBack2.contentSize.height, -feedBack2.contentSize.width);
    [self addChild:feedBack2];
    
    // Initialize the ceilingSpikes sprite
    ceilingSpikes = [CCSprite spriteWithImageNamed:@"ceilingSpikes.png"];
    ceilingSpikes.anchorPoint = CGPointMake(0,0);
    ceilingSpikes.position = CGPointMake(self.contentSize.width - ceilingSpikes.contentSize.width, self.contentSize.height - ceilingSpikes.contentSize.height);
    [self addChild:ceilingSpikes];
    
    // Initialize the ceilingSpikes2 sprite
    ceilingSpikes2 = [CCSprite spriteWithImageNamed:@"ceilingSpikes.png"];
    ceilingSpikes2.anchorPoint = CGPointMake(0,0);
    ceilingSpikes2.position = CGPointMake(0, self.contentSize.height - ceilingSpikes2.contentSize.height);
    [self addChild:ceilingSpikes2];
    
    // Initialize the toolbar sprite
    toolbar = [CCSprite spriteWithImageNamed:@"toolbar.png"];
    toolbar.anchorPoint = CGPointMake(0,0);
    toolbar.position = CGPointMake(0, self.contentSize.height - toolbar.contentSize.height);
    [self addChild:toolbar z:1];
    
    // Initialize the pauseButton sprite
    pauseButtonFrame = [CCSpriteFrame frameWithImageNamed:@"pauseButton.png"];
    [pauseButton setSpriteFrame:pauseButtonFrame];
    pauseButton1 = [[CCButton alloc] initWithTitle:@"" spriteFrame:pauseButtonFrame];
    [pauseButton1 setTarget:self selector:@selector(onPauseButtonClicked:)];
    pauseButton1.positionType = CCPositionTypeNormalized;
    pauseButton1.position = ccp(0.95f, 0.955f);
    [self addChild:pauseButton1 z:2];
    
    // Initialize the powerButton sprite
    powerButtonFrame = [CCSpriteFrame frameWithImageNamed:@"lightningBolt.png"];
    [powerButton setSpriteFrame:powerButtonFrame];
    powerButton1 = [[CCButton alloc] initWithTitle:@"" spriteFrame:powerButtonFrame];
    [powerButton1 setTarget:self selector:@selector(onPowerButtonClicked:)];
    powerButton1.positionType = CCPositionTypeNormalized;
    powerButton1.position = ccp(0.05f, 0.955f);
    [self addChild:powerButton1];
    
    
    successfulLabel = [CCLabelTTF labelWithString:@"0 / 10" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    successfulLabel.positionType = CCPositionTypeNormalized;
    successfulLabel.color = [CCColor greenColor];
    successfulLabel.position = ccp(0.85f, 0.95f);
    [self addChild:successfulLabel z:2];
    
    failureLabel = [CCLabelTTF labelWithString:@"5" fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    failureLabel.positionType = CCPositionTypeNormalized;
    failureLabel.color = [CCColor redColor];
    failureLabel.position = ccp(0.10f, 0.95f);
    [self addChild:failureLabel z:2];
    
    
    // Initialize the explosion batch node and the explosion sprite sheet
    explodeFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [explodeFrameCache addSpriteFramesWithFile:@"explode.plist"];
    
    explodeSprite = [CCSprite spriteWithImageNamed:@"_0.png"];
    //    explodeSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    
    explodeBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"explode.png"];
    [explodeBatchNode addChild:explodeSprite];
    [self addChild:explodeBatchNode];
    
    
    explodeAnimArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *individualFrames = [NSString stringWithFormat:@"_%d.png", i];
        [explodeAnimArray addObject:[explodeFrameCache spriteFrameByName:individualFrames]];
    }
    
    //    explodeAnimation = [CCAnimation animationWithSpriteFrames:explodeAnimArray delay:0.1f];
    //    [explodeSprite runAction:[CCActionRepeat actionWithAction:[CCActionAnimate actionWithAnimation:explodeAnimation] times:1]];
    
    
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
    //    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // Schedule the methods to trigger at various intervals
    [self schedule:@selector(moveSpikes:) interval:2.0];
    [self schedule:@selector(showPowerUp:) interval:2.0];
    [self schedule:@selector(moveSpikes2:) interval:2.0];
    [self schedule:@selector(throwBomb:) interval:4.0];
    [self schedule:@selector(floatSmallBubble:) interval:5.5];
    [self schedule:@selector(floatLargeBubble:) interval:6.0];
    
    // This scheduled method repeatedly checks to see if a bubble has hit the ceiling spikes
    [self schedule:@selector(bubbleHitSpike:) interval:0.05];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handlers
// -----------------------------------------------------------------------

// touchEnded is used to verify that the user intended to tap and not swipe the bubble. It does this by comparing the position of the initial touch with the position of the final touch. If they are the same, the bubble is popped. If they are not the same then touchMoved handles the swipe gesture.
-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    tappedSpot2 = [touch locationInNode:self];
    
//    if (tappedSpot.x == tappedSpot2.x && tappedSpot.y == tappedSpot2.y) {
    if ((tappedSpot.x >= (tappedSpot2.x - 10.0f) || tappedSpot.x <= (tappedSpot2.x + 10.0f)) && (tappedSpot.y >= (tappedSpot2.y - 10.0f) || tappedSpot.y <= (tappedSpot2.x + 10.0f))){
        if (CGRectContainsPoint(smallBomb.boundingBox, tappedSpot)) {
            [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
            
        } else if (CGRectContainsPoint(largeBubble.boundingBox, tappedSpot)){
            
            largeBubble.physicsBody.collisionGroup = @"enemyGroup";
            largeBubble.physicsBody.collisionType = @"";
            [largeBubble setVisible:NO];
            successfulWOIntervention = 0;
            [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        } else if (CGRectContainsPoint(smallBubble.boundingBox, tappedSpot)){
            
            smallBubble.physicsBody.collisionGroup = @"enemyGroup";
            smallBubble.physicsBody.collisionType = @"";
            [smallBubble setVisible:NO];
            successfulWOIntervention = 0;
            [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        } else if (CGRectContainsPoint(pauseButton.boundingBox, tappedSpot)){
            if ([[CCDirector sharedDirector] isPaused] ) {
                [[CCDirector sharedDirector] resume];
            } else {
                [[CCDirector sharedDirector] pause];
            }
            
        }
        
    }
    
}


// touchMoved is used to override the initial actionWithDuration methods on the CCAction objects. The durations are decreased so that the bubble rises much faster after being swiped by the user.
-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(largeBubble.boundingBox, tappedSpot)){
        
        showLargeBubble = [CCActionMoveTo actionWithDuration:1.0 position:CGPointMake(largeBubble.position.x, self.contentSize.height + largeBubble.contentSize.height)];
        [largeBubble runAction:[CCActionSequence actionWithArray:@[showLargeBubble]]];
        
        
    } else if (CGRectContainsPoint(smallBubble.boundingBox, tappedSpot)){
        
        showSmallBubble = [CCActionMoveTo actionWithDuration:1.0 position:CGPointMake(smallBubble.position.x, self.contentSize.height + smallBubble.contentSize.height)];
        [smallBubble runAction:[CCActionSequence actionWithArray:@[showSmallBubble]]];
        
    }
}


// touchBegan is only used to acquire the positon of the initial touch. This info is then used in both touchMoved and touchEnded in order to take the correct action depending on whether the user attempted to tap or swipe the bubble.
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    tappedSpot = [touch locationInNode:self];
    
}

// -----------------------------------------------------------------------


// throwBomb is called at regular intervals using a scheduler
-(void)throwBomb:(CCTime)ccTime
{
    // Reset the collisionGroup, the collisionType and the visibility
    // This is required if the bomb has already hit one bubble since these parameters are altered at the time of impact
    smallBomb.physicsBody.collisionGroup = @"enemyGroup";
    smallBomb.physicsBody.collisionType = @"smallBombCollision";
    [smallBomb setVisible:YES];
    
    // Calculate a pseudorandom starting point for the bomb to appear on the right side of the screen
    int minYAxis = smallBomb.contentSize.height / 2 + ceilingSpikes.contentSize.height;
    int maxYAxis = self.contentSize.height - (ceilingSpikes.contentSize.height) - smallBomb.contentSize.height / 2;
    int spanY = maxYAxis - minYAxis;
    int spawnY = (arc4random() % spanY) + minYAxis;
    
    smallBomb.position = CGPointMake(self.contentSize.width + smallBomb.contentSize.width / 2, spawnY);
    
    // Send the bomb sailing across the screen from right to left
    CCAction *showSmallBomb = [CCActionMoveTo actionWithDuration:3.0 position:CGPointMake(-smallBomb.contentSize.width, spawnY)];
    [smallBomb runAction:[CCActionSequence actionWithArray:@[showSmallBomb]]];
}


// moveSpikes is called at regular intervals using a scheduler
-(void)moveSpikes:(CCTime)ccTime
{
    if (CGPointEqualToPoint(ceilingSpikes.position, CGPointMake(self.contentSize.width - ceilingSpikes.contentSize.width, self.contentSize.height - ceilingSpikes.contentSize.height))) {
        CCAction *moveSpikes = [CCActionMoveTo actionWithDuration:1.5 position:CGPointMake(self.contentSize.width / 2, ceilingSpikes.position.y)];
        [ceilingSpikes runAction:[CCActionSequence actionWithArray:@[moveSpikes]]];
    } else {
        CCAction *moveSpikes = [CCActionMoveTo actionWithDuration:1.5 position:CGPointMake(self.contentSize.width - ceilingSpikes.contentSize.width, self.contentSize.height - ceilingSpikes.contentSize.height)];
        [ceilingSpikes runAction:[CCActionSequence actionWithArray:@[moveSpikes]]];
    }

}

// moveSpikes2 is called at regular intervals using a scheduler
-(void)moveSpikes2:(CCTime)ccTime
{
    if (CGPointEqualToPoint(ceilingSpikes2.position, CGPointMake(0, self.contentSize.height - ceilingSpikes2.contentSize.height))) {
        CCAction *moveSpikes2 = [CCActionMoveTo actionWithDuration:1.5 position:CGPointMake(self.contentSize.width / 2 - ceilingSpikes2.contentSize.width, ceilingSpikes2.position.y)];
        [ceilingSpikes2 runAction:[CCActionSequence actionWithArray:@[moveSpikes2]]];
    } else {
        CCAction *moveSpikes2 = [CCActionMoveTo actionWithDuration:1.5 position:CGPointMake(0, self.contentSize.height - ceilingSpikes2.contentSize.height)];
        [ceilingSpikes2 runAction:[CCActionSequence actionWithArray:@[moveSpikes2]]];
    }
    
}


// floatSmallBubble is called at regular intervals using a scheduler
-(void)floatSmallBubble:(CCTime)ccTime
{
    // Reset the collisionGroup, the collisionType and the visibility
    // This is required if the bubble was hit by a bomb or tapped by the user since these parameters are altered at the time of impact
    smallBubble.physicsBody.collisionGroup = @"bubbleGroup";
    smallBubble.physicsBody.collisionType = @"smallBubbleCollision";
    [smallBubble setVisible:YES];
    smallBubble.opacity = 1.0f;
    
    // Calculate a pseudorandom starting point for the bubble to appear at the bottom of the screen
    int minXAxis = smallBubble.contentSize.width / 2;
    int maxXAxis = self.contentSize.width - smallBubble.contentSize.width / 2;
    int spanX = maxXAxis - minXAxis;
    int spawnX = (arc4random() % spanX) + minXAxis;
    
    feedBack1.position = CGPointMake(spawnX, feedBack1.contentSize.height / 2);
    CCActionDelay *feedBackDuration = [CCActionDelay actionWithDuration:0.25f];
    CCActionFadeOut *feedBackFadeDuration = [CCActionFadeOut actionWithDuration:0.25f];
    [feedBack1 runAction:[CCActionSequence actionWithArray:@[feedBackDuration,feedBackFadeDuration]]];
    
    smallBubble.position = CGPointMake(spawnX, -self.contentSize.height + smallBubble.contentSize.height / 2);
    
    // Send the bubble floating up the screen from bottom to top
    showSmallBubble = [CCActionMoveTo actionWithDuration:4.0 position:CGPointMake(spawnX, self.contentSize.height + smallBubble.contentSize.height)];
    [smallBubble runAction:[CCActionSequence actionWithArray:@[showSmallBubble]]];
    
}

// floatLargeBubble is called at regular intervals using a scheduler
-(void)floatLargeBubble:(CCTime)ccTime
{
    // Reset the collisionGroup, the collisionType and the visibility
    // This is required if the bubble was hit by a bomb or tapped by the user since these parameters are altered at the time of impact
    largeBubble.physicsBody.collisionGroup = @"bubbleGroup";
    largeBubble.physicsBody.collisionType = @"largeBubbleCollision";
    [largeBubble setVisible:YES];
    largeBubble.opacity = 1.0f;
    
    // Calculate a pseudorandom starting point for the bubble to appear at the bottom of the screen
    int minXAxis = largeBubble.contentSize.width / 2;
    int maxXAxis = self.contentSize.width - largeBubble.contentSize.width / 2;
    int spanX = maxXAxis - minXAxis;
    int spawnX = (arc4random() % spanX) + minXAxis;
    
    feedBack2.position = CGPointMake(spawnX, feedBack2.contentSize.height / 2);
    CCActionDelay *feedBackDuration = [CCActionDelay actionWithDuration:0.25f];
    CCActionFadeOut *feedBackFadeDuration = [CCActionFadeOut actionWithDuration:0.25f];
    [feedBack2 runAction:[CCActionSequence actionWithArray:@[feedBackDuration,feedBackFadeDuration]]];
    
    largeBubble.position = CGPointMake(spawnX, -self.contentSize.height + largeBubble.contentSize.height / 2);
    
    // Send the bubble floating up the screen from bottom to top
    showLargeBubble = [CCActionMoveTo actionWithDuration:4.0 position:CGPointMake(spawnX, self.contentSize.height + largeBubble.contentSize.height)];
    [largeBubble runAction:[CCActionSequence actionWithArray:@[showLargeBubble]]];
    
}

// This method is called whenever a smallBubble and a bomb come into contact
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair smallBubbleCollision:(CCNode *)bubble smallBombCollision:(CCNode *)bomb{
    
    if (smallBubble.opacity == 1.0f) {
        
    
    // Decrement the deadBubbles counter
    deadBubbles--;
    
    // Show the explosion sprite briefly after the bubble and the bomb make contact
    // explosion was the old sprite used before the animated explodeSprite was introduced
    // Keeping the following lines here just in case I need them again someday
    //    explosion.position = CGPointMake(smallBomb.position.x - smallBomb.contentSize.height / 2, smallBomb.position.y - smallBomb.contentSize.width / 2);
    //    CCActionDelay *explosionDuration = [CCActionDelay actionWithDuration:0.25f];
    //    CCActionFadeOut *explosionFadeDuration = [CCActionFadeOut actionWithDuration:0.25f];
    //    [explosion runAction:[CCActionSequence actionWithArray:@[explosionDuration,explosionFadeDuration]]];
    
    explodeSprite.position = CGPointMake(smallBomb.position.x - smallBomb.contentSize.height / 2, smallBomb.position.y - smallBomb.contentSize.width / 2);
    explodeAnimation = [CCAnimation animationWithSpriteFrames:explodeAnimArray delay:0.1f];
    [explodeSprite runAction:[CCActionRepeat actionWithAction:[CCActionAnimate actionWithAnimation:explodeAnimation] times:1]];
    
    [self removeChild:failureLabel];
    failureLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", deadBubbles] fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    failureLabel.positionType = CCPositionTypeNormalized;
    failureLabel.color = [CCColor redColor];
    failureLabel.position = ccp(0.10f, 0.95f);
    [self addChild:failureLabel z:2];
    
    // Call endTheGameFail if deadBubbles reaches zero and successfulBubbles is less than 10

    if (deadBubbles <= 0 && successfulBubbles < successBubbleLimit) {
        [self endTheGameFail];
        // Otherwise play the explosion sound and set the visibility of the bomb and bubble to invisible
    } else if (deadBubbles <= 0 && successfulBubbles >= successBubbleLimit){
        [self endTheGameSuccess];
    } else {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        smallBomb.physicsBody.collisionType = @"";
        bubble.physicsBody.collisionGroup = @"enemyGroup";
        [bubble setVisible:NO];
        [bomb setVisible:NO];
    }
    
    }
    return TRUE;
}

// This method is called whenever a largeBubble and a bomb come into contact
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair largeBubbleCollision:(CCNode *)bubble smallBombCollision:(CCNode *)bomb{
    
    if (largeBubble.opacity == 1.0f) {
        
    
    // Decrement the deadBubbles counter
    deadBubbles--;
    
    // Show the explosion sprite briefly after the bubble and the bomb make contact
    // explosion was the old sprite used before the animated explodeSprite was introduced
    // Keeping the following lines here just in case I need them again someday
    //    explosion.position = CGPointMake(smallBomb.position.x - smallBomb.contentSize.height / 2, smallBomb.position.y - smallBomb.contentSize.width / 2);
    //    CCActionDelay *explosionDuration = [CCActionDelay actionWithDuration:0.25f];
    //    CCActionFadeOut *explosionFadeDuration = [CCActionFadeOut actionWithDuration:0.25f];
    //    [explosion runAction:[CCActionSequence actionWithArray:@[explosionDuration,explosionFadeDuration]]];
    
    explodeSprite.position = CGPointMake(smallBomb.position.x - smallBomb.contentSize.height / 2, smallBomb.position.y - smallBomb.contentSize.width / 2);
    explodeAnimation = [CCAnimation animationWithSpriteFrames:explodeAnimArray delay:0.1f];
    [explodeSprite runAction:[CCActionRepeat actionWithAction:[CCActionAnimate actionWithAnimation:explodeAnimation] times:1]];
    
    [self removeChild:failureLabel];
    failureLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", deadBubbles] fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
    failureLabel.positionType = CCPositionTypeNormalized;
    failureLabel.color = [CCColor redColor];
    failureLabel.position = ccp(0.10f, 0.95f);
    [self addChild:failureLabel z:2];
    
    // Call endTheGameFail if deadBubbles reaches zero and successfulBubbles is less than 10

    if (deadBubbles <= 0 && successfulBubbles < successBubbleLimit) {
        [self endTheGameFail];
        // Otherwise play the explosion sound and set the visibility of the bomb and bubble to invisible
    } else if(deadBubbles <= 0 && successfulBubbles >= successBubbleLimit){
        [self endTheGameSuccess];
    } else {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        smallBomb.physicsBody.collisionType = @"";
        bubble.physicsBody.collisionGroup = @"enemyGroup";
        [bubble setVisible:NO];
        [bomb setVisible:NO];
    }
    
    }
    return TRUE;
}

// bubbleHitSpike is called at regular intervals using a scheduler
-(void)bubbleHitSpike:(CCTime)delta{
    // Check to see if the smallBubble came into contact with either set of spikes
    // Make sure it wasn't already hit by a bomb or popped by the player by checking the visible property
    if ((CGRectIntersectsRect(smallBubble.boundingBox, ceilingSpikes.boundingBox) || CGRectIntersectsRect(smallBubble.boundingBox, ceilingSpikes2.boundingBox)) && smallBubble.visible == TRUE && smallBubble.opacity == 1.0f) {
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        [smallBubble setVisible:NO];
        // Decrement the deadBubbles counter
        deadBubbles--;
        
        [self removeChild:failureLabel];
        failureLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", deadBubbles] fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
        failureLabel.positionType = CCPositionTypeNormalized;
        failureLabel.color = [CCColor redColor];
        failureLabel.position = ccp(0.10f, 0.95f);
        [self addChild:failureLabel z:2];
        
        
        // Call endTheGameFail if deadBubbles reaches zero and successfulBubbles is less than 10

        if (deadBubbles <= 0 && successfulBubbles < successBubbleLimit) {
            [self endTheGameFail];
        } else if (deadBubbles <= 0 && successfulBubbles >= successBubbleLimit){
            [self endTheGameSuccess];
        }
        
        // Check to see if the largeBubble came into contact with either set of spikes
        // Make sure it wasn't already hit by a bomb or popped by the player by checking the visible property
    } else if ((CGRectIntersectsRect(largeBubble.boundingBox, ceilingSpikes.boundingBox) || CGRectIntersectsRect(largeBubble.boundingBox, ceilingSpikes2.boundingBox)) && largeBubble.visible == TRUE && largeBubble.opacity == 1.0f) {
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        [largeBubble setVisible:NO];
        // Decrement the deadBubbles counter
        deadBubbles--;
        
        [self removeChild:failureLabel];
        failureLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", deadBubbles] fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
        failureLabel.positionType = CCPositionTypeNormalized;
        failureLabel.color = [CCColor redColor];
        failureLabel.position = ccp(0.10f, 0.95f);
        [self addChild:failureLabel z:2];
        
        
        // Call endTheGameFail if deadBubbles reaches zero and successfulBubbles is less than successfulBubbleLimit

        if (deadBubbles <= 0 && successfulBubbles < successBubbleLimit) {
            [self endTheGameFail];
        } else if (deadBubbles <= 0 && successfulBubbles >= successBubbleLimit){
            [self endTheGameSuccess];
        }
    } else if (largeBubble.position.y > self.contentSize.height && largeBubble.visible == TRUE){
        [self removeChild:successfulLabel];
        successfulBubbles++;
        successfulWOIntervention++;
        if (successfulWOIntervention == 5) {
            awardComAchievement = TRUE;
        }
        if (successfulBubbles == 10 && deadBubbles == 5) {
            awardMeaAchievement = TRUE;
        }
        NSString *tempString = [NSString stringWithFormat:@"%d / 10", successfulBubbles];
        successfulLabel = [CCLabelTTF labelWithString:tempString fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
        successfulLabel.positionType = CCPositionTypeNormalized;
        successfulLabel.color = [CCColor greenColor];
        successfulLabel.position = ccp(0.85f, 0.95f);
        
        if (successfulBubbles < successBubbleLimit) {
            [self addChild:successfulLabel z:2];
        } else {
            [self addChild:successfulLabel z:2];
//            [self endTheGameSuccess];
        }
        
        [largeBubble setVisible:NO];
        
    } else if (smallBubble.position.y > self.contentSize.height && smallBubble.visible == TRUE){
        [self removeChild:successfulLabel];
        successfulBubbles++;
        successfulWOIntervention++;
        if (successfulWOIntervention == 5) {
            awardComAchievement = TRUE;
        }
        if (successfulBubbles == 10 && deadBubbles == 5) {
            awardMeaAchievement = TRUE;
        }
        NSString *tempString = [NSString stringWithFormat:@"%d / 10", successfulBubbles];
        successfulLabel = [CCLabelTTF labelWithString:tempString fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
        successfulLabel.positionType = CCPositionTypeNormalized;
        successfulLabel.color = [CCColor greenColor];
        successfulLabel.position = ccp(0.85f, 0.95f);
        
        if (successfulBubbles < successBubbleLimit) {
            [self addChild:successfulLabel z:2];
        } else {
            [self addChild:successfulLabel z:2];
//            [self endTheGameSuccess];
        }
        
        [smallBubble setVisible:NO];
    }
    
    
}


// showPowerUp is called at regular intervals using a scheduler
// The player will have a 10% chance of getting the powerUp button every two seconds
// The power up button will be revealed and concealed by altering the z order.
-(void)showPowerUp:(CCTime)delta{
    int showPowerUp = arc4random_uniform(99);
    
    if (showPowerUp >= 90) {
        powerButton1.zOrder = 2;
        
    } else {
        
        powerButton1.zOrder = 0;
    }
}

// Called when the player allowed more than four bubbles to get popped by the bombs and spikes before getting at least 10 bubbles to the top
-(void)endTheGameFail
{
    // Play a sorrowful tuba cadence
    [[OALSimpleAudio sharedInstance] playBuffer:tubaSadSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    
    // Award the player the Negative Achievement for not getting 5 bubbles to the top
    if (!negAchievement) {
    
        // Retrieve the object by id
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        PFObject *object = currentUser;
        [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *player, NSError *error) {
            
            player[@"negAchievement"] = @YES;
            
            // [agents saveInBackground];
            [player saveEventually];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations" message: @"You've been awarded the Negative Achievement for your inability to get 5 bubbles to the top." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
        }];
    
    }

    
    
    
    // Remove all the sprites and unshedule all of the schedulers
    [largeBubble removeFromParent];
    [smallBomb removeFromParent];
    [smallBubble removeFromParent];
    [self unschedule:@selector(floatSmallBubble:)];
    [self unschedule:@selector(floatLargeBubble:)];
    [self unschedule:@selector(throwBomb:)];
    [self unschedule:@selector(bubbleHitSpike:)];
    [self unschedule:@selector(moveSpikes:)];
    [self unschedule:@selector(moveSpikes2:)];
    [self unschedule:@selector(showPowerUp:)];
    
    // Introscene button
    CCButton *youLostButton = [CCButton buttonWithTitle:@"[ You Lost ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    youLostButton.positionType = CCPositionTypeNormalized;
    youLostButton.position = ccp(0.5f, 0.35f);
    [youLostButton setTarget:self selector:@selector(onYouLostClicked:)];
    [self addChild:youLostButton];
}


// Called when the player achieves victory by getting 10 bubbles to the top of the screen before having 5 bubbles popped by the bombs and spikes
-(void)endTheGameSuccess
{
    // Pleay a triumphant trumpet cadence
    [[OALSimpleAudio sharedInstance] playBuffer:trumpetFanfare volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    
    // Award the player the Incrmental Achievement. Player earns this every time he/she exceeds a new 10 bubble threshold.
    // Use the floor function to determine which threshold divisable by 10 was surpassed
    int tempInt = 10 * floor((successfulBubbles / 10)+0.5);
    
    if ((incAchievement * 10) < tempInt) {
        
        int tempIncAchievement = successfulBubbles / 10;
        NSNumber *intTemp = [[NSNumber alloc] initWithInteger:tempIncAchievement];
        // Retrieve the object by id
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        PFObject *object = currentUser;
        [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *player, NSError *error) {
            
            player[@"incAchievement"] = intTemp;
            
            // [agents saveInBackground];
            [player saveEventually];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations" message: [NSString stringWithFormat: @"You've been awarded the Incremental Achievement for your ability to get at least %d bubbles to the top.", tempInt] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
        }];
    }
    
    if (awardComAchievement == TRUE && comAchievement == FALSE) {
        
        // Retrieve the object by id
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        PFObject *object = currentUser;
        [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *player, NSError *error) {
            
            player[@"comAchievement"] = @YES;
            
            // [agents saveInBackground];
            [player saveEventually];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"You've been awarded the Completion Achievement for your ability to get at least 5 bubbles to the top without manually popping any." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
        }];
    }

    if (awardMeaAchievement == TRUE && meaAchievement == FALSE) {
        
        // Retrieve the object by id
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        PFObject *object = currentUser;
        [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *player, NSError *error) {
            
            player[@"meaAchievement"] = @YES;
            
            // [agents saveInBackground];
            [player saveEventually];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"You've been awarded the Measurement Achievement for your ability to get 10 bubbles to the top without having any popped." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
        }];
    }
    
    // Remove all the sprites and unshedule all of the schedulers
    [largeBubble removeFromParent];
    [smallBomb removeFromParent];
    [smallBubble removeFromParent];
    [self unschedule:@selector(floatSmallBubble:)];
    [self unschedule:@selector(floatLargeBubble:)];
    [self unschedule:@selector(throwBomb:)];
    [self unschedule:@selector(bubbleHitSpike:)];
    [self unschedule:@selector(moveSpikes:)];
    [self unschedule:@selector(moveSpikes2:)];
    [self unschedule:@selector(showPowerUp:)];
    
    // Send the score to PlayerSingleton
    PlayerSingleton *playerSingleton = [PlayerSingleton GetInstance];
    playerSingleton.playerScore = successfulBubbles;
    
    // secondsFromGMT actually returns an NSInteger but iOS does mind it too much if the value is placed in a double
    // The reason for doing that is so the offset can be used as the input to the NSDate method dateByAddingTimeInterval
    // Doing this actually returns the correct time for the user specific locale
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    double offset = timeZone.secondsFromGMT;
    NSDate *now = [[NSDate date] dateByAddingTimeInterval: offset];
    
    
    double tempDouble = [now timeIntervalSinceReferenceDate];
    playerSingleton.playerDate = tempDouble;
    NSDate *convertedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:tempDouble];
    
    NSLog(@"Converted Date is: %@", convertedDate);
    
    
    LeaderBoardDB *leaderBoardDB = [LeaderBoardDB GetInstance];
    [leaderBoardDB insertNewScore];
    
    PFObject *leaderBoardData = [PFObject objectWithClassName:@"LeaderBoardData"];
    leaderBoardData[@"userName"] = playerSingleton.playerName;
//    leaderBoardData[@"userName"] = [[PFUser currentUser].username];
    leaderBoardData[@"score"] = [NSNumber numberWithInt:successfulBubbles];
    leaderBoardData[@"gameDate"] = convertedDate;
    [leaderBoardData saveInBackground];
    
    
    // Introscene button
    CCButton *youLostButton = [CCButton buttonWithTitle:@"[ You Won ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    youLostButton.positionType = CCPositionTypeNormalized;
    youLostButton.position = ccp(0.5f, 0.35f);
    [youLostButton setTarget:self selector:@selector(onYouLostClicked:)];
    [self addChild:youLostButton];
}
// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onYouLostClicked:(id)sender
{
    // Go back to the intro scene
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    [[OALSimpleAudio sharedInstance] stopAllEffects];
}


- (void)onPauseButtonClicked:(id)sender
{
    if ([[CCDirector sharedDirector] isPaused] ) {
        [[CCDirector sharedDirector] resume];
    } else {
        [[CCDirector sharedDirector] pause];
    }
}

// The zOrder of the power button is verified before the opacity of the bubble(s) are changed
- (void)onPowerButtonClicked:(id)sender
{
    if (powerButton1.zOrder == 2) {
        smallBubble.opacity = 0.50f;
        largeBubble.opacity = 0.50f;
    }
    
    
}


// -----------------------------------------------------------------------

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}




@end
