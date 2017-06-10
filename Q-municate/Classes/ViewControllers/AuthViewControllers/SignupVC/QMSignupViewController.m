//
//  QMSignupViewController.m
//  WWWChat
//
//  Created by AkiraYoshida on 7/5/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMSignupViewController.h"
#import "UINavigationController+QMNotification.h"
#import "QMCore.h"
#import "QMTasks.h"
#import <Quickblox/Quickblox.h>
#import <SVProgressHUD.h>

@interface QMSignupViewController()


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (weak, nonatomic) BFTask *task;


@end

@implementation QMSignupViewController

NSString *confirmPassword;


- (void)dealloc {
    
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // subscribing for delegate
    self.nameField.delegate  = self;
    self.emailField.delegate = self;
    self.phoneNumberField.delegate = self;
    self.passwordField.delegate = self;
    self.confirmPasswordField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


# pragma mark - Action
- (IBAction)userInfo_save:(id)__unused sender {
    
    
    [self.view endEditing:YES];
    
    if (self.nameField.text.length == 0 || self.emailField.text.length == 0 || self.phoneNumberField.text.length == 0 || self.passwordField.text.length == 0 || self.confirmPasswordField.text.length == 0) {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_FILL_IN_ALL_THE_FIELDS", nil) duration:kQMDefaultNotificationDismissTime];
        
        UIAlertController * alert= [UIAlertController
                                    alertControllerWithTitle:@"Title"
                                    message:@"Please input user infomation."
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes, please"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                       NSLog(@"type = %@", action);
                                     
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No, thanks"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel no, thanks button
                                       NSLog(@"type = %@", action);

                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    else {
        
        //[SVProgressHUD showWithStatus:@"Signing up"];
        QBUUser *user = [QBUUser new];
        user.fullName = self.nameField.text;
        user.email = self.emailField.text;
        user.phone = self.phoneNumberField.text;
        user.password = self.passwordField.text;
        confirmPassword = self.confirmPasswordField.text;
        
        if (user.password != confirmPassword) {
            
            NSLog(@"password=%@",user.password);
            NSLog(@"confirmPassword=%@",confirmPassword);
            
            
            UIAlertController * alert= [UIAlertController
                                        alertControllerWithTitle:@"Alert"
                                        message:@"Password is different!"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes, please"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            //Handel your yes please button action here
                                            NSLog(@"type = %@", action);
                                            
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No, thanks"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel no, thanks button
                                           NSLog(@"type = %@", action);
                                           
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else {
            
            
          //  [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_SIGNING_UP", nil) duration:0];
            
            [QBRequest signUp:user successBlock:^(QBResponse *response1, QBUUser *user1) {
                
                NSLog(@"Errors=%@, %@", [response1.error description], user1.email);
                
                   [self.navigationController popViewControllerAnimated:YES];
                
                //[self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_SIGNING_UP", nil) duration:0];
                
                
                
//                __weak UINavigationController *navigationController = self.navigationController;
//                
//                @weakify(self);
//                
//                self.task = [[[QMCore instance].authService loginWithUser:user] continueWithBlock:^id _Nullable(BFTask<QBUUser *> * _Nonnull task) {
//                    
//                    @strongify(self);
//                    [navigationController dismissNotificationPanel];
//                    
//                    if (!task.isFaulted) {
//                        
//                        [self performSegueWithIdentifier:kQMSceneSegueMain sender:nil];
//                        [QMCore instance].currentProfile.accountType = QMAccountTypeEmail;
//                        [[QMCore instance].currentProfile synchronizeWithUserData:task.result];
//                        
//                        return [[QMCore instance].pushNotificationManager subscribeForPushNotifications];
//                    }
//                    
//                    return nil;
//                }];
                
            } errorBlock:^(QBResponse *response1) {
                NSLog(@"Errors=%@", [response1.error description]);
            }];

        }
        
    }
}
@end
