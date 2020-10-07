//
//  LinearLayout.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainLayout.h"

typedef NS_ENUM(int, OrientationMode) {
    ORIENTATION_HORIZONTAL=0,
    ORIENTATION_VERTICAL=1
};

@interface LinearLayout : MainLayout

- (id _Nonnull ) initWithOrientation : (OrientationMode) orientation;
- (id _Nonnull) initWithGravity : (OrientationMode) orientation : (int) gravity;

/**
 * Should the layout be a column or a row.
 */
- (void) setOrientation : (OrientationMode) orientation;
/**
 * Returns the current orientation.
 */
- (OrientationMode) getOrientation;

/**
 * Describes how the child views are positioned. Defaults to GRAVITY TOP. If
 * this layout has a VERTICAL orientation, this controls where all the child
 * views are placed if there is extra vertical space. If this layout has a
 * HORIZONTAL orientation, this controls the alignment of the children.
 */
- (void) setLayoutGravity : (int) gravity;
- (void) setHorizontalGravity : (int) horizontalGravity;
- (void) setVerticalGravity : (int) verticalGravity;

@end

@interface LinearLayoutParams : MarginLayoutParams {
    int gravity;
}

- (id _Nonnull) initWithSource : (LayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithMarginSource : (MarginLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSize : (int) width : (int) height;
- (id _Nonnull) initWithLinearSource : (LinearLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSizeAndGravity : (int) width : (int) height : (int) gravity;
    
@property (nonatomic) int gravity;

@end


