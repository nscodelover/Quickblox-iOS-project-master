//
//  QMOnlineTitleView.m

//
//  Created by Hideki on 3/14/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import "QMOnlineTitleView.h"

@interface QMOnlineTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *status;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelTrailingConstraint;

@end

@implementation QMOnlineTitleView

- (void)setTitle:(NSString *)title {
    
    if (![_title isEqualToString:title]) {
        
        _title = [title copy];
        self.titleLabel.text = title;
        
        [self sizeToFit];
    }
}

- (void)setStatus:(NSString *)status {
    
    if (![_status isEqualToString:status]) {
        
        _status = [status copy];
        self.statusLabel.text = status;
        
        [self sizeToFit];
    }
}

#pragma mark - Overrides

- (void)sizeToFit {
    
    [self.titleLabel sizeToFit];
    [self.statusLabel sizeToFit];
    
    [super sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGFloat width = 0.0;
    for (UIView *view in self.subviews) {
        
        if (view.frame.size.width > width) {
            
            width = view.frame.size.width;
            
            if (view == self.titleLabel) {
                
                width += self.titleLabelLeadingConstraint.constant + self.titleLabelTrailingConstraint.constant;
            }
            else if (view == self.statusLabel) {
                
                width += self.statusLabelLeadingConstraint.constant + self.statusLabelTrailingConstraint.constant;
            }
        }
    }
    
    size.width = width;
    return size;
}

@end
