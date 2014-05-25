//
//  HelloWorldScene.m
//  GameConcept
//
//  Created by Brent Marohnic on 4/2/14.
//  Copyright Brent Marohnic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "ImmersiveScene.h"
#import "CCAnimation.h"


// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
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
    
    CCSprite *pauseButton;
    CCButton *pauseButton1;
    CCSpriteFrame *pauseButtonFrame;
    
    // Declare the physics node that will be used to detect collisions between the bubbles and the bombs
    CCPhysicsNode *physicsNode;
    
    NSMutableArray *explodeAnimArray;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommends assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Set the fontMultiplier so that fonts are sized appropriately regardless of whether they are displayed on a Retina iPhone or iPad
    CGSize whichSize = [CCDirector sharedDirector].viewSize;
    NSLog(@"%f", whichSize.width);
    
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
    pauseButton1.position = ccp(0.95f, 0.96f);
    [self addChild:pauseButton1 z:2];
    
    
    
    
    
    
//    pauseButton = [CCSprite spriteWithImageNamed:@"pauseButton.png"];
//    pauseButton.anchorPoint = CGPointMake(0,0);
//    pauseButton.position = CGPointMake(self.contentSize.width - pauseButton.contentSize.width, self.contentSize.height - pauseButton.contentSize.height);
//    [self addChild:pauseButton];
    
    
    
    
    
    
    
    
    
    
    
    
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
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint tappedSpot = [touch locationInNode:self];
    
    // Play the explosion sound if the bomb is tapped
    // Pop the selected bubble and play the appropriate bubble popping sound. The player can pop the bubbles in order to avoid having them hit the bombs and the ceiling spikes
    // The player will not receive any sort of penalty for sacrificing a bubble, they just won't receive the point for the bubble successfully reaching the top of the screen
    // The bubble is not actually removed it is simply set to invisible
    if (CGRectContainsPoint(smallBomb.boundingBox, tappedSpot)) {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        
    } else if (CGRectContainsPoint(largeBubble.boundingBox, tappedSpot)){
        // Decrement the successfulBubbles counter
//        successfulBubbles--;
        
        largeBubble.physicsBody.collisionGroup = @"enemyGroup";
        largeBubble.physicsBody.collisionType = @"";
        [largeBubble setVisible:NO];
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    } else if (CGRectContainsPoint(smallBubble.boundingBox, tappedSpot)){
        // Decrement the successfulBubbles counter
//        successfulBubbles--;
        
        smallBubble.physicsBody.collisionGroup = @"enemyGroup";
        smallBubble.physicsBody.collisionType = @"";
        [smallBubble setVisible:NO];
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    } else if (CGRectContainsPoint(pauseButton.boundingBox, tappedSpot)){
        if ([[CCDirector sharedDirector] isPaused] ) {
            [[CCDirector sharedDirector] resume];
        } else {
            [[CCDirector sharedDirector] pause];
        }
    }

    
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

// floatSmallBubble is called at regular intervals using a scheduler
-(void)floatSmallBubble:(CCTime)ccTime
{
    // Reset the collisionGroup, the collisionType and the visibility
    // This is required if the bubble was hit by a bomb or tapped by the user since these parameters are altered at the time of impact
    smallBubble.physicsBody.collisionGroup = @"bubbleGroup";
    smallBubble.physicsBody.collisionType = @"smallBubbleCollision";
    [smallBubble setVisible:YES];
    
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
    CCAction *showSmallBubble = [CCActionMoveTo actionWithDuration:4.0 position:CGPointMake(spawnX, self.contentSize.height + smallBubble.contentSize.height)];
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
    CCAction *showLargeBubble = [CCActionMoveTo actionWithDuration:4.0 position:CGPointMake(spawnX, self.contentSize.height + largeBubble.contentSize.height)];
    [largeBubble runAction:[CCActionSequence actionWithArray:@[showLargeBubble]]];

}

// This method is called whenever a smallBubble and a bomb come into contact
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair smallBubbleCollision:(CCNode *)bubble smallBombCollision:(CCNode *)bomb{
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

    
    

    
    // Call endTheGameFail if deadBubbles reaches zero
    if (deadBubbles <= 0) {
        [self endTheGameFail];
    // Otherwise play the explosion sound and set the visibility of the bomb and bubble to invisible
    } else {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        smallBomb.physicsBody.collisionType = @"";
        bubble.physicsBody.collisionGroup = @"enemyGroup";
        [bubble setVisible:NO];
        [bomb setVisible:NO];
    }
    
    return TRUE;
}

// This method is called whenever a largeBubble and a bomb come into contact
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair largeBubbleCollision:(CCNode *)bubble smallBombCollision:(CCNode *)bomb{
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
    
    
    
    // Call endTheGameFail if deadBubbles reaches zero
    if (deadBubbles <= 0) {
        [self endTheGameFail];
    // Otherwise play the explosion sound and set the visibility of the bomb and bubble to invisible
    } else {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        smallBomb.physicsBody.collisionType = @"";
        bubble.physicsBody.collisionGroup = @"enemyGroup";
        [bubble setVisible:NO];
        [bomb setVisible:NO];
    }
    
    return TRUE;
}

// bubbleHitSpike is called at regular intervals using a scheduler
-(void)bubbleHitSpike:(CCTime)delta{
    // Check to see if the smallBubble came into contact with either set of spikes
    // Make sure it wasn't already hit by a bomb or popped by the player by checking the visible property
    if ((CGRectIntersectsRect(smallBubble.boundingBox, ceilingSpikes.boundingBox) || CGRectIntersectsRect(smallBubble.boundingBox, ceilingSpikes2.boundingBox)) && smallBubble.visible == TRUE) {
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
        
        if (deadBubbles <= 0) {
            [self endTheGameFail];
        }
    
    // Check to see if the largeBubble came into contact with either set of spikes
    // Make sure it wasn't already hit by a bomb or popped by the player by checking the visible property
    } else if ((CGRectIntersectsRect(largeBubble.boundingBox, ceilingSpikes.boundingBox) || CGRectIntersectsRect(largeBubble.boundingBox, ceilingSpikes2.boundingBox)) && largeBubble.visible == TRUE) {
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
        
        if (deadBubbles <= 0) {
            [self endTheGameFail];
        }
    } else if (largeBubble.position.y > self.contentSize.height && largeBubble.visible == TRUE){
        [self removeChild:successfulLabel];
        successfulBubbles++;
        NSString *tempString = [NSString stringWithFormat:@"%d / 10", successfulBubbles];
        successfulLabel = [CCLabelTTF labelWithString:tempString fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
        successfulLabel.positionType = CCPositionTypeNormalized;
        successfulLabel.color = [CCColor greenColor];
        successfulLabel.position = ccp(0.85f, 0.95f);
        
        NSLog(@"This is being called");
        if (successfulBubbles < 10) {
            [self addChild:successfulLabel z:2];
        } else {
            [self addChild:successfulLabel z:2];
            [self endTheGameSuccess];
        }
        
        [largeBubble setVisible:NO];
        
    } else if (smallBubble.position.y > self.contentSize.height && smallBubble.visible == TRUE){
        [self removeChild:successfulLabel];
        successfulBubbles++;
        NSString *tempString = [NSString stringWithFormat:@"%d / 10", successfulBubbles];
        successfulLabel = [CCLabelTTF labelWithString:tempString fontName:@"Verdana-Bold" fontSize:12.0f * fontMultiplier];
        successfulLabel.positionType = CCPositionTypeNormalized;
        successfulLabel.color = [CCColor greenColor];
        successfulLabel.position = ccp(0.85f, 0.95f);
        
        NSLog(@"This is being called");
        if (successfulBubbles < 10) {
            [self addChild:successfulLabel z:2];
        } else {
            [self addChild:successfulLabel z:2];
            [self endTheGameSuccess];
        }
        
        [smallBubble setVisible:NO];
    }

    
}

// Called when the player allowed more than four bubbles to get popped by the bombs and spikes
-(void)endTheGameFail
{
    // Play a sorrowful tuba cadence
    [[OALSimpleAudio sharedInstance] playBuffer:tubaSadSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    
    // Remove all the sprites and unshedule all of the schedulers
    [largeBubble removeFromParent];
    [smallBomb removeFromParent];
    [smallBubble removeFromParent];
    [self unschedule:@selector(floatSmallBubble:)];
    [self unschedule:@selector(floatLargeBubble:)];
    [self unschedule:@selector(throwBomb:)];
    [self unschedule:@selector(bubbleHitSpike:)];
    
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
    
    // Remove all the sprites and unshedule all of the schedulers
    [largeBubble removeFromParent];
    [smallBomb removeFromParent];
    [smallBubble removeFromParent];
    [self unschedule:@selector(floatSmallBubble:)];
    [self unschedule:@selector(floatLargeBubble:)];
    [self unschedule:@selector(throwBomb:)];
    [self unschedule:@selector(bubbleHitSpike:)];
    
    // Introscene button
    CCButton *youWonButton = [CCButton buttonWithTitle:@"[ You Won ]" fontName:@"Verdana-Bold" fontSize:18.0f * fontMultiplier];
    youWonButton.positionType = CCPositionTypeNormalized;
    youWonButton.position = ccp(0.5f, 0.35f);
    [youWonButton setTarget:self selector:@selector(onYouWonClicked:)];
    [self addChild:youWonButton];
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


- (void)onYouWonClicked:(id)sender
{
    // Go back to the intro scene
    [[CCDirector sharedDirector] replaceScene:[ImmersiveScene scene]
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

// -----------------------------------------------------------------------

@end
