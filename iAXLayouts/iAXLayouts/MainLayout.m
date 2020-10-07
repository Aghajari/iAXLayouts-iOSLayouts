//
//  MainLayout.m
//  Layouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainLayout.h"

@implementation MainLayout{
    NSMapTable<UIView*,LayoutParams*> *lpValues;
}

@synthesize paddingLeft;
@synthesize paddingTop;
@synthesize paddingRight;
@synthesize paddingBottom;
@synthesize gravity;
@synthesize layoutDirection;
@synthesize skipLayout;

- (id)init {
    if ( self = [super init] ) {
        lpValues = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
        self.layoutDirection = LAYOUT_DIRECTION_UNDEFINED;
        self.gravity = [Gravity START] | [Gravity TOP];
        self.clipsToBounds = YES;
        self.skipLayout = NO;
    }
    return self;
}

- (void) setPadding : (int) left : (int) top : (int) right : (int) bottom {
    self.paddingLeft = left;
    self.paddingTop = top;
    self.paddingRight = right;
    self.paddingBottom = bottom;
}

- (void) setChildFrame: (UIView*) child : (int) left : (int) top : (int) width : (int) height {
    child.frame = CGRectMake(left, top, width, height);
}

- (LayoutParams*) getChildLayoutParams : (nonnull UIView*) view {
    return [lpValues objectForKey:view];
}

- (BOOL) hasChildLayoutLoaded : (UIView*) view {
    return [lpValues objectForKey:view]!=nil;
}

- (void) setChildLayoutParams : (nonnull UIView*) view : (LayoutParams*) lp {
    [lpValues setObject:lp forKey:view];
    [self updateConstraints];
}

- (void) didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    [self updateConstraints];
}

- (void) willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    [self updateConstraints];
}

- (void) updateConstraints {
    [super updateConstraints];
    if (!self.skipLayout) {
        [self updateLayout: self.frame.size.width :self.frame.size.height];
    }
}

- (void) updateLayout:(int)w :(int)h {
    // UPDATE LAYOUT
}

- (void) addSubview:(nonnull UIView *)view : (nullable LayoutParams*) lp {
    [super addSubview:view];
    [self setChildLayoutParams:view :lp];
}

- (void) insertSubview:(nonnull UIView *)view  atIndex: (NSInteger) index : (nullable LayoutParams*) lp {
    [super insertSubview:view atIndex:index];
    [self setChildLayoutParams:view :lp];
}

- (void) insertSubview:(nonnull UIView *)view  aboveSubview: (UIView*) subview : (nullable LayoutParams*) lp {
    [super insertSubview:view aboveSubview:subview];
    [self setChildLayoutParams:view :lp];
}

- (void) insertSubview:(nonnull UIView *)view  belowSubview: (UIView*) subview : (nullable LayoutParams*) lp {
    [super insertSubview:view belowSubview:subview];
    [self setChildLayoutParams:view :lp];
}

- (void) removeSubview : (nonnull UIView*) view {
    [view removeFromSuperview];
    [lpValues removeObjectForKey:view];
    [self updateConstraints];
}

- (void) clearLayoutParams {
    [lpValues removeAllObjects];
}

@end

@implementation LayoutParams
@synthesize width;
@synthesize height;
@synthesize extraWidth;
@synthesize extraHeight;
                       
- (id)init {
  return [self initWithSize:WRAP_CONTENT :WRAP_CONTENT];
 }

- (id) initWithSource : (LayoutParams*) lp {
    return [self initWithSize:lp.width :lp.height];
}

- (id) initWithSize : (int) width : (int) height {
    if ( self = [super init] ) {
        self.extraWidth = 0;
        self.extraHeight = 0;
        self.width = width;
        self.height = height;
    }
    return self;
}

@end

@implementation MeasureableLayoutParams
@synthesize delegate;

- (id)init {
    if ( self = [super init] ) {
        self.delegate = nil;
    }
    return self;
}

@end

@implementation MarginLayoutParams {
    int DEFAULT_MARGIN_RELATIVE;
    int LAYOUT_DIRECTION_MASK;
    int LEFT_MARGIN_UNDEFINED_MASK;
    int RIGHT_MARGIN_UNDEFINED_MASK;
    int RTL_COMPATIBILITY_MODE_MASK;
    int NEED_RESOLUTION_MASK;
    int DEFAULT_MARGIN_RESOLVED;
    int UNDEFINED_MARGIN;
}

- (id) init {
    if (self = [super init]){
        self->DEFAULT_MARGIN_RELATIVE = [LayoutUtils MIN_VALUE];
        self->LAYOUT_DIRECTION_MASK = 0x00000003;
        self->LEFT_MARGIN_UNDEFINED_MASK = 0x00000004;
        self->RIGHT_MARGIN_UNDEFINED_MASK = 0x00000008;
        self->RTL_COMPATIBILITY_MODE_MASK = 0x00000010;
        self->NEED_RESOLUTION_MASK = 0x00000020;
        self->DEFAULT_MARGIN_RESOLVED = 0;
        self->UNDEFINED_MARGIN = self->DEFAULT_MARGIN_RELATIVE;
        
        self.leftMargin = 0;
        self.topMargin = 0;
        self.bottomMargin = 0;
        self.rightMargin = 0;
        self.startMargin = DEFAULT_MARGIN_RELATIVE;
        self.endMargin = self->DEFAULT_MARGIN_RELATIVE;
    }
    return self;
}

@synthesize leftMargin;
@synthesize topMargin;
@synthesize rightMargin;
@synthesize bottomMargin;
@synthesize startMargin;
@synthesize endMargin;
@synthesize mMarginFlags;

- (id) initWithSource : (LayoutParams*) lp {
    return [self initWithSize:lp.width :lp.height];
}

- (id) initWithMarginSource : (MarginLayoutParams*) lp {
    if ( self = [super init] ) {
        self.width = lp.width;
        self.height = lp.height;
        self.leftMargin = lp.leftMargin;
        self.topMargin = lp.topMargin;
        self.rightMargin = lp.rightMargin;
        self.bottomMargin = lp.bottomMargin;
        self.startMargin = lp.startMargin;
        self.endMargin = lp.endMargin;
        self.mMarginFlags = lp.mMarginFlags;
    }
    return self;
}

- (id) initWithSize : (int) width : (int) height {
    if ( self = [super initWithSize:width :height] ) {
        mMarginFlags |= LEFT_MARGIN_UNDEFINED_MASK;
        mMarginFlags |= RIGHT_MARGIN_UNDEFINED_MASK;
        mMarginFlags &= ~NEED_RESOLUTION_MASK;
        mMarginFlags &= ~RTL_COMPATIBILITY_MODE_MASK;
    }
    return self;
}

/**
 * Sets the margins, in pixels. A call to updateConstraints needs
 * to be done so that the new margins are taken into account. Left and right margins may be
 * overridden by updateConstraints depending on layout direction.
 * Margin values should be positive.
 */
- (void) setMargins : (int) left :(int) top : (int) right : (int) bottom {
    leftMargin = left;
    topMargin = top;
    rightMargin = right;
    bottomMargin = bottom;
    mMarginFlags &= ~LEFT_MARGIN_UNDEFINED_MASK;
    mMarginFlags &= ~RIGHT_MARGIN_UNDEFINED_MASK;
    if ([self isMarginRelative]) {
        mMarginFlags |= NEED_RESOLUTION_MASK;
    } else {
        mMarginFlags &= ~NEED_RESOLUTION_MASK;
    }
 }
 
/**
 * Check if margins are relative.
 */
 -(BOOL) isMarginRelative {
     return (startMargin != DEFAULT_MARGIN_RELATIVE || endMargin != DEFAULT_MARGIN_RELATIVE);
 }

/**
 * Sets the relative margins, in pixels. A call to updateConstraints
 * needs to be done so that the new relative margins are taken into account. Left and right
 * margins may be overridden by updateConstraints depending on layout direction.
 * Margin values should be positive.
 */
- (void) setMarginsRelative: (int) start : (int) top : (int) end : (int) bottom {
    startMargin = start;
    topMargin = top;
    endMargin = end;
    bottomMargin = bottom;
    mMarginFlags |= NEED_RESOLUTION_MASK;
}

/**
 * Sets the relative start margin. Margin values should be positive.
 */
- (void) setMarginStart : (int) start {
    startMargin = start;
    mMarginFlags |= NEED_RESOLUTION_MASK;
}


/**
 * Returns the start margin in pixels.
 */
- (int) getMarginStart {
    if (startMargin != DEFAULT_MARGIN_RELATIVE) return startMargin;
    if ((mMarginFlags & NEED_RESOLUTION_MASK) == NEED_RESOLUTION_MASK) {
        [self doResolveMargins];
    }
    
    switch(mMarginFlags & LAYOUT_DIRECTION_MASK) {
        case 0x40000000: //rtl
            return rightMargin;
        case 0x00000000: //ltr
        default:
            return leftMargin;
    }
}

/**
 * Sets the relative end margin. Margin values should be positive.
 */
-(void) setMarginEnd:(int) end {
 endMargin = end;
 mMarginFlags |= NEED_RESOLUTION_MASK;
}


/**
 * Returns the end margin in pixels.
 */
-(int) getMarginEnd {
    if (endMargin != DEFAULT_MARGIN_RELATIVE) return endMargin;
    if ((mMarginFlags & NEED_RESOLUTION_MASK) == NEED_RESOLUTION_MASK) {
        [self doResolveMargins];
    }
    switch(mMarginFlags & LAYOUT_DIRECTION_MASK) {
        case LAYOUT_DIRECTION_RTL: //rtl
            return leftMargin;
        case LAYOUT_DIRECTION_LTR: //ltr
        default:
            return rightMargin;
    }
}

/**
 * Set the layout direction
 */
- (void) setLayoutDirection : (LayoutDirection) layoutDirection {
    if (layoutDirection != LAYOUT_DIRECTION_LTR &&
        layoutDirection != LAYOUT_DIRECTION_RTL) return;
    if (layoutDirection != (mMarginFlags & LAYOUT_DIRECTION_MASK)) {
        mMarginFlags &= ~LAYOUT_DIRECTION_MASK;
        mMarginFlags |= (layoutDirection & LAYOUT_DIRECTION_MASK);
        if ([self isMarginRelative]) {
            mMarginFlags |= NEED_RESOLUTION_MASK;
        } else {
            mMarginFlags &= ~NEED_RESOLUTION_MASK;
        }
    }
}

/**
 * Retuns the layout direction. Can be either LAYOUT_DIRECTION_LTR or LAYOUT_DIRECTION_RTL.
 */
- (LayoutDirection) getLayoutDirection {
    return (mMarginFlags & LAYOUT_DIRECTION_MASK);
}

/**
 * This will be called by updateConstraints. Left and Right margins
 * may be overridden depending on layout direction.
 */
- (void) resolveLayoutDirection : (LayoutDirection) layoutDirection {
    [self setLayoutDirection:layoutDirection];
    // No relative margin or pre JB-MR1 case or no need to resolve, just dont do anything
    // Will use the left and right margins if no relative margin is defined.
    if (! [self isMarginRelative]|| (mMarginFlags & NEED_RESOLUTION_MASK) != NEED_RESOLUTION_MASK) return;
    // Proceed with resolution
    [self doResolveMargins];
}

- (void) doResolveMargins {
    if ((mMarginFlags & RTL_COMPATIBILITY_MODE_MASK) == RTL_COMPATIBILITY_MODE_MASK) {
        // if left or right margins are not defined and if we have some start or end margin
        // defined then use those start and end margins.
        if ((mMarginFlags & LEFT_MARGIN_UNDEFINED_MASK) == LEFT_MARGIN_UNDEFINED_MASK
            && startMargin > DEFAULT_MARGIN_RELATIVE) {
            leftMargin = startMargin;
        }
        if ((mMarginFlags & RIGHT_MARGIN_UNDEFINED_MASK) == RIGHT_MARGIN_UNDEFINED_MASK
            && endMargin > DEFAULT_MARGIN_RELATIVE) {
            rightMargin = endMargin;
        }
    } else {
        // We have some relative margins (either the start one or the end one or both). So use
        // them and override what has been defined for left and right margins. If either start
        // or end margin is not defined, just set it to default "0".
        switch(mMarginFlags & LAYOUT_DIRECTION_MASK) {
            case LAYOUT_DIRECTION_RTL:
                leftMargin = (endMargin > DEFAULT_MARGIN_RELATIVE) ?
                endMargin : DEFAULT_MARGIN_RESOLVED;
                rightMargin = (startMargin > DEFAULT_MARGIN_RELATIVE) ?
                startMargin : DEFAULT_MARGIN_RESOLVED;
                break;
            case LAYOUT_DIRECTION_LTR:
            default:
                leftMargin = (startMargin > DEFAULT_MARGIN_RELATIVE) ?
                startMargin : DEFAULT_MARGIN_RESOLVED;
                rightMargin = (endMargin > DEFAULT_MARGIN_RELATIVE) ?
                endMargin : DEFAULT_MARGIN_RESOLVED;
                break;
        }
    }
    mMarginFlags &= ~NEED_RESOLUTION_MASK;
}

- (BOOL) isLayoutRtl {
    return ((mMarginFlags & LAYOUT_DIRECTION_MASK) == LAYOUT_DIRECTION_RTL);
}

@end

@implementation MeasureValue

@synthesize maxSize;
@synthesize measuredValue;
@synthesize maxValue;
@synthesize lp;
@synthesize child;

@end
