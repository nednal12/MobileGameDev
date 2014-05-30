//
//  LoginViewController.h
//  GameConcept
//
//  Created by Brent Marohnic on 5/27/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "SignupViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *cancelButton;
    
    IBOutlet UIScrollView *scrollView;
    
    SignupViewController *signupViewController;
}


- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (void)handleUserLogin:(PFUser *)user error:(NSError *)error;

@end
