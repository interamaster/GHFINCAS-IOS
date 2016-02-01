//
//  UITextView+Placeholder.h
//  GHFINCAS
//
//  Created by jose ramon delgado on 01/02/16.
//  Copyright (c) 2016 JRDV. All rights reserved.
//

 


#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
