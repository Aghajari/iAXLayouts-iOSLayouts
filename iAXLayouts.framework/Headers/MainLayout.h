//
//  MainLayout.h
//  Layouts
//
//  Created by AmirHossein Aghajari on 10/1/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LayoutUtils.h"
#import "Gravity.h"

typedef NS_ENUM(int, LayoutParamsValue) {
    /**
     * Special value for the height or width requested by a View.
     * MATCH_PARENT means that the view wants to be as big as its parent,
     * minus the parent's padding, if any.
     */
    MATCH_PARENT= -1 ,
    
    /**
     * Special value for the height or width requested by a View.
     * WRAP_CONTENT means that the view wants to be just large enough to fit
     * its own internal content, taking its own padding into account.
     */
    WRAP_CONTENT= -2
};

@interface LayoutParams : NSObject {
    int width,height;
    int extraWidth,extraHeight;
}

- (id _Nonnull) initWithSource : (LayoutParams* _Nonnull) lp ;
- (id _Nonnull ) initWithSize : (int) width : (int) height;

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int extraWidth;
@property (nonatomic) int extraHeight;

@end

@interface MeasureValue : NSObject {
    CGSize maxSize;
    int measuredValue;
    int maxValue;
    LayoutParams* lp;
    UIView* child;
}

@property (nonatomic) CGSize maxSize;
@property (nonatomic) int measuredValue;
@property (nonatomic) int maxValue;
@property (nonatomic) LayoutParams* _Nonnull lp;
@property (nonatomic) UIView* _Nonnull child;

@end

@protocol MeasureValueDelegate <NSObject>
@optional
- (int) GetMeasuredHeight : (MeasureValue*_Nonnull) values;
- (int) GetMeasuredWidth : (MeasureValue*_Nonnull) values;

@end


@interface MeasureableLayoutParams : LayoutParams

@property (nullable, nonatomic, weak) id <MeasureValueDelegate> delegate;

@end



@interface MarginLayoutParams : MeasureableLayoutParams {
    int leftMargin,topMargin,rightMargin,bottomMargin,startMargin,endMargin;
    Byte mMarginFlags;
}

- (id _Nonnull) initWithSource : (LayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithMarginSource : (MarginLayoutParams* _Nonnull) lp ;
- (id _Nonnull ) initWithSize : (int) width : (int) height;

@property (nonatomic) int leftMargin;
@property (nonatomic) int topMargin;
@property (nonatomic) int rightMargin;
@property (nonatomic) int bottomMargin;
@property (nonatomic) int startMargin;
@property (nonatomic) int endMargin;
@property (nonatomic) Byte mMarginFlags;

/**
 * Sets the margins, in pixels. A call to updateConstraints needs
 * to be done so that the new margins are taken into account. Left and right margins may be
 * overridden by updateConstraints depending on layout direction.
 * Margin values should be positive.
 */
- (void) setMargins : (int) left :(int) top : (int) right : (int) bottom;
/**
 * Check if margins are relative.
 */
-(BOOL) isMarginRelative ;
/**
 * Sets the relative margins, in pixels. A call to updateConstraints
 * needs to be done so that the new relative margins are taken into account. Left and right
 * margins may be overridden by updateConstraints depending on layout direction.
 * Margin values should be positive.
 */
- (void) setMarginsRelative: (int) start : (int) top : (int) end : (int) bottom ;
/**
 * Sets the relative start margin. Margin values should be positive.
 */
- (void) setMarginStart : (int) start ;
/**
 * Returns the start margin in pixels.
 */
- (int) getMarginStart ;
/**
 * Sets the relative end margin. Margin values should be positive.
 */
-(void) setMarginEnd:(int) end ;
/**
 * Returns the end margin in pixels.
 */
-(int) getMarginEnd;
/**
 * Set the layout direction
 */
- (void) setLayoutDirection : (LayoutDirection) layoutDirection ;
/**
 * Retuns the layout direction. Can be either LAYOUT_DIRECTION_LTR or LAYOUT_DIRECTION_RTL.
 */
- (LayoutDirection) getLayoutDirection;
/**
 * This will be called by updateConstraints. Left and Right margins
 * may be overridden depending on layout direction.
 */
- (void) resolveLayoutDirection : (LayoutDirection) layoutDirection;
- (BOOL) isLayoutRtl;

@end

@interface MainLayout : UIView {
    int paddingTop;
    int paddingRight;
    int paddingBottom;
    int paddingLeft;
    LayoutDirection layoutDirection;
    int gravity;
    BOOL skipLayout;
}

@property (nonatomic) int paddingTop;
@property (nonatomic) int paddingRight;
@property (nonatomic) int paddingBottom;
@property (nonatomic) int paddingLeft;
@property (nonatomic) LayoutDirection layoutDirection;
@property (nonatomic) int gravity;
@property (nonatomic) BOOL skipLayout;

- (BOOL) hasChildLayoutLoaded : (UIView*_Nonnull) view;
- (LayoutParams* _Nullable) getChildLayoutParams : ( UIView* _Nonnull ) view;
- (void) setChildLayoutParams : (UIView* _Nonnull) view : (LayoutParams* _Nullable) lp;
- (void) clearLayoutParams;

- (void) addSubview:(UIView * _Nonnull)view : (LayoutParams* _Nullable) lp;
- (void) insertSubview:(UIView *_Nonnull)view  atIndex: (NSInteger) index : (LayoutParams*_Nullable) lp;
- (void) insertSubview:(UIView *_Nonnull)view  aboveSubview: (UIView*_Nonnull) subview : (LayoutParams*_Nullable) lp;
- (void) insertSubview:(UIView *_Nonnull)view  belowSubview: (UIView*_Nonnull) subview : (LayoutParams*_Nullable) lp;
- (void) removeSubview : (nonnull UIView*) view;


- (void) updateLayout : (int) w : (int) h ;
- (void) setPadding : (int) left : (int) top : (int) right : (int) bottom;
- (void) setChildFrame: (UIView*_Nonnull) child : (int) left : (int) top : (int) width : (int) height;

@end


