//
//  QMPhoto.h

//
//  Created by Hideki on 5/19/16.
//  Copyright © 2016 Hideki_Ingrid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhoto.h>

@interface QMPhoto : NSObject <NYTPhoto>

@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, readwrite) NSData *imageData;
@property (nonatomic, readwrite) UIImage *placeholderImage;
@property (nonatomic, readwrite) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, readwrite) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, readwrite) NSAttributedString *attributedCaptionCredit;

@end
