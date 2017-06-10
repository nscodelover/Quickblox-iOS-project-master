//
//  QMLicenseAgreementViewController.m
//  Qmunicate
//
//  Created by Igor Alefirenko on 10/07/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMLicenseAgreementViewController.h"
#import <SVProgressHUD.h>
#import "QMCore.h"

@interface QMLicenseAgreementViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QMLicenseAgreementViewController

- (void)dealloc {
    
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL licenceAccepted = [QMCore instance].currentProfile.userAgreementAccepted;
    if (licenceAccepted) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD dismiss];
    [QMCore instance].currentProfile.userAgreementAccepted = YES;
    [self dismissViewControllerSuccess:YES];

}

- (void)dismissViewControllerSuccess:(BOOL)success {
    
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        
        @strongify(self);
        if (self.licenceCompletionBlock) {
            
            self.licenceCompletionBlock(success);
            self.licenceCompletionBlock = nil;
        }
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)__unused webView {
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)__unused webView didFailLoadWithError:(NSError *)error {
    
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

@end
