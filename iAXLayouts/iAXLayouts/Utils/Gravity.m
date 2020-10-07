//
//  Gravity.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gravity.h"

@implementation Gravity

+ (int) NO_GRAVITY {
    return 0x0000;
}

+ (int) AXIS_SPECIFIED {
    return 0x0001;
}

+ (int) AXIS_PULL_BEFORE {
    return 0x0002;
}

+ (int) AXIS_PULL_AFTER {
    return 0x0004;
}

+ (int) AXIS_CLIP {
    return 0x0008;
}

+ (int) AXIS_X_SHIFT {
    return 0;
}

+ (int) AXIS_Y_SHIFT {
    return 4;
}

+ (int) TOP {
    return ([Gravity AXIS_PULL_BEFORE ]|[Gravity AXIS_SPECIFIED])<<[Gravity AXIS_Y_SHIFT];
}

+ (int) BOTTOM {
    return ([Gravity AXIS_PULL_AFTER]|[Gravity AXIS_SPECIFIED])<<[Gravity AXIS_Y_SHIFT];
}

+ (int) LEFT {
    return ([Gravity AXIS_PULL_BEFORE]|[Gravity AXIS_SPECIFIED])<<[Gravity AXIS_X_SHIFT];
}

+ (int) RIGHT {
    return ([Gravity AXIS_PULL_AFTER]|[Gravity AXIS_SPECIFIED])<<[Gravity AXIS_X_SHIFT];
}

+ (int) CENTER_VERTICAL {
    return [Gravity AXIS_SPECIFIED]<<[Gravity AXIS_Y_SHIFT];
}

+ (int) FILL_VERTICAL {
    return [Gravity TOP] | [Gravity BOTTOM];
}

+ (int) CENTER_HORIZONTAL {
    return [Gravity AXIS_SPECIFIED]<<[Gravity AXIS_X_SHIFT];
}

+ (int) FILL_HORIZONTAL {
    return [Gravity LEFT] | [Gravity RIGHT];
}

+ (int) CENTER {
    return [Gravity CENTER_VERTICAL]|[Gravity CENTER_HORIZONTAL];
}

+ (int) FILL {
    return [Gravity FILL_VERTICAL] | [Gravity FILL_HORIZONTAL];
}

+ (int) CLIP_VERTICAL {
    return [Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT];
}

+ (int) CLIP_HORIZONTAL {
    return [Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT];
}

+ (int) RELATIVE_LAYOUT_DIRECTION {
    return 0x00800000;
}

+ (int) HORIZONTAL_GRAVITY_MASK {
    return ([Gravity AXIS_SPECIFIED] | [Gravity AXIS_PULL_BEFORE] | [Gravity AXIS_PULL_AFTER]) << [Gravity AXIS_X_SHIFT];
}

+ (int) VERTICAL_GRAVITY_MASK {
    return ([Gravity AXIS_SPECIFIED] | [Gravity AXIS_PULL_BEFORE] | [Gravity AXIS_PULL_AFTER]) << [Gravity AXIS_Y_SHIFT];
}

+ (int) START {
    return [Gravity RELATIVE_LAYOUT_DIRECTION] | [Gravity LEFT];
}

+ (int) END {
    return [Gravity RELATIVE_LAYOUT_DIRECTION] | [Gravity RIGHT];
}

+ (int) RELATIVE_HORIZONTAL_GRAVITY_MASK {
    return [Gravity START] | [Gravity END];
}

+ (int) getAbsoluteGravity : (int) gravity : (LayoutDirection) layoutDirection {
    if (layoutDirection == LAYOUT_DIRECTION_UNDEFINED) return gravity;
    int result = gravity;
    // If layout is script specific and gravity is horizontal relative (START or END)
    if ((result & [Gravity RELATIVE_LAYOUT_DIRECTION]) > 0) {
        if ((result & [Gravity START]) == [Gravity START]) {
            // Remove the START bit
            result &= ~[Gravity START];
            if (layoutDirection == LAYOUT_DIRECTION_RTL) {
                // Set the RIGHT bit
                result |= [Gravity RIGHT];
            } else {
                // Set the LEFT bit
                result |= [Gravity LEFT];
            }
        } else if ((result & [Gravity END]) == [Gravity END]) {
            // Remove the END bit
            result &= ~[Gravity END];
            if (layoutDirection == LAYOUT_DIRECTION_RTL) {
                // Set the LEFT bit
                result |= [Gravity LEFT];
            } else {
                // Set the RIGHT bit
                result |= [Gravity RIGHT];
            }
        }
        // Don't need the script specific bit any more, so remove it as we are converting to
        // absolute values (LEFT or RIGHT)
        result &= ~[Gravity RELATIVE_LAYOUT_DIRECTION];
    }
    return result;
}

@end

