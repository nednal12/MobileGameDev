//
//  HelloWorldScene.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/7/14.
//  Copyright Brent Marohnic 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface ImmersiveScene : CCScene <CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate>

// -----------------------------------------------------------------------

+ (ImmersiveScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end