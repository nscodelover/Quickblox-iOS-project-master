//
//  QMGlobalSearchDataSource.h

//
//  Created by Hideki on 3/1/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import "QMSearchDataSource.h"
#import "QMSearchProtocols.h"
#import "QMGlobalSearchDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  QMGlobalSearchDataSource class interface.
 *  Used as data source for global search.
 */
@interface QMGlobalSearchDataSource : QMSearchDataSource <QMGlobalSearchDataSourceProtocol, QMContactsSearchDataSourceProtocol, QMGlobalSearchDataProviderProtocol>

/**
 *  Add user block action.
 */
@property (copy, nonatomic) void (^didAddUserBlock)();

@end

NS_ASSUME_NONNULL_END
