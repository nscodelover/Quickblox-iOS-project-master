//
//  QMNewMessageViewController.m

//
//  Created by Hideki on 3/15/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import "QMNewMessageViewController.h"
#import "QMContactsDataSource.h"
#import "QMContactsSearchDataSource.h"
#import "QMCore.h"
#import "UINavigationController+QMNotification.h"
#import "QMChatVC.h"
#import "QMContactsSearchDataProvider.h"

#import "QMContactCell.h"
#import "QMNoContactsCell.h"
#import "QMNoResultsCell.h"

@interface QMNewMessageViewController ()

<
QMSearchProtocol,
QMSearchDataProviderDelegate,

UISearchControllerDelegate,
UISearchResultsUpdating
>

@property (strong, nonatomic) UISearchController *searchController;

/**
 *  Data sources
 */
@property (strong, nonatomic) QMContactsDataSource *dataSource;
@property (strong, nonatomic) QMContactsSearchDataSource *contactsSearchDataSource;

@property (weak, nonatomic) BFTask *dialogCreationTask;

@end

@implementation QMNewMessageViewController

- (void)dealloc {
    
    [self.searchController.view removeFromSuperview];
    
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerNibs];
    
    // Hide empty separators
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // search implementation
    [self configureSearch];
    
    // setting up data source
    [self configureDataSources];
    
    // filling data source
    [self updateItemsFromContactList];
    
    // Back button style for next in navigation stack view controllers
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:NSLocalizedString(@"QM_STR_BACK", nil)
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
}

- (void)configureSearch {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.placeholder = NSLocalizedString(@"QM_STR_SEARCH_BAR_PLACEHOLDER", nil);
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit]; // iOS8 searchbar sizing
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)configureDataSources {
    
    self.dataSource = [[QMContactsDataSource alloc] initWithKeyPath:@keypath(QBUUser.new, fullName)];
    self.tableView.dataSource = self.dataSource;
    
    QMContactsSearchDataProvider *searchDataProvider = [[QMContactsSearchDataProvider alloc] init];
    searchDataProvider.delegate = self;
    
    self.contactsSearchDataSource = [[QMContactsSearchDataSource alloc] initWithSearchDataProvider:searchDataProvider usingKeyPath:@keypath(QBUUser.new, fullName)];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)__unused tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.searchDataSource heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dialogCreationTask) {
        // dialog creating in progress
        return;
    }
    
    QBUUser *user = [(id <QMContactsSearchDataSourceProtocol>)self.searchDataSource userAtIndexPath:indexPath];
    
    QBChatDialog *privateDialog = [[QMCore instance].chatService.dialogsMemoryStorage privateChatDialogWithOpponentID:user.ID];
    
    if (privateDialog != nil) {
        
        [self performSegueWithIdentifier:kQMSceneSegueChat sender:privateDialog];
    }
    else {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_LOADING", nil) duration:0];
        
        __weak UINavigationController *navigationController = self.navigationController;
        
        @weakify(self);
        self.dialogCreationTask = [[[QMCore instance].chatService createPrivateChatDialogWithOpponent:user] continueWithBlock:^id _Nullable(BFTask<QBChatDialog *> * _Nonnull task) {
            
            @strongify(self);
            [navigationController dismissNotificationPanel];
            
            if (!task.isFaulted) {
                
                [self performSegueWithIdentifier:kQMSceneSegueChat sender:task.result];
            }
            
            return nil;
        }];
    }
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)__unused searchController {
    
    self.tableView.dataSource = self.contactsSearchDataSource;
    [self.tableView reloadData];
}

- (void)willDismissSearchController:(UISearchController *)__unused searchController {
    
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [self.searchDataSource.searchDataProvider performSearch:searchController.searchBar.text];
}

#pragma mark - Helpers

- (void)updateItemsFromContactList {
    
    NSArray *friends = [[QMCore instance].contactManager friends];
    [self.dataSource replaceItems:friends];
    
    self.navigationItem.rightBarButtonItem.enabled = friends.count > 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kQMSceneSegueChat]) {
        
        QMChatVC *chatViewController = segue.destinationViewController;
        chatViewController.chatDialog = sender;
    }
}

#pragma mark - QMSearchDataProviderDelegate

- (void)searchDataProviderDidFinishDataFetching:(QMSearchDataProvider *)__unused searchDataProvider {
    
    if ([self.tableView.dataSource conformsToProtocol:@protocol(QMContactsSearchDataSourceProtocol)]) {
        
        [self.tableView reloadData];
    }
}

- (void)searchDataProvider:(QMSearchDataProvider *)__unused searchDataProvider didUpdateData:(NSArray *)__unused data {
    
    if (![self.tableView.dataSource conformsToProtocol:@protocol(QMContactsSearchDataSourceProtocol)]) {
        
        [self updateItemsFromContactList];
    }
    
    [self.tableView reloadData];
}

#pragma mark - QMSearchProtocol

- (QMSearchDataSource *)searchDataSource {
    
    return (id)self.tableView.dataSource;
}

#pragma mark - Nib registration

- (void)registerNibs {
    
    [QMContactCell registerForReuseInTableView:self.tableView];
    [QMNoResultsCell registerForReuseInTableView:self.tableView];
    [QMNoContactsCell registerForReuseInTableView:self.tableView];
}

@end
