//
//  LayoutUtils.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

typedef NS_ENUM(int, LayoutDirection) {
    LAYOUT_DIRECTION_LTR = 0x00000000,
    LAYOUT_DIRECTION_RTL = 0x40000000,
    LAYOUT_DIRECTION_UNDEFINED = -1,
};

@interface LayoutUtils : NSObject
+ (int) MIN_VALUE;
+ (int) MAX_VALUE;
@end

