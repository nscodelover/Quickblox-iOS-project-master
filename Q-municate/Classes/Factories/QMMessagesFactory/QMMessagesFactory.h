//
//  QMMessagesFactory.h

//
//  Created by Hideki on 4/18/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMessagesFactory : NSObject

/**
 *  Contact request notification message instance.
 *
 *  @param user       user to create notification message for
 *
 *  @return QBChatMessage notification instance
 */
+ (QBChatMessage *)contactRequestNotificationForUser:(QBUUser *)user;

/**
 *  Remove contact notification message instance.
 *
 *  @param user       user to create notification message for
 *
 *  @return QBChatMessage notification instance
 */
+ (QBChatMessage *)removeContactNotificationForUser:(QBUUser *)user;

@end

NS_ASSUME_NONNULL_END
