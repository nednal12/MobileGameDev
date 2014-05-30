//
//  SignupViewController.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/27/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <Parse/Parse.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *confirmPasswordTextField;
    
    IBOutlet UIButton *signupButton;
    IBOutlet UIButton *cancelButton;
    
    IBOutlet UIScrollView *scrollView;
}

- (IBAction)signupButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (void)signupMethod;

@end
