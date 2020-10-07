//
//  Gravity.h
//  Layouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//
#import "LayoutUtils.h"

@interface Gravity : NSObject

/** Constant indicating that no gravity has been set **/
+ (int) NO_GRAVITY;

/** Raw bit indicating the gravity for an axis has been specified. */
+ (int) AXIS_SPECIFIED;

/** Raw bit controlling how the left/top edge is placed. */
+ (int) AXIS_PULL_BEFORE;

/** Raw bit controlling how the right/bottom edge is placed. */
+ (int) AXIS_PULL_AFTER;

/** Raw bit controlling whether the right/bottom edge is clipped to its
 * container, based on the gravity direction being applied. */
+ (int) AXIS_CLIP;

/** Bits defining the horizontal axis. */
+ (int) AXIS_X_SHIFT;

/** Bits defining the vertical axis. */
+ (int) AXIS_Y_SHIFT;

/** Push object to the top of its container, not changing its size. */
+ (int) TOP;

/** Push object to the bottom of its container, not changing its size. */
+ (int) BOTTOM;

/** Push object to the left of its container, not changing its size. */
+ (int) LEFT;

/** Push object to the right of its container, not changing its size. */
+ (int) RIGHT;

/** Place object in the vertical center of its container, not changing its
 *  size. */
+ (int) CENTER_VERTICAL;

/** Grow the vertical size of the object if needed so it completely fills
 *  its container. */
+ (int) FILL_VERTICAL;

/** Place object in the horizontal center of its container, not changing its
 *  size. */
+ (int) CENTER_HORIZONTAL;

/** Grow the horizontal size of the object if needed so it completely fills
 *  its container. */
+ (int) FILL_HORIZONTAL;

/** Place the object in the center of its container in both the vertical
 *  and horizontal axis, not changing its size. */
+ (int) CENTER;

/** Grow the horizontal and vertical size of the object if needed so it
 *  completely fills its container. */
+ (int) FILL;

/** Flag to clip the edges of the object to its container along the
 *  vertical axis. */
+ (int) CLIP_VERTICAL;

/** Flag to clip the edges of the object to its container along the
 *  horizontal axis. */
+ (int) CLIP_HORIZONTAL;

/** Raw bit controlling whether the layout direction is relative or not (START/END instead of
 * absolute LEFT/RIGHT).
 */
+ (int) RELATIVE_LAYOUT_DIRECTION;

/**
 * Binary mask to get the absolute horizontal gravity of a gravity.
 */
+ (int) HORIZONTAL_GRAVITY_MASK;

/**
 * Binary mask to get the vertical gravity of a gravity.
 */
+ (int) VERTICAL_GRAVITY_MASK;

/** Push object to x-axis position at the start of its container, not changing its size. */
+ (int) START;

/** Push object to x-axis position at the end of its container, not changing its size. */
+ (int) END;

/**
 * Binary mask for the horizontal gravity and script specific direction bit.
 */
+ (int) RELATIVE_HORIZONTAL_GRAVITY_MASK;

/**
 * Convert script specific gravity to absolute horizontal value.
 *
 * if horizontal direction is LTR, then START will set LEFT and END will set RIGHT.
 * if horizontal direction is RTL, then START will set RIGHT and END will set LEFT.
 */
+ (int) getAbsoluteGravity : (int) gravity : (LayoutDirection) layoutDirection;

@end
