//
//  QMAlert.m

//
//  Created by Hideki on 5/20/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import "QMAlert.h"

@implementation QMAlert

+ (void)showAlertWithMessage:(NSString *)message actionSuccess:(BOOL)success inViewController:(UIViewController *)viewController {
    
    NSString *title = success ? NSLocalizedString(@"QM_STR_SUCCESS", nil) : NSLocalizedString(@"QM_STR_ERROR", nil);
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull __unused action) {
        
    }]];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
