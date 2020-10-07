//
//  ArcType.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/3/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gravity.h"
#import "ArcType.h"

@implementation ArcPoint

- (nonnull id) initWithValue : (int) x : (int) y {
    if (self = [super init]){
        self.x = x;
        self.y = y;
    }
    return self;
}

@synthesize x;
@synthesize y;

@end

@interface LeftDelegate : NSObject<ArcTypeDelegate>
@end
@implementation LeftDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:l :[ArcType centerY:t :b]];
}
- (int) computeWidth:(int)radius {
    return radius;
}
@end

@interface RightDelegate : NSObject<ArcTypeDelegate>
@end
@implementation RightDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:r :[ArcType centerY:t :b]];
}
- (int) computeWidth:(int)radius {
    return radius;
}
@end

@interface TopDelegate : NSObject<ArcTypeDelegate>
@end
@implementation TopDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:[ArcType centerX:l:r] :t];
}
- (int) computeHeight:(int)radius {
    return radius;
}
@end

@interface BottomDelegate : NSObject<ArcTypeDelegate>
@end
@implementation BottomDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:[ArcType centerX:l:r] :b];
}
- (int) computeHeight:(int)radius {
    return radius;
}
@end

@interface TopLeftDelegate : NSObject<ArcTypeDelegate>
@end
@implementation TopLeftDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:l :t];
}
- (int) computeHeight:(int)radius {
    return radius;
}
- (int) computeWidth:(int)radius {
    return radius;
}
@end

@interface TopRightDelegate : NSObject<ArcTypeDelegate>
@end
@implementation TopRightDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:r :t];
}
- (int) computeHeight:(int)radius {
    return radius;
}
- (int) computeWidth:(int)radius {
    return radius;
}
@end

@interface BottomLeftDelegate : NSObject<ArcTypeDelegate>
@end
@implementation BottomLeftDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:l :b];
}
- (int) computeHeight:(int)radius {
    return radius;
}
- (int) computeWidth:(int)radius {
    return radius;
}
@end

@interface BottomRightDelegate : NSObject<ArcTypeDelegate>
@end
@implementation BottomRightDelegate
- (ArcPoint*) computeOrigin:(int)l :(int)t :(int)r :(int)b {
    return [[ArcPoint alloc] initWithValue:r :b];
}
- (int) computeHeight:(int)radius {
    return radius;
}
- (int) computeWidth:(int)radius {
    return radius;
}
@end

@implementation ArcType

@synthesize startAngle;
@synthesize sweepAngle;
@synthesize delegate;

- (id) initWithGravity : (int) gravity {
    int startAngle = 0;
    int sweepAngle = 0;
    id delegate = nil;
    
    if (gravity==[Gravity CENTER]) {
        startAngle = 270;
        sweepAngle = 360;
    }else{
        int verticalGravity = gravity & [Gravity VERTICAL_GRAVITY_MASK];
        int horizonticalGravity = gravity & [Gravity HORIZONTAL_GRAVITY_MASK];
        
        if (horizonticalGravity == [Gravity LEFT]) {
            if (verticalGravity == [Gravity TOP]) {
                startAngle = 0;
                sweepAngle = 90;
                delegate = [[TopLeftDelegate alloc] init];
            }else if (verticalGravity == [Gravity BOTTOM]){
                startAngle = 270;
                sweepAngle = 90;
                delegate = [[BottomLeftDelegate alloc] init];
            }else {
                startAngle = 270;
                sweepAngle = 180;
                delegate = [[LeftDelegate alloc] init];
            }
        } else if (horizonticalGravity == [Gravity RIGHT]) {
            if (verticalGravity == [Gravity TOP]) {
                startAngle = 90;
                sweepAngle = 90;
                delegate = [[TopRightDelegate alloc] init];
            }else if (verticalGravity == [Gravity BOTTOM]){
                startAngle = 180;
                sweepAngle = 90;
                delegate = [[BottomRightDelegate alloc] init];
            }else {
                startAngle = 90;
                sweepAngle = 180;
                delegate = [[RightDelegate alloc] init];
            }
        } else {
            if (verticalGravity == [Gravity TOP]) {
                startAngle = 0;
                sweepAngle = 180;
                delegate = [[TopDelegate alloc] init];
            }else if (verticalGravity == [Gravity BOTTOM]){
                startAngle = 180;
                sweepAngle = 180;
                delegate = [[BottomDelegate alloc] init];
            }else {
                startAngle = 270;
                sweepAngle = 360;
            }
        }
    }
    
    if ( self = [self initWithValue:startAngle :sweepAngle] ) {
        self.delegate = delegate;
    }
    return self;
}

- (id _Nonnull ) initWithValue : (int) startAngle : (int) sweepAngle {
    if ( self = [super init] ) {
        self.delegate = nil;
        self.startAngle = startAngle;
        self.sweepAngle = sweepAngle;
    }
    return self;
}

+ (float) computeCircleX : (float) r : (float) degrees {
    return (float) (r * cos(degrees * M_PI /180.0));
}

+ (float) computeCircleY : (float) r : (float) degrees {
    return (float) (r * sin(degrees * M_PI /180.0));
}

+ (int) computeWidth : (int) origin : (int) size : (int) x {
    int gravity = origin & [Gravity HORIZONTAL_GRAVITY_MASK];
    if (gravity == [Gravity LEFT]) {
        //To the right edge
        return size - x;
    }else if (gravity == [Gravity RIGHT]){
        //To the left edge
        return x;
    }else{
        //To the shorter * 2 than the right edge and left edge
        return MIN(x, size - x) * 2;
    }
}

+ (int) computeHeight : (int) origin : (int) size : (int) y {
    int gravity = origin & [Gravity VERTICAL_GRAVITY_MASK];
    if (gravity == [Gravity TOP]) {
        //To the bottom edge
        return size - y;
    }else if (gravity == [Gravity BOTTOM]){
        //To the top edge
        return y;
    }else{
        //To the shorter * 2 than the top edge and bottom edge
        return MIN(y, size - y) * 2;
    }
}

+ (int) x : (int) radius : (float) degrees {
    return round([ArcType computeCircleX:radius: degrees]);
}

+ (int) y : (int) radius : (float) degrees {
    return round([ArcType computeCircleY:radius: degrees]);
}

+ (int) centerX : (int) left : (int) right {
    return (left + right) / 2;
}

+ (int) centerY : (int) top : (int) bottom {
    return (top + bottom) / 2;
}

+ (int) diameter : (int) radius {
    return radius * 2;
}

+ (ArcType*) of : (int) origin {
    int gravity = origin & [Gravity VERTICAL_GRAVITY_MASK];
    if (gravity == [Gravity TOP]) {
        return [ArcType ofTop:origin];
    }else if (gravity == [Gravity BOTTOM]){
        return [ArcType ofBottom:origin];
    }else{
        return [ArcType ofCenter:origin];
    }
}

+ (ArcType*) ofTop : (int) origin {
    int gravity = origin & [Gravity HORIZONTAL_GRAVITY_MASK];
    if (gravity == [Gravity LEFT]) {
        return [[ArcType alloc] initWithGravity:[Gravity TOP]|[Gravity LEFT]];
    }else if (gravity == [Gravity RIGHT]){
        return [[ArcType alloc] initWithGravity:[Gravity TOP]|[Gravity RIGHT]];
    }else{
        return [[ArcType alloc] initWithGravity:[Gravity TOP]];
    }
}

+  (ArcType*) ofCenter : (int) origin {
    int gravity = origin & [Gravity HORIZONTAL_GRAVITY_MASK];
    if (gravity == [Gravity LEFT]) {
        return [[ArcType alloc] initWithGravity:[Gravity LEFT]];
    }else if (gravity == [Gravity RIGHT]){
        return [[ArcType alloc] initWithGravity:[Gravity RIGHT]];
    }else{
        return [[ArcType alloc] initWithGravity:[Gravity CENTER]];
    }
}

+ (ArcType*) ofBottom : (int) origin {
    int gravity = origin & [Gravity HORIZONTAL_GRAVITY_MASK];
    if (gravity == [Gravity LEFT]) {
        return [[ArcType alloc] initWithGravity:[Gravity BOTTOM]|[Gravity LEFT]];
    }else if (gravity == [Gravity RIGHT]){
      return [[ArcType alloc] initWithGravity:[Gravity BOTTOM]|[Gravity RIGHT]];
    }else{
      return [[ArcType alloc] initWithGravity:[Gravity BOTTOM]];
    }
}

- (float) computeDegrees : (int) index : (float) perDegrees {
    float offsetAngle = (sweepAngle < 360) ? startAngle - (perDegrees / 2.0f) : startAngle;
    return offsetAngle + perDegrees + (perDegrees * index);
}

- (float) computeReverseDegrees : (int) index : (float) perDegrees {
    float offsetAngle = (sweepAngle < 360) ? startAngle + (perDegrees / 2.0f) : startAngle;
    float shiftDegrees = (sweepAngle / 360) * perDegrees;
    return offsetAngle + sweepAngle - (perDegrees + perDegrees * index) + shiftDegrees;
}

- (float) computePerDegrees : (int) size {
    return ((float) sweepAngle) / size;
}

- (ArcPoint*) computeOrigin : (int) l : (int) t : (int) r : (int) b {
    if (delegate!=nil && [delegate respondsToSelector:@selector(computeOrigin::::)]){
        ArcPoint* res = [delegate computeOrigin:l:t:r:b];
        if (res!=nil) return res;
    }
    return [[ArcPoint alloc] initWithValue:[ArcType centerX:l :r] :[ArcType centerY:t :b]];
}

- (int) computeWidth :(int) radius {
    if (delegate!=nil && [delegate respondsToSelector:@selector(computeWidth:)]){
        return [delegate computeWidth:radius];
    }
    return [ArcType diameter:radius];
}

- (int) computeHeight :(int) radius {
    if (delegate!=nil && [delegate respondsToSelector:@selector(computeHeight:)]){
        return [delegate computeHeight:radius];
    }
    return [ArcType diameter:radius];
}

@end

