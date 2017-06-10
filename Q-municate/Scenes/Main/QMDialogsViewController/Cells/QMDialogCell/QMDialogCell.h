//
//  QMDialogCell.h

//
//  Created by Hideki on 1/13/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMTableViewCell.h"

@interface QMDialogCell : QMTableViewCell

- (void)setTime:(NSString *)time;
- (void)setBadgeNumber:(NSUInteger)badgeNumber;

@end
