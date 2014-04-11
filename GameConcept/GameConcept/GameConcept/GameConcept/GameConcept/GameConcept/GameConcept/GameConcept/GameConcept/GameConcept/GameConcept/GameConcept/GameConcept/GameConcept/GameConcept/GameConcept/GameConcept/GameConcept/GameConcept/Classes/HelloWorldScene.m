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

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    int deadBubbles;
    int successfulBubbles;
    CCSprite *bubbleBackgroundImage;
    CCSprite *largeBubble;
    CCSprite *smallBubble;
    CCSprite *smallBomb;
    ALBuffer *bubblePopSound;
    ALBuffer *explosionSound;
    
    CCPhysicsNode *physicsNode;
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
    
    NSString *physicsNodeTag = [NSString stringWithFormat:@"physicsNodeTag"];
    
    // Preload sounds
    bubblePopSound = [[OALSimpleAudio sharedInstance] preloadEffect:@"bubblePop.wav"];
    explosionSound = [[OALSimpleAudio sharedInstance] preloadEffect:@"explosion3.mp3"];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Set the background image
    bubbleBackgroundImage = [CCSprite spriteWithImageNamed:@"bubbleBackground.png"];
    bubbleBackgroundImage.anchorPoint = CGPointMake(0, 0);
    bubbleBackgroundImage.opacity = 0.90;
    [self addChild:bubbleBackgroundImage];
    
    // Create a physics node. This node will be responsible for controlling the collisions between the bubbles and the bombs
    physicsNode = [CCPhysicsNode node];
    physicsNode.gravity = ccp(0,0);
    physicsNode.debugDraw = NO;
    physicsNode.collisionDelegate = self;
    [self addChild:physicsNode z:1 name:physicsNodeTag];
    
    // Initialize the largeBubble sprite
    largeBubble = [CCSprite spriteWithImageNamed:@"largeBubble.png"];
    [physicsNode addChild:largeBubble];
    
    // Define the largeBubble bounding box and add it to the bubbleGroup collisionGroup
    largeBubble.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:largeBubble.contentSize.width/2.0f andCenter:largeBubble.anchorPointInPoints];
    largeBubble.physicsBody.collisionGroup = @"bubbleGroup";
    largeBubble.physicsBody.collisionType = @"largeBubbleCollision";
    
    // Initialize the smallBubble sprite
    smallBubble = [CCSprite spriteWithImageNamed:@"smallBubble.png"];
    [physicsNode addChild:smallBubble];
    
    // Define the smallBubble bounding box and add it to the bubbleGroup collisionGroup
    smallBubble.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:smallBubble.contentSize.width/2.0f andCenter:smallBubble.anchorPointInPoints];
    smallBubble.physicsBody.collisionGroup = @"bubbleGroup";
    smallBubble.physicsBody.collisionType = @"smallBubbleCollision";
    
    // Initialize the smallBomb sprite
    smallBomb = [CCSprite spriteWithImageNamed:@"smallBomb.png"];
    [physicsNode addChild:smallBomb];
    
    // Define the smallBomb bounding box and add it to the bombGroup collisionGroup
    smallBomb.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:smallBomb.contentSize.width/2.0f andCenter:smallBomb.anchorPointInPoints];
    smallBomb.physicsBody.collisionGroup = @"bombGroup";
    smallBomb.physicsBody.collisionType = @"smallBombCollision";
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
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
    [self schedule:@selector(floatSmallBubble:) interval:3.5];
    [self schedule:@selector(floatLargeBubble:) interval:4.0];
    
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
    // Play the bubble popping sound if either the large or small bubble is tapped
    if (CGRectContainsPoint(smallBomb.boundingBox, tappedSpot)) {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        
    } else if (CGRectContainsPoint(largeBubble.boundingBox, tappedSpot)){
        // Decrement the successfulBubbles counter
        successfulBubbles--;
        
        largeBubble.physicsBody.collisionGroup = @"";
        largeBubble.physicsBody.collisionType = @"";
        [largeBubble setVisible:NO];
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    } else if (CGRectContainsPoint(smallBubble.boundingBox, tappedSpot)){
        // Decrement the successfulBubbles counter
        successfulBubbles--;
        
        smallBubble.physicsBody.collisionGroup = @"";
        smallBubble.physicsBody.collisionType = @"";
        [smallBubble setVisible:NO];
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
    }

    
}

// -----------------------------------------------------------------------


-(void)throwBomb:(CCTime)ccTime
{
    // Reset the collisionGroup, the collisionType and the visibility
    // This is required if the bomb has already hit one bubble since these parameters are altered at the time of impact
    smallBomb.physicsBody.collisionGroup = @"bombGroup";
    smallBomb.physicsBody.collisionType = @"smallBombCollision";
    [smallBomb setVisible:YES];
    
    int minYAxis = smallBomb.contentSize.height / 2;
    int maxYAxis = self.contentSize.height - smallBomb.contentSize.height / 2;
    int spanY = maxYAxis - minYAxis;
    int spawnY = (arc4random() % spanY) + minYAxis;
    
    smallBomb.position = CGPointMake(self.contentSize.width + smallBomb.contentSize.width / 2, spawnY);
    
    CCAction *showSmallBomb = [CCActionMoveTo actionWithDuration:3.0 position:CGPointMake(-smallBomb.contentSize.width, spawnY)];
    [smallBomb runAction:[CCActionSequence actionWithArray:@[showSmallBomb]]];
}

-(void)floatSmallBubble:(CCTime)ccTime
{
    if (successfulBubbles > 10) {
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:YES];

        [largeBubble removeFromParent];
        [smallBomb removeFromParent];
        [smallBubble removeFromParent];
        [self unschedule:@selector(floatSmallBubble:)];
        [self unschedule:@selector(floatLargeBubble:)];
        [self unschedule:@selector(throwBomb:)];

        // Introscene button
        CCButton *youLostButton = [CCButton buttonWithTitle:@"[ You Won ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        youLostButton.positionType = CCPositionTypeNormalized;
        youLostButton.position = ccp(0.5f, 0.35f);
        [youLostButton setTarget:self selector:@selector(onYouLostClicked:)];
        [self addChild:youLostButton];
    } else {
        // Reset the collisionGroup, the collisionType and the visibility
        // This is required if the bubble was hit by a bomb or tapped by the user since these parameters are altered at the time of impact
        smallBubble.physicsBody.collisionGroup = @"bubbleGroup";
        smallBubble.physicsBody.collisionType = @"smallBubbleCollision";
        [smallBubble setVisible:YES];
        
        int minXAxis = smallBubble.contentSize.width / 2;
        int maxXAxis = self.contentSize.width - smallBubble.contentSize.width / 2;
        int spanX = maxXAxis - minXAxis;
        int spawnX = (arc4random() % spanX) + minXAxis;
        
        smallBubble.position = CGPointMake(spawnX, -self.contentSize.height + smallBubble.contentSize.height / 2);
        
        CCAction *showSmallBubble = [CCActionMoveTo actionWithDuration:3.0 position:CGPointMake(spawnX, self.contentSize.height + smallBubble.contentSize.height)];
        [smallBubble runAction:[CCActionSequence actionWithArray:@[showSmallBubble]]];
        
        // Increment the successfulBubble counter
        successfulBubbles++;
    }
}

-(void)floatLargeBubble:(CCTime)ccTime
{
    if (successfulBubbles > 10) {
        [[OALSimpleAudio sharedInstance] playBuffer:bubblePopSound volume:1.0 pitch:1.0 pan:0.0 loop:YES];

        [largeBubble removeFromParent];
        [smallBomb removeFromParent];
        [smallBubble removeFromParent];
        [self unschedule:@selector(floatSmallBubble:)];
        [self unschedule:@selector(floatLargeBubble:)];
        [self unschedule:@selector(throwBomb:)];
        
        // Introscene button
        CCButton *youLostButton = [CCButton buttonWithTitle:@"[ You Won ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        youLostButton.positionType = CCPositionTypeNormalized;
        youLostButton.position = ccp(0.5f, 0.35f);
        [youLostButton setTarget:self selector:@selector(onYouLostClicked:)];
        [self addChild:youLostButton];
    } else {
    
        largeBubble.physicsBody.collisionGroup = @"bubbleGroup";
        largeBubble.physicsBody.collisionType = @"largeBubbleCollision";
        [largeBubble setVisible:YES];
        
        int minXAxis = largeBubble.contentSize.width / 2;
        int maxXAxis = self.contentSize.width - largeBubble.contentSize.width / 2;
        int spanX = maxXAxis - minXAxis;
        int spawnX = (arc4random() % spanX) + minXAxis;
        
        largeBubble.position = CGPointMake(spawnX, -self.contentSize.height + largeBubble.contentSize.height / 2);
        
        CCAction *showLargeBubble = [CCActionMoveTo actionWithDuration:3.0 position:CGPointMake(spawnX, self.contentSize.height + largeBubble.contentSize.height)];
        [largeBubble runAction:[CCActionSequence actionWithArray:@[showLargeBubble]]];
        
        // Increment the successfulBubble counter
        successfulBubbles++;
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair smallBubbleCollision:(CCNode *)bubble smallBombCollision:(CCNode *)bomb{
    // Increment the deadBubbles counter and decrement the successfulBubbles counter
    deadBubbles++;
    successfulBubbles--;
    
    if (deadBubbles > 2) {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:YES];

        [largeBubble removeFromParent];
        [smallBomb removeFromParent];
        [smallBubble removeFromParent];
        [self unschedule:@selector(floatSmallBubble:)];
        [self unschedule:@selector(floatLargeBubble:)];
        [self unschedule:@selector(throwBomb:)];
        
        // Introscene button
        CCButton *youLostButton = [CCButton buttonWithTitle:@"[ You Lost ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        youLostButton.positionType = CCPositionTypeNormalized;
        youLostButton.position = ccp(0.5f, 0.35f);
        [youLostButton setTarget:self selector:@selector(onYouLostClicked:)];
        [self addChild:youLostButton];
        
    } else {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        smallBomb.physicsBody.collisionType = @"";
        smallBomb.physicsBody.collisionGroup = @"bubbleGroup";
        [bubble setVisible:NO];
        [bomb setVisible:NO];
    }
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair largeBubbleCollision:(CCNode *)bubble smallBombCollision:(CCNode *)bomb{
    // Increment the deadBubbles counter and decrement the successfulBubbles counter
    deadBubbles++;
    successfulBubbles--;
    
    if (deadBubbles > 2) {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:YES];
        [largeBubble removeFromParent];
        [smallBomb removeFromParent];
        [smallBubble removeFromParent];
        [self unschedule:@selector(floatSmallBubble:)];
        [self unschedule:@selector(floatLargeBubble:)];
        [self unschedule:@selector(throwBomb:)];
        
        // Introscene button
        CCButton *youLostButton = [CCButton buttonWithTitle:@"[ You Lost ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        youLostButton.positionType = CCPositionTypeNormalized;
        youLostButton.position = ccp(0.5f, 0.35f);
        [youLostButton setTarget:self selector:@selector(onYouLostClicked:)];
        [self addChild:youLostButton];
        
    } else {
        [[OALSimpleAudio sharedInstance] playBuffer:explosionSound volume:1.0 pitch:1.0 pan:0.0 loop:NO];
        smallBomb.physicsBody.collisionType = @"";
        smallBomb.physicsBody.collisionGroup = @"bubbleGroup";
        [bubble setVisible:NO];
        [bomb setVisible:NO];
    }
    return TRUE;
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

// -----------------------------------------------------------------------

@end
