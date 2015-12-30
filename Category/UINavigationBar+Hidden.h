//
//  UINavigationBar+Hidden.h
//  GoodCooker
//
//  Created by liuyichen on 15/11/11.
//  Copyright (c) 2015年 Wang Yalei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Hidden)

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

@end
