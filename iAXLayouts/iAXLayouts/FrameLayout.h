//
//  FrameLayout.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/2/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainLayout.h"


@interface FrameLayout : MainLayout

- (id _Nonnull ) initWithGravity : (int) gravity;

@end

@interface FrameLayoutParams : MarginLayoutParams {
    int gravity;
}

- (id _Nonnull) initWithSource : (LayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithMarginSource : (MarginLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSize : (int) width : (int) height;
- (id _Nonnull) initWithFrameSource : (FrameLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSizeAndGravity : (int) width : (int) height : (int) gravity;

@property (nonatomic) int gravity;

@end



