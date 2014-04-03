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
//    CCSprite *_sprite;
    CCSprite *bubbleBackgroundImage;
    CCSprite *largeBubble;
    CCSprite *smallBubble;
    CCSprite *smallBomb;
    id<ALSoundSource> explosionSound;
    
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
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Set the background image
    bubbleBackgroundImage = [CCSprite spriteWithImageNamed:@"bubbleBackground.png"];
    bubbleBackgroundImage.anchorPoint = CGPointMake(0, 0);
    bubbleBackgroundImage.opacity = 0.90;
    [self addChild:bubbleBackgroundImage];
    
    // Create a physics node. This will probably be used later once collisions between sprites become necessary
    physicsNode = [CCPhysicsNode node];
    physicsNode.gravity = ccp(0,0);
    physicsNode.debugDraw = NO;
    physicsNode.collisionDelegate = self;
    [self addChild:physicsNode];
    
    // Initialize the largeBubble sprite and set its position on the screen.
    largeBubble = [CCSprite spriteWithImageNamed:@"largeBubble.png"];
    largeBubble.position = ccp(self.contentSize.width/2, self.contentSize.height/4);
    
    // Add the largeBubble sprite to the physics node.
    largeBubble.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:largeBubble.contentSize.width/2.0f andCenter:largeBubble.anchorPointInPoints];
    [physicsNode addChild:largeBubble];
    
    // Initialize the smallBubble sprite and set its position on the screen.
    smallBubble = [CCSprite spriteWithImageNamed:@"smallBubble.png"];
    smallBubble.position = ccp(self.contentSize.width/1.5, self.contentSize.height/1.5);
    
    // Add the smallBubble sprite to the physics node.
    smallBubble.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:smallBubble.contentSize.width/2.0f andCenter:smallBubble.anchorPointInPoints];
    [physicsNode addChild:smallBubble];
    
    // Initialize the smallBomb sprite and set its position on the screen.
    smallBomb = [CCSprite spriteWithImageNamed:@"smallBomb.png"];
    smallBomb.position = ccp(self.contentSize.width/6, self.contentSize.height/1.5);
    
    // Add the smallBomb sprite to the physics node.
    smallBomb.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:smallBomb.contentSize.width/2.0f andCenter:smallBomb.anchorPointInPoints];
    [physicsNode addChild:smallBomb];
    
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
    
    if (tappedSpot.x <= smallBomb.position.x + (smallBomb.contentSize.height / 2.5f) && tappedSpot.x >= smallBomb.position.x - (smallBomb.contentSize.height / 2.5f) && tappedSpot.y <= smallBomb.position.y + (smallBomb.contentSize.width / 2.5f) && tappedSpot.y >= smallBomb.position.y - (smallBomb.contentSize.width / 2.5f)) {
        explosionSound = [[OALSimpleAudio sharedInstance] playEffect:@"explosion3.mp3"];
    } else {
        if (tappedSpot.x <= largeBubble.position.x + (largeBubble.contentSize.height / 2.5f) && tappedSpot.x >= largeBubble.position.x - (largeBubble.contentSize.height / 2.5f) && tappedSpot.y <= largeBubble.position.y + (largeBubble.contentSize.width / 2.5f) && tappedSpot.y >= largeBubble.position.y - (largeBubble.contentSize.width / 2.5f)) {
            explosionSound = [[OALSimpleAudio sharedInstance] playEffect:@"bubblePop.wav"];
        } else {
            if (tappedSpot.x <= smallBubble.position.x + (smallBubble.contentSize.height / 2.5f) && tappedSpot.x >= smallBubble.position.x - (smallBubble.contentSize.height / 2.5f) && tappedSpot.y <= smallBubble.position.y + (smallBubble.contentSize.width / 2.5f) && tappedSpot.y >= smallBubble.position.y - (smallBubble.contentSize.width / 2.5f)) {
                explosionSound = [[OALSimpleAudio sharedInstance] playEffect:@"bubblePop.wav"];
            }
        }
    }
    
}

// -----------------------------------------------------------------------
@end
