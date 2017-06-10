//
//  QMSearchProtocols.h

//
//  Created by Hideki on 6/19/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

@class QMSearchDataSource;

@protocol QMSearchProtocol <NSObject>

@optional
- (QMSearchDataSource *)searchDataSource;

@end

@protocol QMDialogsSearchDataSourceProtocol <QMSearchProtocol>

@end

@protocol QMGlobalSearchDataSourceProtocol <QMSearchProtocol>

@end

@protocol QMContactsSearchDataSourceProtocol <QMSearchProtocol>

@optional
/**
 *  User at index path.
 *
 *  @param indexPath index path
 *
 *  @return user that is existent at a specific index path
 */
- (QBUUser *)userAtIndexPath:(NSIndexPath *)indexPath;

@end
