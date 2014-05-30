//
//  SignupViewController.m
//  GameConcept
//
//  Created by Brent Marohnic on 5/27/14.
//  Copyright (c) 2014 Brent Marohnic. All rights reserved.
//

#import "SignupViewController.h"
#import "IntroScene.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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


- (IBAction)signupButtonClicked:(id)sender
{
    UIAlertView *alertView;
    if ([usernameTextField hasText] == NO || [passwordTextField hasText] == NO) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message: @"Please enter a username, and a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    } else if (![passwordTextField.text isEqual:confirmPasswordTextField.text]) {
        
        alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message: @"Passwords do not match. Please re-enter both." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    } else {
        
        [self signupMethod];
        
    }
    
}

- (void) signupMethod {
    PFUser *user = [PFUser user];
    user.username = usernameTextField.text;
    user.password = passwordTextField.text;
    user[@"negAchievement"] = @NO;
    user[@"comAchievement"] = @NO;
    user[@"meaAchievement"] = @NO;
    user[@"incAchievement"] = @0;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations" message: @"Signup completed successfully." delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message: @"The username is already in use. Please select another." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            NSLog(@"Value of errorString: %@", errorString);
            
            [alertView show];
        }
    }];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    [self dismissViewControllerAnimated:NO completion:nil];
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
    // Determine which TextField was being edited when the Enter key was pressed and take appropriate action.
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
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    
}

@end
