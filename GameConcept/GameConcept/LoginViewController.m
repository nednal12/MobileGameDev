//
//  LoginViewController.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/27/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "LoginViewController.h"
#import "IntroScene.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleUserLogin:(PFUser *)user error:(NSError *)error {
    if (user) {
        // Do stuff after successful login.
        
        // Go back to the intro scene
//        [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
//                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
        [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        // Login failed. Inform the user to correct either the username, password or both.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message: @"Either the Username or Password or both are incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (IBAction)loginButtonClicked:(id)sender
{
    // Ensure that both text views are populated. If not, show alert box.
    if ([usernameTextField.text isEqual:@""] || [passwordTextField.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message: @"Please enter both a username and a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    } else {
        [PFUser logInWithUsernameInBackground:usernameTextField.text
                                     password:passwordTextField.text
                                       target:self
                                     selector:@selector(handleUserLogin:error:)];
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Both of the following solutions function exactly the same. However, the uncommented solution is shorter and does not require that any TextField instance names to be hardcoded.
    NSInteger nextTextFieldTag = textField.tag + 1;
    UIResponder *nextTextField = [textField.superview viewWithTag:nextTextFieldTag];
    
    if ([textField hasText] == NO) {
        return NO;
    } else {
        if (nextTextField) {
            [nextTextField becomeFirstResponder];
            return NO;
        } else {
            [textField resignFirstResponder];
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height / 2);
            return YES;
        }
    }
    //    switch (textField.tag) {
    //        case 0:
    //            if ([textField hasText] == NO) {
    //                return NO;
    //
    //            } else {
    //
    //                [passwordTextField becomeFirstResponder];
    //                return NO;
    //            }
    //            break;
    //
    //        default:
    //            if ([textField hasText] == NO) {
    //                return NO;
    //
    //            } else {
    //
    //                [textField resignFirstResponder];
    //                scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height / 2);
    //                return YES;
    //            }
    //            break;
    //    }
    //
    //    return NO;
}


//- (void)onLoginClicked:(id)sender
//{
//    //    userNameTextField.hidden = YES;
//    
//    // start Intro scene with transition
//    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
//                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
//}


@end
