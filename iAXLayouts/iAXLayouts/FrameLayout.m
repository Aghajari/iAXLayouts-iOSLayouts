//
//  FrameLayout.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/2/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FrameLayout.h"
#import "MeasureSpec.h"

@implementation FrameLayout

- (id) initWithGravity : (int) gravity {
    if ( self = [super init] ) {
        self.gravity = gravity;
    }
    return self;
}

- (void) updateLayout:(int)w :(int)h {
    [super updateLayout:w:h];
    
    [self layoutChildren:0 :0 :w :h :NO];
}


- (CGSize) sizeThatFits:(CGSize)size {
    CGSize s = CGSizeMake(size.width, size.height);
    if (s.width == CGFLOAT_MAX) s.width = self.bounds.size.width;
    if (s.height == CGFLOAT_MAX) s.height = self.bounds.size.height;
    
    int parentLeft = paddingLeft;
    int parentRight = s.width - paddingRight;
    int parentTop = paddingTop;
    int parentBottom = s.height - paddingBottom;
    BOOL forceLeftGravity = NO;
    
    int maxRight = 0 ,maxBottom = 0;
    
    for (UIView* child in self.subviews){
        if (child!=nil && !child.isHidden && [self hasChildLayoutLoaded:child]) {
            FrameLayoutParams* lp = (FrameLayoutParams*) [self getChildLayoutParams:child];
        
            int width = [MeasureSpec getMeasuredWidth:child :lp :self.bounds.size.width-lp.leftMargin-lp.rightMargin :[self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
            int height = [MeasureSpec getMeasuredHeight:child :lp :self.bounds.size.height-lp.topMargin-lp.bottomMargin :[self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
            int childLeft;
            int childTop;
            int gravity = lp.gravity;
            if (gravity == -1) {
                gravity = self.gravity;
            }
            LayoutDirection layoutDirection = self.layoutDirection;
            int absoluteGravity = [Gravity getAbsoluteGravity:gravity:layoutDirection];
            int verticalGravity = gravity & Gravity.VERTICAL_GRAVITY_MASK;
            int horizonticalGravity = absoluteGravity & Gravity.HORIZONTAL_GRAVITY_MASK;
            if (horizonticalGravity== [Gravity CENTER_HORIZONTAL]){
                childLeft = parentLeft + (parentRight - parentLeft - width) / 2 +
                lp.leftMargin - lp.rightMargin;
            } else if (horizonticalGravity == [Gravity RIGHT]){
                if (!forceLeftGravity) {
                    childLeft = parentRight - width - lp.rightMargin;
                }else{
                    childLeft = parentLeft + lp.leftMargin;
                }
            } else {
                childLeft = parentLeft + lp.leftMargin;
            }
            
            if (verticalGravity == [Gravity CENTER_VERTICAL]){
                childTop = parentTop + (parentBottom - parentTop - height) / 2 +
                lp.topMargin - lp.bottomMargin;
            } else if (verticalGravity == [Gravity BOTTOM]){
                childTop = parentBottom - height - lp.bottomMargin;
            }   else {
                childTop = parentTop + lp.topMargin;
            }
        
            maxRight = MAX(maxRight, childLeft + width);
            maxBottom = MAX(maxBottom, childTop + height);
        }
    }
        
    return CGSizeMake(maxRight, maxBottom);
}

- (void) layoutChildren : (int) left : (int) top : (int) right : (int) bottom : (BOOL) forceLeftGravity {
    int parentLeft = paddingLeft;
    int parentRight = right - left - paddingRight;
    int parentTop = paddingTop;
    int parentBottom = bottom - top - paddingBottom;
    
    for (UIView* child in self.subviews){
        if (child!=nil && !child.isHidden && [self hasChildLayoutLoaded:child]) {
            FrameLayoutParams* lp = (FrameLayoutParams*) [self getChildLayoutParams:child];
            
            int width = [MeasureSpec getMeasuredWidth:child :lp :self.bounds.size.width-lp.leftMargin-lp.rightMargin :[self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
            int height = [MeasureSpec getMeasuredHeight:child :lp :self.bounds.size.height-lp.topMargin-lp.bottomMargin :[self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
            int childLeft;
            int childTop;
            int gravity = lp.gravity;
            if (gravity == -1) {
                gravity = self.gravity;
            }
            LayoutDirection layoutDirection = self.layoutDirection;
            int absoluteGravity = [Gravity getAbsoluteGravity:gravity:layoutDirection];
            int verticalGravity = gravity & Gravity.VERTICAL_GRAVITY_MASK;
            int horizonticalGravity = absoluteGravity & Gravity.HORIZONTAL_GRAVITY_MASK;
            if (horizonticalGravity== [Gravity CENTER_HORIZONTAL]){
                childLeft = parentLeft + (parentRight - parentLeft - width) / 2 +
                lp.leftMargin - lp.rightMargin;
            } else if (horizonticalGravity == [Gravity RIGHT]){
                if (!forceLeftGravity) {
                    childLeft = parentRight - width - lp.rightMargin;
                }else{
                    childLeft = parentLeft + lp.leftMargin;
                }
            } else {
                childLeft = parentLeft + lp.leftMargin;
            }
            
            if (verticalGravity == [Gravity CENTER_VERTICAL]){
                childTop = parentTop + (parentBottom - parentTop - height) / 2 +
                lp.topMargin - lp.bottomMargin;
            } else if (verticalGravity == [Gravity BOTTOM]){
                childTop = parentBottom - height - lp.bottomMargin;
            }   else {
                childTop = parentTop + lp.topMargin;
            }
            [self setChildFrame:child :childLeft :childTop :width :height];
        }
    }
}

- (CGFloat) MAX_WIDTH : (UIView*) child {
    if ([child isKindOfClass:[MainLayout class]]) {
        return self.bounds.size.width;
    }else{
        return CGFLOAT_MAX;
    }
}

- (CGFloat) MAX_HEIGHT : (UIView*) child {
    if ([child isKindOfClass:[MainLayout class]]) {
        return self.bounds.size.height;
    }else{
        return CGFLOAT_MAX;
    }
}

@end

@implementation FrameLayoutParams

@synthesize gravity;

- (id) init {
    if (self = [super init]){
        self.gravity = -1;
    }
    return self;
}

- (id) initWithSource : (LayoutParams*) lp {
    return [self initWithSize:lp.width :lp.height];
}

- (id) initWithMarginSource : (MarginLayoutParams*) lp {
    if ( self = [super initWithMarginSource:lp] ) {
        self.gravity = -1;
    }
    return self;
}

- (id) initWithFrameSource:(FrameLayoutParams *)lp {
    if ( self = [super initWithMarginSource:lp] ) {
        self.gravity = lp.gravity;
    }
    return self;
}

- (id) initWithSize : (int) width : (int) height {
    if ( self = [super initWithSize:width :height] ){
        self.gravity = -1;
    }
    return self;
}

- (id) initWithSizeAndGravity : (int) width : (int) height : (int) gravity {
    if ( self = [super initWithSize:width :height] ){
        self.gravity = gravity;
    }
    return self;
}

@end

