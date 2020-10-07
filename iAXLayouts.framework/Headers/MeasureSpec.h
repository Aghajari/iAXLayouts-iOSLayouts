//
//  MeasureSpec.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainLayout.h"

@interface MeasureSpec : NSObject

+ (int) getMeasuredHeight : (UIView*) child : (LayoutParams*) lp : (int) max : (CGFloat) w : (CGFloat) h;
+ (int) getMeasuredWidth : (UIView*) child : (LayoutParams*) lp : (int) max : (CGFloat) w : (CGFloat) h;

@end

