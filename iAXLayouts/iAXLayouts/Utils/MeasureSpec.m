//
//  MeasureSpec.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasureSpec.h"
#import "MainLayout.h"

@implementation MeasureSpec

+ (int) getMeasuredHeight : (UIView*) child : (LayoutParams*) lp : (int) max : (CGFloat) w : (CGFloat) h {
    int value;
    if (lp.height == WRAP_CONTENT){
        CGSize size = [child sizeThatFits:CGSizeMake(w,h)];
        value = size.height;
    }else if (lp.height == MATCH_PARENT){
        value = max;
    }else{
        value = lp.height;
    }
    
    value += lp.extraHeight;
    
    if ([lp isKindOfClass:[MeasureableLayoutParams class]]){
        MeasureableLayoutParams* m = (MeasureableLayoutParams*) lp;
        if (m.delegate!=nil && [m.delegate respondsToSelector:@selector(GetMeasuredHeight:)]){
            MeasureValue* mv = [MeasureValue new];
            mv.maxSize = CGSizeMake(w,h);
            mv.maxValue = max;
            mv.lp = lp;
            mv.child = child;
            mv.measuredValue = value;
            return [m.delegate GetMeasuredHeight:mv];
        }
    }
    return value;
}

+ (int) getMeasuredWidth : (UIView*) child : (LayoutParams*) lp : (int) max : (CGFloat) w : (CGFloat) h{
    int value;
    if (lp.width == WRAP_CONTENT){
        CGSize size = [child sizeThatFits:CGSizeMake(w,h)];
        value = (int) size.width;
    }else if (lp.width == MATCH_PARENT){
        value = max;
    }else{
        value = lp.width;
    }
    
    value += lp.extraWidth;
    
    if ([lp isKindOfClass:[MeasureableLayoutParams class]]){
        MeasureableLayoutParams* m = (MeasureableLayoutParams*) lp;
        if (m.delegate!=nil && [m.delegate respondsToSelector:@selector(GetMeasuredWidth:)]){
            MeasureValue* mv = [MeasureValue new];
            mv.maxSize = CGSizeMake(w, h);
            mv.maxValue = max;
            mv.lp = lp;
            mv.child = child;
            mv.measuredValue = value;
            return [m.delegate GetMeasuredWidth:mv];
        }
    }
    return value;
}

@end

