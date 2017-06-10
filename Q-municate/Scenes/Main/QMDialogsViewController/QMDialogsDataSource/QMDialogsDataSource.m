//
//  QMDialogsDataSource.m

//
//  Created by Hideki on 1/13/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import "QMDialogsDataSource.h"
#import "QMDialogCell.h"
#import "QMCore.h"
#import <QMDateUtils.h>
#import "QBChatDialog+OpponentID.h"

#import <SVProgressHUD.h>

@implementation QMDialogsDataSource

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)__unused indexPath {
    
    return [QMDialogCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QMDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:[QMDialogCell cellIdentifier] forIndexPath:indexPath];
    QBChatDialog *chatDialog = self.items[indexPath.row];
    
    if (chatDialog.type == QBChatDialogTypePrivate) {
        
        QBUUser *recipient = [[QMCore instance].usersService.usersMemoryStorage userWithID:[chatDialog opponentID]];
        
        if (recipient != nil) {
            NSParameterAssert(recipient.fullName);
            
            [cell setTitle:recipient.fullName placeholderID:[chatDialog opponentID] avatarUrl:recipient.avatarUrl];
        }
        else {
            
            [cell setTitle:NSLocalizedString(@"QM_STR_UNKNOWN_USER", nil) placeholderID:[chatDialog opponentID] avatarUrl:nil];
        }
    } else {
        
        [cell setTitle:chatDialog.name placeholderID:chatDialog.ID.hash avatarUrl:chatDialog.photo];
    }
    
    // there was a time when updated at didn't exist
    // in order to support old dialogs, showing their date as last message date
    NSDate *date = chatDialog.updatedAt ?: chatDialog.lastMessageDate;
    
    NSString *time = [QMDateUtils formattedShortDateString:date];
    [cell setTime:time];
    [cell setBody:chatDialog.lastMessageText];
    [cell setBadgeNumber:chatDialog.unreadMessagesCount];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)__unused tableView canEditRowAtIndexPath:(NSIndexPath *)__unused indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        QBChatDialog *chatDialog = self.items[indexPath.row];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:[NSString stringWithFormat:NSLocalizedString(@"QM_STR_CONFIRM_DELETE_DIALOG", nil), chatDialog.name]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_CANCEL", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull __unused action) {
                                                              
                                                              [tableView setEditing:NO animated:YES];
                                                          }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_DELETE", nil)
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull __unused action) {
                                                              
                                                              BFContinuationBlock completionBlock = ^id _Nullable(BFTask * _Nonnull __unused task) {
                                                                  
                                                                  [SVProgressHUD dismiss];
                                                                  return nil;
                                                              };
                                                              
                                                              [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                                                              if (chatDialog.type == QBChatDialogTypeGroup) {
                                                                  
                                                                  chatDialog.occupantIDs = [[QMCore instance].contactManager occupantsWithoutCurrentUser:chatDialog.occupantIDs];
                                                                  [[[QMCore instance].chatManager leaveChatDialog:chatDialog] continueWithSuccessBlock:completionBlock];
                                                              }
                                                              else {
                                                                  // private and public group chats
                                                                  [[[QMCore instance].chatService deleteDialogWithID:chatDialog.ID] continueWithSuccessBlock:completionBlock];
                                                              }
                                                          }]];
        
        UIViewController *viewController = [(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController selectedViewController];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSMutableArray *)items {
    
    return [[[QMCore instance].chatService.dialogsMemoryStorage dialogsSortByLastMessageDateWithAscending:NO] mutableCopy];
}

@end
