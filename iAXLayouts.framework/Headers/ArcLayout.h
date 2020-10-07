//
//  ArcLayout.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/3/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainLayout.h"
#import "ArcType.h"


@interface ArcLayout : MainLayout {
    ArcType* arc;
    int arcRadius;
    int axisRadius;
    BOOL isFreeAngle;
    BOOL isReverseAngle;
}

@property (nonatomic) ArcType* _Nonnull arc;
@property (nonatomic) int arcRadius;
@property (nonatomic) int axisRadius;
@property (nonatomic) BOOL isFreeAngle;
@property (nonatomic) BOOL isReverseAngle;

- (void) setArcType: (ArcType* _Nonnull) arc;
- (void) setRadius : (int) radius;
- (void) setArcAxisRadius : (int) radius;
- (void) setFreeAngle : (BOOL) enabled;
- (void) setReverseAngle : (BOOL) enabled;
- (float) getChildAngleAt : (int) index;
- (float) getChildAngle : (UIView* _Nonnull) child;

@end

@interface ArcLayoutParams : MarginLayoutParams {
    int gravity;
    float angle;
}

- (id _Nonnull) initWithSource : (LayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithMarginSource : (MarginLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSize : (int) width : (int) height;
- (id _Nonnull) initWithArcSource : (ArcLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSizeAndGravity : (int) width : (int) height : (int) gravity;
- (id _Nonnull) initWithAngle : (int) width : (int) height : (int) gravity : (int) angle;

@property (nonatomic) int gravity;
@property (nonatomic) float angle;

@end


