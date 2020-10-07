//
//  LinearLayout.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinearLayout.h"
#import "Gravity.h"
#import "LayoutUtils.h"
#import "MeasureSpec.h"

@implementation LinearLayout {
    OrientationMode mOrientation;
    int mTotalLength;
}

-(id) init {
    if (self = [super init]){
        self->mOrientation = ORIENTATION_HORIZONTAL;
        self->mTotalLength = 0;
    }
    return self;
}

- (id) initWithOrientation : (OrientationMode) orientation {
    if ( self = [super init] ) {
        self->mOrientation = orientation;
    }
    return self;
}

- (id) initWithGravity : (OrientationMode) orientation : (int) gravity {
    if ( self = [self initWithOrientation:orientation] ) {
        [self setLayoutGravity:gravity];
    }
    return self;
}

- (void) updateLayout:(int)w :(int)h {
    [super updateLayout:w:h];

    if (mOrientation == ORIENTATION_VERTICAL) {
        [self layoutVertical:0:0:w:h];
    } else {
        [self layoutHorizontal:0:0:w:h];
    }
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize s = CGSizeMake(size.width, size.height);
    if (s.width == CGFLOAT_MAX) s.width = self.bounds.size.width;
    if (s.height == CGFLOAT_MAX) s.height = self.bounds.size.height;
    
    if (mOrientation == ORIENTATION_VERTICAL){
        [self measureVertical:size.width :s.height];
        return CGSizeMake(size.width,mTotalLength);
    }else{
        [self measureHorizontal:size.width :s.height];
        return CGSizeMake(mTotalLength,size.height);
    }
}

- (void) measureVertical : (CGFloat) w : (CGFloat) h {
    int totalLength = 0;
    for (UIView *child in self.subviews) {
        if (child == nil) {
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            MarginLayoutParams* lp = (MarginLayoutParams*) [self getChildLayoutParams:child];
            if (lp.height==-1){
                totalLength = h;
                mTotalLength = totalLength;
                break;
            }
            int childHeight = [MeasureSpec getMeasuredHeight:child :lp : h : w : CGFLOAT_MAX];
            totalLength = MAX(totalLength, totalLength + childHeight + lp.topMargin + lp.bottomMargin);
        }
    }
    mTotalLength = totalLength;
}

/**
 * Position the children during a layout pass if the orientation of this
 * LinearLayout is set to VERTICAL.
 */
- (void) layoutVertical: (int) left : (int) top : (int) right : (int) bottom {
    int paddingLeft = self.paddingLeft;
    int childTop;
    int childLeft;
    // Where right end of child should go
    int width = right - left;
    int childRight = width - self.paddingRight;
    // Space available for child
    int childSpace = width - paddingLeft - self.paddingRight;
    int majorGravity = self.gravity & [Gravity VERTICAL_GRAVITY_MASK ];
    int minorGravity = self.gravity & [Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    
    if (majorGravity == [Gravity BOTTOM]){
            [self measureVertical : self.bounds.size.width : self.bounds.size.height];
            childTop = self.paddingTop + bottom - top - mTotalLength;
    } else if (majorGravity == [Gravity CENTER_VERTICAL]) {
            [self measureVertical : self.bounds.size.width : self.bounds.size.height];
            childTop = self.paddingTop + (bottom - top - mTotalLength) / 2;
    } else {
            childTop = self.paddingTop;
    }
    
    for (UIView *child in self.subviews) {
        if (child == nil) {
            //childTop += measureNullChild;
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LinearLayoutParams* lp = (LinearLayoutParams*) [self getChildLayoutParams:child];
            childTop += lp.topMargin;
            int childWidth = [MeasureSpec getMeasuredWidth:child :lp : self.bounds.size.width - lp.leftMargin - lp.rightMargin : self.bounds.size.width : [self MAX_HEIGHT:child]];
            int childHeight = [MeasureSpec getMeasuredHeight:child :lp : self.bounds.size.height - childTop - lp.bottomMargin : self.bounds.size.width : [self MAX_HEIGHT:child]];
            int gravity = lp.gravity;
            if (gravity < 0) {
                gravity = minorGravity;
            }
            LayoutDirection layoutDirection = self.layoutDirection;
            int absoluteGravity = [Gravity getAbsoluteGravity:gravity:layoutDirection];
            int state = absoluteGravity & [Gravity HORIZONTAL_GRAVITY_MASK];
            if ( state == [Gravity CENTER_HORIZONTAL]) {
                    childLeft = paddingLeft + ((childSpace - childWidth) / 2)
                    + lp.leftMargin - lp.rightMargin;
            }else if (state == [Gravity RIGHT]) {
                    childLeft = childRight - childWidth - lp.rightMargin;
            } else{
                    childLeft = paddingLeft + lp.leftMargin;
            }
            [self setChildFrame:child: childLeft: childTop: childWidth: childHeight];
            childTop += childHeight + lp.bottomMargin;
            
            if ([child isKindOfClass:[MainLayout class]]) {
                MainLayout* newLayout = (MainLayout*) child;
                [newLayout updateConstraints];
            }
        }
    }
}

- (void) measureHorizontal  : (CGFloat) w : (CGFloat) h{
    int totalLength = 0;
    for (UIView *child in self.subviews) {
        if (child == nil) {
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            MarginLayoutParams* lp = (MarginLayoutParams*) [self getChildLayoutParams:child];
            if (lp.width==-1){
                totalLength = w;
                mTotalLength = totalLength;
                break;
            }
            int childWidth = [MeasureSpec getMeasuredWidth:child :lp : w : CGFLOAT_MAX : h];
            totalLength = MAX(totalLength, totalLength + childWidth + lp.rightMargin + lp.leftMargin);
        }
    }
    mTotalLength = totalLength;
}

/**
 * Position the children during a layout pass if the orientation of this
 * LinearLayout is set to HORIZONTAL.
 */
- (void) layoutHorizontal : (int) left : (int) top : (int) right : (int) bottom {
    BOOL isLayoutRtl = false;
    int paddingTop = self.paddingTop;
    int childTop;
    int childLeft;
    // Where bottom of child should go
    int height = bottom - top;
    int childBottom = height - self.paddingBottom;
    // Space available for child
    int childSpace = height - paddingTop - self.paddingBottom;
    int majorGravity = self.gravity & [Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    int minorGravity = self.gravity & [Gravity VERTICAL_GRAVITY_MASK];
    
    LayoutDirection layoutDirection = self.layoutDirection;
    int realGravity = [Gravity getAbsoluteGravity:majorGravity:layoutDirection];
    if (realGravity== [Gravity RIGHT]){
        [self measureHorizontal : self.bounds.size.width : self.bounds.size.height];
        childLeft = self.paddingLeft + right - left - mTotalLength;
    }else if (realGravity == [Gravity CENTER_HORIZONTAL]){
        [self measureHorizontal : self.bounds.size.width : self.bounds.size.height];
        childLeft = self.paddingLeft + (right - left - mTotalLength) / 2;
    }else{
        childLeft = self.paddingLeft;
    }
    int count = (int) self.subviews.count;
    int start = 0;
    int dir = 1;
    //In case of RTL, start drawing from the last child.
    if (isLayoutRtl) {
        start = count - 1;
        dir = -1;
    }
    for (int i = 0; i < count; i++) {
        int childIndex = start + dir * i;
        UIView* child = self.subviews[childIndex];
        if (child == nil) {
            //childLeft += measureNullChild;
        } else if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            LinearLayoutParams* lp = (LinearLayoutParams*) [self getChildLayoutParams:child];
            int gravity = lp.gravity;
            if (gravity < 0) {
                gravity = minorGravity;
            }
            
            childLeft += lp.leftMargin;
            int childWidth = [MeasureSpec getMeasuredWidth:child :lp : self.bounds.size.width - childLeft - lp.rightMargin : [self MAX_WIDTH:child] : self.bounds.size.height];
            int childHeight = [MeasureSpec getMeasuredHeight:child :lp : self.bounds.size.height - lp.topMargin - lp.bottomMargin : [self MAX_WIDTH:child] : self.bounds.size.height];
            
            int state = gravity & [Gravity VERTICAL_GRAVITY_MASK];
            if (state == [Gravity TOP]){
                    childTop = paddingTop + lp.topMargin;
            }else if (state == [Gravity CENTER_VERTICAL]) {
                    childTop = paddingTop + ((childSpace - childHeight) / 2)
                    + lp.topMargin - lp.bottomMargin;
            }else if (state == [Gravity BOTTOM]) {
                    childTop = childBottom - childHeight - lp.bottomMargin;
            }else{
                    childTop = paddingTop;
            }
            
            [self setChildFrame : child : childLeft : childTop : childWidth : childHeight];
            childLeft += childWidth + lp.rightMargin;
            
            if ([child isKindOfClass:[MainLayout class]]) {
                MainLayout* newLayout = (MainLayout*) child;
                [newLayout updateConstraints];
            }
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

- (void) setOrientation : (OrientationMode) orientation {
    if (mOrientation != orientation) {
        mOrientation = orientation;
        [self updateConstraints];
    }
}

- (OrientationMode) getOrientation {
    return mOrientation;
}

- (void) setLayoutGravity : (int) gravity {
    if (self.gravity != gravity) {
        if ((gravity & [Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) == 0) {
            gravity |= [Gravity START];
        }
        if ((gravity & [Gravity VERTICAL_GRAVITY_MASK]) == 0) {
            gravity |= [Gravity TOP];
        }
        self.gravity = gravity;
        [self updateConstraints];
    }
}

- (void) setHorizontalGravity : (int) horizontalGravity {
    int gravity = horizontalGravity & [Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    if ((self.gravity & [Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) != gravity) {
        self.gravity = (self.gravity & ~[Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) | gravity;
        [self updateConstraints];
    }
}

- (void) setVerticalGravity : (int) verticalGravity {
    int gravity = verticalGravity & [Gravity VERTICAL_GRAVITY_MASK];
    if ((self.gravity & [Gravity VERTICAL_GRAVITY_MASK]) != gravity) {
        self.gravity = (self.gravity & ~[Gravity VERTICAL_GRAVITY_MASK ]) | gravity;
        [self updateConstraints];
    }
}
@end

@implementation LinearLayoutParams

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

- (id) initWithLinearSource:(LinearLayoutParams *)lp {
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

