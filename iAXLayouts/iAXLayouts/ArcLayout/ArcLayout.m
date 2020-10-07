//
//  ArcLayout.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/3/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArcLayout.h"
#import "MeasureSpec.h"

@implementation ArcLayout {
    int layoutMaxWidth;
    int layoutMaxHeight;
}

@synthesize arc;
@synthesize arcRadius;
@synthesize axisRadius;
@synthesize isFreeAngle;
@synthesize isReverseAngle;

- (id) init {
    if (self = [super init]){
        arc = [[ArcType alloc] initWithGravity:[Gravity CENTER]];
        arcRadius = 144;
        axisRadius = -1;
        isFreeAngle = NO;
        isReverseAngle = NO;
        self.gravity = [Gravity CENTER];
        layoutMaxWidth = 0;
        layoutMaxHeight = 0;
    }
    return self;
}

- (void) updateLayout:(int)w :(int)h {
    [super updateLayout:w:h];
    
    [self layout:0 :0 :w :h];
}

- (CGSize) sizeThatFits:(CGSize)size {
    [super updateConstraints];
    return CGSizeMake(layoutMaxWidth, layoutMaxHeight);
}

- (void) layout : (int) l : (int) t : (int) r : (int) b {
    ArcPoint* o = [arc computeOrigin:0: 0: [self findX]: [self findY]];
    int radius = (axisRadius == -1) ? arcRadius / 2 : axisRadius;
    float perDegrees = [arc computePerDegrees:[self getChildCountWithoutGone]];
    
    int arcIndex = 0;
    
    for (UIView* child in self.subviews) {
        if (child==nil || child.isHidden || ![self hasChildLayoutLoaded:child]) {
            continue;
        }
        
        ArcLayoutParams* lp = (ArcLayoutParams*) [self getChildLayoutParams:child];
        float childAngle;
        if (isFreeAngle) {
            childAngle = arc.startAngle + lp.angle;
        } else if (isReverseAngle) {
            childAngle = [arc computeReverseDegrees:arcIndex++: perDegrees];
        } else {
            childAngle = [arc computeDegrees:arcIndex++: perDegrees];
        }
        
        int x = o.x + [ArcType x:radius: childAngle];
        int y = o.y + [ArcType y:radius: childAngle];
        
        [self childLayoutBy:child :x :y];
    }
}


- (void) setArcType: (ArcType*) arc {
    self.arc = arc;
    [self updateConstraints];
}

- (void) setRadius : (int) radius {
    self.arcRadius = radius;
    [self updateConstraints];
}

- (void) setArcAxisRadius : (int) radius {
    self.axisRadius = radius;
    [self updateConstraints];
}

- (void) setFreeAngle : (BOOL) b {
    isFreeAngle = b;
    [self updateConstraints];
}

- (void) setReverseAngle : (BOOL) b {
    isReverseAngle = b;
    [self updateConstraints];
}

- (float) getChildAngleAt : (int) index {
    return [self getChildAngle:self.subviews[index]];
}

- (float) getChildAngle : (UIView*) v {
    if ([self hasChildLayoutLoaded:v]){
        ArcLayoutParams* lp = (ArcLayoutParams*) [self getChildLayoutParams:v];
        return lp.angle;
    }
    return 0.0f;
}

- (int) getChildCountWithoutGone {
    int childCount = 0;
    for (UIView* child in self.subviews){
        if (child!=nil && !child.isHidden && [self hasChildLayoutLoaded:child]) {
            childCount++;
        }
    }
    return childCount;
}

- (void) childLayoutBy : (UIView*) child : (int) x : (int) y {
    ArcLayoutParams* lp = (ArcLayoutParams*) [self getChildLayoutParams:child];
    int origin = lp.gravity;
    if (origin<0){
        origin = self.gravity;
    }
    origin = [Gravity getAbsoluteGravity:origin: layoutDirection];
    
    int maxWidth = [ArcType computeWidth:origin :[self findX] :x];
    int maxHeight = [ArcType computeHeight:origin :[self findY] :y];
    
    int width = [MeasureSpec getMeasuredWidth:child :lp :maxWidth :maxWidth :maxHeight];
    int height = [MeasureSpec getMeasuredHeight:child :lp :maxHeight :maxWidth :maxHeight];
    
    int left;
    int horizontal = origin & [Gravity HORIZONTAL_GRAVITY_MASK];
    
    if (horizontal == [Gravity LEFT]){
        left = x;
    }else if (horizontal == [Gravity RIGHT]){
        left = x - width;
    }else{
        left = x - (width / 2);
    }
    
    int top;
    int vertical = origin & [Gravity VERTICAL_GRAVITY_MASK];
    if (vertical == [Gravity TOP]){
        top = y;
    }else if (vertical == [Gravity BOTTOM]){
        top = y - height;
    } else {
        top = y - (height / 2);
    }
    
    layoutMaxWidth = MAX(layoutMaxWidth,left+width);
    layoutMaxHeight = MAX(layoutMaxWidth,top+height);
    [self setChildFrame:child :left :top :width :height];
}

- (int) findX {
    return self.bounds.size.width;
}

- (int) findY {
    return self.bounds.size.height;
}

@end

@implementation ArcLayoutParams

@synthesize gravity;
@synthesize angle;

- (id) init {
    if (self = [super init]){
        self.gravity = -1;
        self.angle = 0.0f;
    }
    return self;
}

- (id) initWithSource : (LayoutParams*) lp {
    return [self initWithSize:lp.width :lp.height];
}

- (id) initWithMarginSource : (MarginLayoutParams*) lp {
    if ( self = [super initWithMarginSource:lp] ) {
        self.gravity = -1;
        self.angle = 0.0f;
    }
    return self;
}

- (id) initWithArcSource:(ArcLayoutParams *)lp {
    if ( self = [super initWithMarginSource:lp] ) {
        self.gravity = lp.gravity;
        self.angle = 0.0f;
    }
    return self;
}

- (id) initWithSize : (int) width : (int) height {
    if ( self = [super initWithSize:width :height] ){
        self.gravity = -1;
        self.angle = 0.0f;
    }
    return self;
}

- (id) initWithSizeAndGravity : (int) width : (int) height : (int) gravity {
    if ( self = [super initWithSize:width :height] ){
        self.gravity = gravity;
        self.angle = 0.0f;
    }
    return self;
}

- (id) initWithAngle : (int) width : (int) height : (int) gravity : (int) angle{
    if ( self = [super initWithSize:width :height] ){
        self.gravity = gravity;
        self.angle = angle;
    }
    return self;
}

@end
