//
//  RelativeLayout.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/5/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelativeLayout.h"
#import "DependencyGraph.h"
#import "LayoutUtils.h"
#import "MeasureSpec.h"

#define RULE_NUMBER(ruleValue) \
[NSNumber numberWithInt:ruleValue]

@implementation NSMutableDictionary (IntKeyDictionary)
- (void) setObject:(id)obj forId:(int)id {
    [self setObject:obj forKey:[NSNumber numberWithInt:id]];
}

- (void) removeObjectForId:(int)id {
    [self removeObjectForKey:[NSNumber numberWithInt:id]];
}

- (id) objectForId:(int)id {
    return [self objectForKey:[NSNumber numberWithInt:id]];
}

- (BOOL) hasRule : (RelativeLayoutRule) verb {
    return [self objectForKey:RULE_NUMBER(verb)] != nil && [[self objectForKey:RULE_NUMBER(verb)] intValue] != 0;
}
@end


@implementation RelativeLayout {
    CGRect mContentBounds;
    CGRect mSelfBounds;
    BOOL mDirtyHierarchy;
    NSMutableArray<UIView*> *mSortedHorizontalChildren;
    NSMutableArray<UIView*> *mSortedVerticalChildren;
    DependencyGraph *mGraph;
    BOOL mAllowBrokenMeasureSpecs;
    BOOL mMeasureVerticalWithPaddingMargin;
    
}

@synthesize ignoreGravity;

+ (int) VALUE_NOT_SET {
    return [LayoutUtils MIN_VALUE];
}

- (id) init {
    if (self = [super init]){
        mContentBounds = CGRectMake(0, 0, 0, 0);
        mSelfBounds = CGRectMake(0, 0, 0, 0);
        mGraph = [[DependencyGraph alloc] init];
        mAllowBrokenMeasureSpecs = NO;
        mMeasureVerticalWithPaddingMargin = NO;
        mSortedHorizontalChildren = [[NSMutableArray alloc] init];
        mSortedVerticalChildren = [[NSMutableArray alloc] init];
        mDirtyHierarchy = NO;
    }
    return self;
}

- (CGSize) sizeThatFits:(CGSize)size {
    NSLog(@"%@", @("ignoring RelativeLayout WrapContent"));
    return size;
}

- (void) updateLayout:(int)w :(int)h {
    [super updateLayout:w :h];
    mDirtyHierarchy = YES;
    
    
    [self onMeasure:w :h];

    for (UIView* child in self.subviews) {
        if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            RelativeLayoutParams *params = (RelativeLayoutParams*) [self getChildLayoutParams:child];
            [self setChildFrame:child :params.mLeft :params.mTop :params.mRight-params.mLeft :params.mBottom-params.mTop];
        }
    }
}


- (void) setRelativeGravity: (int) gravity {
    if (self.gravity != gravity) {
        if ((gravity & Gravity.RELATIVE_HORIZONTAL_GRAVITY_MASK) == 0) {
            gravity |= Gravity.START;
        }
        if ((gravity & Gravity.VERTICAL_GRAVITY_MASK) == 0) {
            gravity |= Gravity.TOP;
        }
        self.gravity = gravity;
        [self updateConstraints];
    }
}

- (void) setHorizontalGravity :(int) horizontalGravity {
    int gravity = horizontalGravity & Gravity.RELATIVE_HORIZONTAL_GRAVITY_MASK;
    if ((self.gravity & Gravity.RELATIVE_HORIZONTAL_GRAVITY_MASK) != gravity) {
        self.gravity = (self.gravity & ~[Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK]) | gravity;
        [self updateConstraints];
    }
}

- (void) setVerticalGravity : (int) verticalGravity {
    int gravity = verticalGravity & [Gravity VERTICAL_GRAVITY_MASK];
    if ((self.gravity & [Gravity VERTICAL_GRAVITY_MASK]) != gravity) {
        self.gravity = (self.gravity & ~[Gravity VERTICAL_GRAVITY_MASK]) | gravity;
        [self updateConstraints];
    }
}


- (void) sortChildren {
    [mSortedVerticalChildren removeAllObjects];
    [mSortedHorizontalChildren removeAllObjects];
    
    DependencyGraph *graph = mGraph;
    [graph clear];
    for (UIView* view in self.subviews){
        [graph add:view];
    }
    mSortedVerticalChildren = [graph getVerticalSortedViews:mSortedVerticalChildren];
    mSortedHorizontalChildren = [graph getHorizontalSortedViews:mSortedHorizontalChildren];
}

- (UIView*) findViewByTagID : (int) tag {
    for (UIView* v in self.subviews) {
        if (v.tag==tag) return v;
    }
    return nil;
}

- (void) onMeasure : (int) myWidth : (int) myHeight {
    if (mDirtyHierarchy) {
        mDirtyHierarchy = false;
        [self sortChildren];
    }
    int width = myWidth;
    int height = myHeight;
    UIView* ignore = nil;
    int gravity = self.gravity & [Gravity RELATIVE_HORIZONTAL_GRAVITY_MASK];
    BOOL horizontalGravity = gravity != [Gravity START] && gravity != 0;
    gravity = self.gravity & [Gravity VERTICAL_GRAVITY_MASK];
    BOOL verticalGravity = gravity != [Gravity TOP] && gravity != 0;
    int left = [LayoutUtils MAX_VALUE];
    int top = [LayoutUtils MAX_VALUE];
    int right = [LayoutUtils MIN_VALUE];
    int bottom = [LayoutUtils MIN_VALUE];
    BOOL offsetHorizontalAxis = NO;
    BOOL offsetVerticalAxis = NO;
    if ((horizontalGravity || verticalGravity) && ignoreGravity != 0) {
        ignore = [self findViewByTagID:ignoreGravity];
    }
    BOOL isWrapContentWidth = NO;
    BOOL isWrapContentHeight = NO;
    for (UIView* child in mSortedHorizontalChildren) {
        if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            RelativeLayoutParams *params = (RelativeLayoutParams*) [self getChildLayoutParams:child];
            NSMutableDictionary<NSNumber*,NSNumber*>* rules = [params getRules:layoutDirection];
            [self applyHorizontalSizeRules:params:myWidth:rules];
            
            if ([self positionChildHorizontal:child: params: myWidth: isWrapContentWidth]) {
                offsetHorizontalAxis = YES;
            }
        }
    }
    for (UIView* child in mSortedVerticalChildren) {
        if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
            RelativeLayoutParams *params = (RelativeLayoutParams*) [self getChildLayoutParams:child];
            [self applyVerticalSizeRules:params: myHeight: 0];
            if ([self positionChildVertical:child:params:myHeight:isWrapContentHeight]) {
                offsetVerticalAxis = YES;
            }
            if (child != ignore || verticalGravity) {
                left = MIN(left, params.mLeft - params.leftMargin);
                top = MIN(top, params.mTop - params.topMargin);
            }
            if (child != ignore || horizontalGravity) {
                right = MAX(right, params.mRight + params.rightMargin);
                bottom = MAX(bottom, params.mBottom + params.bottomMargin);
            }
        }
    }

    if (horizontalGravity || verticalGravity) {
        mSelfBounds = CGRectMake(paddingLeft, paddingTop, width - paddingRight,
                                 height - paddingBottom);
        [RelativeLayout apply:gravity:right - left:bottom - top:mSelfBounds:mContentBounds:layoutDirection];
        int horizontalOffset = mContentBounds.origin.x- left;
        int verticalOffset = mContentBounds.origin.y - top;
        if (horizontalOffset != 0 || verticalOffset != 0) {
            for (UIView* child in mSortedVerticalChildren) {
                if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
                    RelativeLayoutParams *params = (RelativeLayoutParams*) [self getChildLayoutParams:child];
                    if (horizontalGravity) {
                        params.mLeft += horizontalOffset;
                        params.mRight += horizontalOffset;
                    }
                    if (verticalGravity) {
                        params.mTop += verticalOffset;
                        params.mBottom += verticalOffset;
                    }
                }
            }
        }
    }
    if (layoutDirection == LAYOUT_DIRECTION_RTL) {
        int offsetWidth = myWidth - width;
        for (UIView* child in mSortedVerticalChildren) {
            if (!child.isHidden && [self hasChildLayoutLoaded:child]) {
                RelativeLayoutParams *params = (RelativeLayoutParams*) [self getChildLayoutParams:child];
                params.mLeft -= offsetWidth;
                params.mRight -= offsetWidth;
            }
        }
    }
}

- (int) compareLayoutPosition : (RelativeLayoutParams*) p1 : (RelativeLayoutParams*) p2 {
    int topDiff = p1.mTop - p2.mTop;
    if (topDiff != 0) {
        return topDiff;
    }
    return p1.mLeft - p2.mLeft;
}


- (BOOL) positionChildHorizontal : (UIView*) child : (RelativeLayoutParams*) params : (int) myWidth : (BOOL) wrapContent {
    NSMutableDictionary<NSNumber*,NSNumber*>* rules =  [params getRules:self.layoutDirection];
    NSLog(@"%@", @(params.mLeft));
    if (params.mLeft == [RelativeLayout VALUE_NOT_SET] && params.mRight != [RelativeLayout VALUE_NOT_SET]) {
        // Right is fixed, but left varies
        params.mLeft = params.mRight - [self getMeasuredWidth:child :params];
    } else if (params.mLeft != [RelativeLayout VALUE_NOT_SET] && params.mRight == [RelativeLayout VALUE_NOT_SET]) {
        // Left is fixed, but right varies
        params.mRight = params.mLeft + [self getMeasuredWidth:child :params];
    } else if (params.mLeft == [RelativeLayout VALUE_NOT_SET] && params.mRight == [RelativeLayout VALUE_NOT_SET]) {
        // Both left and right vary
        if ([rules hasRule:RULE_CENTER_IN_PARENT] || [rules hasRule:RULE_CENTER_HORIZONTAL]) {
            if (!wrapContent) {
                [self centerHorizontal:child:params:myWidth];
            } else {
                [self positionAtEdge:child:params:myWidth];
            }
            return true;
        } else {
            // This is the default case. For RTL we start from the right and for LTR we start
            // from the left. This will give LEFT/TOP for LTR and RIGHT/TOP for RTL.
            [self positionAtEdge:child:params:myWidth];
        }
    }
    return rules[RULE_NUMBER(RULE_ALIGN_PARENT_END)] != 0;
}

- (void) positionAtEdge : (UIView*) child : (RelativeLayoutParams*) params : (int) myWidth {
    if (layoutDirection == LAYOUT_DIRECTION_RTL) {
        params.mRight = myWidth - paddingRight - params.rightMargin;
        params.mLeft = params.mRight - [self getMeasuredWidth:child :params];
    } else {
        params.mLeft = paddingLeft + params.leftMargin;
        params.mRight = params.mLeft + [self getMeasuredWidth:child :params];
    }
}
- (BOOL) positionChildVertical : (UIView*) child : (RelativeLayoutParams*) params : (int) myHeight : (BOOL) wrapContent {
     NSMutableDictionary<NSNumber*,NSNumber*>* rules = [params getRules];
    if (params.mTop == [RelativeLayout VALUE_NOT_SET] && params.mBottom != [RelativeLayout VALUE_NOT_SET]) {
        // Bottom is fixed, but top varies
        params.mTop = params.mBottom - [self getMeasuredHeight:child :params];
    } else if (params.mTop != [RelativeLayout VALUE_NOT_SET] && params.mBottom == [RelativeLayout VALUE_NOT_SET]) {
        // Top is fixed, but bottom varies
        params.mBottom = params.mTop + [self getMeasuredHeight:child :params];
    } else if (params.mTop == [RelativeLayout VALUE_NOT_SET] && params.mBottom == [RelativeLayout VALUE_NOT_SET]) {
        // Both top and bottom vary
        if ([rules hasRule:RULE_CENTER_IN_PARENT] ||[rules hasRule:RULE_CENTER_VERTICAL]) {
            if (!wrapContent) {
                [self centerVertical:child:params:myHeight];
            } else {
                params.mTop = paddingTop + params.topMargin;
                params.mBottom = params.mTop + [self getMeasuredHeight:child :params];
            }
            return true;
        } else {
            params.mTop = paddingTop + params.topMargin;
            params.mBottom = params.mTop + [self getMeasuredHeight:child :params];
        }
    }
    return rules[RULE_NUMBER(RULE_ALIGN_PARENT_BOTTOM)] != 0;
}
- (void) applyHorizontalSizeRules : (RelativeLayoutParams*) childParams : (int) myWidth : (NSMutableDictionary<NSNumber*,NSNumber*>*) rules {
    RelativeLayoutParams* anchorParams;
    // [RelativeLayout VALUE_NOT_SET] indicates a "soft requirement" in that direction. For example:
    // left=10, right=[RelativeLayout VALUE_NOT_SET] means the view must start at 10, but can go as far as it
    // wants to the right
    // left=[RelativeLayout VALUE_NOT_SET], right=10 means the view must end at 10, but can go as far as it
    // wants to the left
    // left=10, right=20 means the left and right ends are both fixed
    childParams.mLeft = [RelativeLayout VALUE_NOT_SET];
    childParams.mRight = [RelativeLayout VALUE_NOT_SET];
    anchorParams = [self getRelatedViewParams:rules: RULE_LEFT_OF];
    if (anchorParams != nil) {
        childParams.mRight = anchorParams.mLeft - (anchorParams.leftMargin +
                                                   childParams.rightMargin);
    } else if (childParams.alignWithParent &&   [rules hasRule:RULE_LEFT_OF]) {
        if (myWidth >= 0) {
            childParams.mRight = myWidth - paddingRight - childParams.rightMargin;
        }
    }
    anchorParams = [ self getRelatedViewParams:rules: RULE_RIGHT_OF];
    if (anchorParams != nil) {
        childParams.mLeft = anchorParams.mRight + (anchorParams.rightMargin +
                                                   childParams.leftMargin);
    } else if (childParams.alignWithParent && [rules hasRule:RULE_RIGHT_OF]) {
        childParams.mLeft = paddingLeft + childParams.leftMargin;
    }
    anchorParams = [self getRelatedViewParams:rules: RULE_ALIGN_LEFT];
    if (anchorParams != nil) {
        childParams.mLeft = anchorParams.mLeft + childParams.leftMargin;
    } else if (childParams.alignWithParent &&   [rules hasRule:RULE_ALIGN_LEFT]) {
        childParams.mLeft = paddingLeft + childParams.leftMargin;
    }
    anchorParams = [self getRelatedViewParams:rules:RULE_ALIGN_RIGHT];
    if (anchorParams != nil) {
        childParams.mRight = anchorParams.mRight - childParams.rightMargin;
    } else if (childParams.alignWithParent && [rules hasRule:RULE_ALIGN_RIGHT]) {
        if (myWidth >= 0) {
            childParams.mRight = myWidth - paddingRight - childParams.rightMargin;
        }
    }
    if ([rules hasRule:RULE_ALIGN_PARENT_LEFT]) {
        childParams.mLeft = paddingLeft + childParams.leftMargin;
    }
    if ([rules hasRule:RULE_ALIGN_PARENT_RIGHT]) {
        if (myWidth >= 0) {
            childParams.mRight = myWidth - paddingRight - childParams.rightMargin;
        }
    }
}
- (void) applyVerticalSizeRules : (RelativeLayoutParams*) childParams : (int) myHeight : (int) myBaseline {
    NSMutableDictionary<NSNumber*,NSNumber*>* rules = [childParams getRules];
    // Baseline alignment overrides any explicitly specified top or bottom.
    int baselineOffset = [self getRelatedViewBaselineOffset:rules];
    if (baselineOffset != -1) {
        if (myBaseline != -1) {
            baselineOffset -= myBaseline;
        }
        childParams.mTop = baselineOffset;
        childParams.mBottom = [RelativeLayout VALUE_NOT_SET];
        return;
    }
    RelativeLayoutParams* anchorParams;
    childParams.mTop = [RelativeLayout VALUE_NOT_SET];
    childParams.mBottom = [RelativeLayout VALUE_NOT_SET];
    anchorParams = [self getRelatedViewParams:rules:RULE_ABOVE];
    if (anchorParams != nil) {
        childParams.mBottom = anchorParams.mTop - (anchorParams.topMargin +
                                                   childParams.bottomMargin);
    } else if (childParams.alignWithParent && [rules hasRule:RULE_ABOVE]) {
        if (myHeight >= 0) {
            childParams.mBottom = myHeight - paddingBottom - childParams.bottomMargin;
        }
    }
    anchorParams = [self getRelatedViewParams:rules:RULE_BELOW];
    if (anchorParams != nil) {
        childParams.mTop = anchorParams.mBottom + (anchorParams.bottomMargin +
                                                   childParams.topMargin);
    } else if (childParams.alignWithParent && [rules hasRule:RULE_BELOW]) {
        childParams.mTop = paddingTop + childParams.topMargin;
    }
    anchorParams = [self getRelatedViewParams:rules:RULE_ALIGN_TOP];
    if (anchorParams != nil) {
        childParams.mTop = anchorParams.mTop + childParams.topMargin;
    } else if (childParams.alignWithParent &&  [rules hasRule:RULE_ALIGN_TOP] ) {
        childParams.mTop = paddingTop + childParams.topMargin;
    }
    anchorParams = [self getRelatedViewParams:rules:RULE_ALIGN_BOTTOM];
    if (anchorParams != nil) {
        childParams.mBottom = anchorParams.mBottom - childParams.bottomMargin;
    } else if (childParams.alignWithParent &&  [rules hasRule:RULE_ALIGN_BOTTOM]) {
        if (myHeight >= 0) {
            childParams.mBottom = myHeight - paddingBottom - childParams.bottomMargin;
        }
    }
    if ([rules hasRule:RULE_ALIGN_PARENT_TOP]) {
        childParams.mTop = paddingTop + childParams.topMargin;
    }
    if ([rules hasRule:RULE_ALIGN_PARENT_BOTTOM]) {
        if (myHeight >= 0) {
            childParams.mBottom = myHeight - paddingBottom - childParams.bottomMargin;
        }
    }

}
- (UIView*) getRelatedView : (NSMutableDictionary<NSNumber*,NSNumber*>*) rules : (int) relation {
    NSNumber *rid = rules[RULE_NUMBER(relation)];
    if (rid != 0) {
        Node* node = [mGraph.mKeyNodes objectForKey:rid];
        if (node == nil) return nil;
        UIView* v = node.view;
        // Find the first non-GONE view up the chain
        while (v!=nil && v.isHidden) {
            RelativeLayoutParams *params = (RelativeLayoutParams*) [self getChildLayoutParams:v];
            rules = [params getRules:layoutDirection];
            node = [mGraph.mKeyNodes objectForKey:rules[RULE_NUMBER(relation)]];
            // ignore self dependency. for more info look in git commit: da3003
            if (node == nil || v == node.view) return nil;
            v = node.view;
        }
        return v;
    }
    return nil;
}

- (RelativeLayoutParams*) getRelatedViewParams : (NSMutableDictionary<NSNumber*,NSNumber*>*) rules : (int) relation {
    UIView* v = [self getRelatedView:rules:relation];
    if (v != nil) {
        LayoutParams* params = [self getChildLayoutParams:v];
        if (params != nil && [params isKindOfClass:[RelativeLayoutParams class]]) {
            return (RelativeLayoutParams*) params;
        }
    }
    return nil;
}

- (int) getRelatedViewBaselineOffset : (NSMutableDictionary<NSNumber*,NSNumber*>*) rules {
    return -1;
}
- (void) centerHorizontal : (UIView*) child : (RelativeLayoutParams*) params : (int) myWidth {
    int childWidth = [self getMeasuredWidth:child :params];
    int left = (myWidth - childWidth) / 2;
    params.mLeft = left;
    params.mRight = left + childWidth;
}

- (void) centerVertical : (UIView*) child : (RelativeLayoutParams*) params : (int) myHeight {
    int childHeight = [self getMeasuredHeight:child :params];
    int top = (myHeight - childHeight) / 2;
    params.mTop = top;
    params.mBottom = top + childHeight;
}

- (int) getMeasuredWidth : (UIView*) child : (RelativeLayoutParams*) params {
    if (layoutDirection == LAYOUT_DIRECTION_RTL){
        return [MeasureSpec getMeasuredWidth:child :params :self.bounds.size.width - params.mLeft - params.leftMargin : [self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
    }else{
        return [MeasureSpec getMeasuredWidth:child :params :self.bounds.size.width - params.mLeft - params.rightMargin : [self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
    }
}
- (int) getMeasuredHeight : (UIView*) child : (RelativeLayoutParams*) params {
    if (layoutDirection == LAYOUT_DIRECTION_RTL){
        return [MeasureSpec getMeasuredHeight:child :params :self.bounds.size.height - params.mTop - params.topMargin : [self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
    }else{
        return [MeasureSpec getMeasuredHeight:child :params :self.bounds.size.height - params.mTop - params.bottomMargin : [self MAX_WIDTH:child] :[self MAX_HEIGHT:child]];
    }
}

- (CGFloat) MAX_WIDTH : (UIView*) child {
    if ([child isKindOfClass:[MainLayout class]]) {
        return self.bounds.size.width;
    }else{
        return CGFLOAT_MAX;
    }
}

- (CGFloat) MAX_HEIGHT : (UIView*) child {
    if ([child isKindOfClass:[MainLayout class]]) {
        return self.bounds.size.height;
    }else{
        return CGFLOAT_MAX;
    }
}

+ (void) apply : (int) gravity : (int) w : (int) h : (CGRect) container : (CGRect) outRect : (int) layoutDirection {
    int absGravity = [Gravity getAbsoluteGravity:gravity:layoutDirection];
    [RelativeLayout apply:absGravity :w :h :container :0 :0:outRect];
}
/**
 * Apply a gravity constant to an object.
 */
+ (void) apply : (int) gravity : (int) w : (int) h : (CGRect) container : (int) xAdj : (int) yAdj : (CGRect) outRect {
    int state = gravity&(([Gravity AXIS_PULL_BEFORE]|[Gravity AXIS_PULL_AFTER])<<[Gravity AXIS_X_SHIFT]);
    if (state==0){
        outRect.origin.x = container.origin.x + ((container.size.width - w)/2) + xAdj;
        outRect.size.width =  w;
        if ((gravity&([Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT])) == ([Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT])) {
            if (outRect.origin.x < container.origin.x) {
                outRect.origin.x = container.origin.x;
            }
            if ((outRect.origin.x+outRect.size.width)> (container.origin.x+container.size.width)) {
                outRect.size.width = container.origin.x+container.size.width-outRect.origin.x;
            }
        }
    }else if(state == [Gravity AXIS_PULL_BEFORE]<<[Gravity AXIS_X_SHIFT]) {
        outRect.origin.x = container.origin.x + xAdj;
        outRect.size.width = w;
        if ((gravity&([Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT])) == ([Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT])) {
            if ((outRect.origin.x+outRect.size.width) > (container.origin.x+container.size.width)) {
                outRect.size.width = container.origin.x+container.size.width-outRect.origin.x;
            }
        }
    }else if (state == [Gravity AXIS_PULL_AFTER]<<[Gravity AXIS_X_SHIFT]){
        outRect.size.width = container.origin.x + container.size.width - xAdj - outRect.origin.x;
        outRect.origin.x = outRect.origin.x + outRect.size.width - w;
        if ((gravity&([Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT])) == ([Gravity AXIS_CLIP]<<[Gravity AXIS_X_SHIFT])) {
            if (outRect.origin.x < container.origin.x) {
                outRect.origin.x = container.origin.x;
            }
        }
    }else{
        outRect.origin.x = container.origin.x + xAdj;
        outRect.size.width = outRect.size.width;
    }
    
    int state2 = gravity&(([Gravity AXIS_PULL_BEFORE]|[Gravity AXIS_PULL_AFTER])<<[Gravity AXIS_Y_SHIFT]);
    if (state2 == 0) {
            outRect.origin.y = container.origin.y
            + ((container.size.height - h)/2) + yAdj;
            outRect.size.height = h;
            if ((gravity&([Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT])) == ([Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT])) {
                if (outRect.origin.y < container.origin.y) {
                    outRect.origin.y = container.origin.y;
                }
                if ((outRect.origin.y+outRect.size.height) > (container.origin.y+container.size.height)) {
                    outRect.size.height = container.origin.y + container.size.height - outRect.origin.y;
                }
            }
    } else if (state2==[Gravity AXIS_PULL_BEFORE]<<[Gravity AXIS_Y_SHIFT]){
            outRect.origin.y = container.origin.y + yAdj;
            outRect.size.height = h;
            if ((gravity&([Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT])) == ([Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT])) {
                if ((outRect.origin.y+outRect.size.height) > (container.origin.y+container.size.height)) {
                    outRect.size.height = container.origin.y + container.size.height - outRect.origin.y;
                }
            }
    } else if (state== [Gravity AXIS_PULL_AFTER]<<[Gravity AXIS_Y_SHIFT]){
            outRect.size.height = container.origin.y + container.size.height - yAdj - outRect.origin.y;
            outRect.origin.y = outRect.origin.y + outRect.size.height - h;
            if ((gravity&([Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT])) == ([Gravity AXIS_CLIP]<<[Gravity AXIS_Y_SHIFT])) {
                if (outRect.origin.y < container.origin.y) {
                    outRect.origin.y = container.origin.y;
                }
            }
    }else{
            outRect.origin.y = container.origin.y + yAdj;
            outRect.size.height = container.size.height;
    }
}

@end

@implementation RelativeLayoutParams

@synthesize mRules;
@synthesize mInitialRules;
@synthesize mLeft;
@synthesize mTop;
@synthesize mRight;
@synthesize mBottom;
@synthesize mNeedsLayoutResolution;
@synthesize mIsRtlCompatibilityMode;
@synthesize mRulesChanged;
@synthesize alignWithParent;

- (id) init {
    if (self = [super init]){
        [self loadDefaultValues];
    }
    return self;
}

- (id) initWithSource : (LayoutParams*) lp {
    return [self initWithSize:lp.width :lp.height];
}

- (id) initWithMarginSource : (MarginLayoutParams*) lp {
    if ( self = [super initWithMarginSource:lp] ) {
        [self loadDefaultValues];
    }
    return self;
}

- (id) initWithSize : (int) width : (int) height {
    if ( self = [super initWithSize:width :height] ){
        [self loadDefaultValues];
    }
    return self;
}

- (void) loadDefaultValues {
    mLeft = [RelativeLayout VALUE_NOT_SET];
    mTop = [RelativeLayout VALUE_NOT_SET];
    mRight = [RelativeLayout VALUE_NOT_SET];
    mBottom = [RelativeLayout VALUE_NOT_SET];
    mNeedsLayoutResolution = NO;
    mRulesChanged = NO;
    mIsRtlCompatibilityMode = NO;
    alignWithParent = NO;
    mRules = [[NSMutableDictionary alloc] init];
    mInitialRules = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<22; i++) {
        mRules[RULE_NUMBER(i)] = RULE_NUMBER(0);
        mInitialRules[RULE_NUMBER(i)] = RULE_NUMBER(0);
    }
}

- (id) initWithRelativeSource:(RelativeLayoutParams *)lp {
    if ( self = [super initWithMarginSource:lp] ) {
        self.mIsRtlCompatibilityMode = lp.mIsRtlCompatibilityMode;
        self.mRulesChanged = lp.mRulesChanged;
        self.alignWithParent = lp.alignWithParent;
        self.mRules = [lp.mRules mutableCopy];
        self.mInitialRules = [lp.mInitialRules mutableCopy];
        mLeft = [RelativeLayout VALUE_NOT_SET];
        mTop = [RelativeLayout VALUE_NOT_SET];
        mRight = [RelativeLayout VALUE_NOT_SET];
        mBottom = [RelativeLayout VALUE_NOT_SET];
    }
    return self;
}

- (void) addRule : (RelativeLayoutRule) verb {
    [self addRule:verb :RULE_TRUE];
}

- (void) addRule : (RelativeLayoutRule) verb : (int) viewID {
    // If we're removing a relative rule, we'll need to force layout
    // resolution the next time it's requested.
    if (!mNeedsLayoutResolution && [self isRelativeRule:verb]
        && [self hasInitialRule:verb] && viewID == 0) {
        mNeedsLayoutResolution = true;
    }
    mRules[RULE_NUMBER(verb)] = RULE_NUMBER(viewID);
    mInitialRules[RULE_NUMBER(verb)] = RULE_NUMBER(viewID);
    mRulesChanged = true;
}

- (void) removeRule : (RelativeLayoutRule) verb {
    [self addRule:verb :0];
}

- (int) getRule : (RelativeLayoutRule) verb {
    return [mRules[[NSNumber numberWithInt:verb]] intValue];
}

- (BOOL) hasRelativeRules {
    return ([self hasInitialRule:RULE_START_OF] || [self hasInitialRule:RULE_END_OF]||
            [self hasInitialRule:RULE_ALIGN_START] || [self hasInitialRule:RULE_ALIGN_END] ||
            [self hasInitialRule:RULE_ALIGN_PARENT_START] || [self hasInitialRule:RULE_ALIGN_PARENT_END]);
}

- (BOOL) isRelativeRule : (RelativeLayoutRule) rule {
    return rule == RULE_START_OF || rule == RULE_END_OF
    || rule == RULE_ALIGN_START || rule == RULE_ALIGN_END
    || rule == RULE_ALIGN_PARENT_START || rule == RULE_ALIGN_PARENT_END;
}

- (BOOL) hasInitialRule : (RelativeLayoutRule) verb {
    return mInitialRules[RULE_NUMBER(verb)] != nil && [mInitialRules[RULE_NUMBER(verb)] intValue] != 0;
}

- (BOOL) hasRule : (RelativeLayoutRule) verb {
    return mRules[RULE_NUMBER(verb)] != nil && [mRules[RULE_NUMBER(verb)] intValue] != 0;
}

// The way we are resolving rules depends on the layout direction and if we are pre JB MR1
// or not.
//
// If we are pre JB MR1 (said as "RTL compatibility mode"), "left"/"right" rules are having
// predominance over any "start/end" rules that could have been defined. A special case:
// if no "left"/"right" rule has been defined and "start"/"end" rules are defined then we
// resolve those "start"/"end" rules to "left"/"right" respectively.
//
// If we are JB MR1+, then "start"/"end" rules are having predominance over "left"/"right"
// rules. If no "start"/"end" rule is defined then we use "left"/"right" rules.
//
// In all cases, the result of the resolution should clear the "start"/"end" rules to leave
// only the "left"/"right" rules at the end.
- (void) resolveRules : (LayoutDirection) layoutDirection {
    BOOL isLayoutRtl = (layoutDirection == LAYOUT_DIRECTION_RTL);
    mInitialRules = [mRules mutableCopy];
    
    if (mIsRtlCompatibilityMode) {
        if ([self hasRule:RULE_ALIGN_START]) {
            if (mRules[RULE_NUMBER(RULE_ALIGN_LEFT)] == RULE_NUMBER(0)) {
                // "left" rule is not defined but "start" rule is: use the "start" rule as
                // the "left" rule
                mRules[RULE_NUMBER(RULE_ALIGN_LEFT)] = mRules[RULE_NUMBER(RULE_ALIGN_START)];
            }
            mRules[RULE_NUMBER(RULE_ALIGN_START)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_END]) {
            if (![self hasRule:RULE_ALIGN_RIGHT]) {
                // "right" rule is not defined but "end" rule is: use the "end" rule as the
                // "right" rule
                mRules[RULE_NUMBER(RULE_ALIGN_RIGHT)] = mRules[RULE_NUMBER(RULE_ALIGN_END)];
            }
            mRules[RULE_NUMBER(RULE_ALIGN_END)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_START_OF]) {
            if (![self hasRule:RULE_LEFT_OF]) {
                // "left" rule is not defined but "start" rule is: use the "start" rule as
                // the "left" rule
                mRules[RULE_NUMBER(RULE_LEFT_OF)] = mRules[RULE_NUMBER(RULE_START_OF)];
            }
            mRules[RULE_NUMBER(RULE_START_OF)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_END_OF]) {
            if (![self hasRule:RULE_RIGHT_OF]) {
                // "right" rule is not defined but "end" rule is: use the "end" rule as the
                // "right" rule
                mRules[RULE_NUMBER(RULE_RIGHT_OF)] = mRules[RULE_NUMBER(RULE_END_OF)];
            }
            mRules[RULE_NUMBER(RULE_END_OF)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_PARENT_START]) {
            if (![self hasRule:RULE_ALIGN_PARENT_LEFT]) {
                // "left" rule is not defined but "start" rule is: use the "start" rule as
                // the "left" rule
                mRules[RULE_NUMBER(RULE_ALIGN_PARENT_LEFT)] = mRules[RULE_NUMBER(RULE_ALIGN_PARENT_START)];
            }
            mRules[RULE_NUMBER(RULE_ALIGN_PARENT_START)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_PARENT_END]) {
            if (![self hasRule:RULE_ALIGN_PARENT_RIGHT]) {
                // "right" rule is not defined but "end" rule is: use the "end" rule as the
                // "right" rule
                mRules[RULE_NUMBER(RULE_ALIGN_PARENT_RIGHT)] = mRules[RULE_NUMBER(RULE_ALIGN_PARENT_END)];
            }
            mRules[RULE_NUMBER(RULE_ALIGN_PARENT_END)] = RULE_NUMBER(0);
        }
    } else {
        // JB MR1+ case
        if (([self hasRule:RULE_ALIGN_START] || [self hasRule:RULE_ALIGN_END]) &&
            ([self hasRule:RULE_ALIGN_LEFT] || [self hasRule:RULE_ALIGN_RIGHT])) {
            // "start"/"end" rules take precedence over "left"/"right" rules
            mRules[RULE_NUMBER(RULE_ALIGN_LEFT)] = RULE_NUMBER(0);
            mRules[RULE_NUMBER(RULE_ALIGN_RIGHT)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_START]) {
            // "start" rule resolved to "left" or "right" depending on the direction
            mRules[RULE_NUMBER(isLayoutRtl ? RULE_ALIGN_RIGHT : RULE_ALIGN_LEFT)] = mRules[RULE_NUMBER(RULE_ALIGN_START)];
            mRules[RULE_NUMBER(RULE_ALIGN_START)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_END]) {
            // "end" rule resolved to "left" or "right" depending on the direction
            mRules[RULE_NUMBER(isLayoutRtl ? RULE_ALIGN_LEFT : RULE_ALIGN_RIGHT)] = mRules[RULE_NUMBER(RULE_ALIGN_END)];
            mRules[RULE_NUMBER(RULE_ALIGN_END)] = RULE_NUMBER(0);
        }
        if (([self hasRule:RULE_START_OF] || [self hasRule:RULE_END_OF]) &&
            ([self hasRule:RULE_LEFT_OF]|| [self hasRule:RULE_RIGHT_OF])) {
            // "start"/"end" rules take precedence over "left"/"right" rules
            mRules[RULE_NUMBER(RULE_LEFT_OF)] = RULE_NUMBER(0);
            mRules[RULE_NUMBER(RULE_RIGHT_OF)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_START_OF]) {
            // "start" rule resolved to "left" or "right" depending on the direction
            mRules[RULE_NUMBER(isLayoutRtl ? RULE_RIGHT_OF : RULE_LEFT_OF)] = mRules[RULE_NUMBER(RULE_START_OF)];
            mRules[RULE_NUMBER(RULE_START_OF)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_END_OF]) {
            // "end" rule resolved to "left" or "right" depending on the direction
            mRules[RULE_NUMBER(isLayoutRtl ? RULE_LEFT_OF : RULE_RIGHT_OF)] = mRules[RULE_NUMBER(RULE_END_OF)];
            mRules[RULE_NUMBER(RULE_END_OF)] = RULE_NUMBER(0);
        }
        if (([self hasRule:RULE_ALIGN_PARENT_START] || [self hasRule:RULE_ALIGN_PARENT_END]) &&
            ([self hasRule:RULE_ALIGN_PARENT_LEFT]|| [self hasRule:RULE_ALIGN_PARENT_RIGHT])) {
            // "start"/"end" rules take precedence over "left"/"right" rules
            mRules[RULE_NUMBER(RULE_ALIGN_PARENT_LEFT)] = RULE_NUMBER(0);
            mRules[RULE_NUMBER(RULE_ALIGN_PARENT_RIGHT)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_PARENT_START]) {
            // "start" rule resolved to "left" or "right" depending on the direction
            mRules[RULE_NUMBER(isLayoutRtl ? RULE_ALIGN_PARENT_RIGHT : RULE_ALIGN_PARENT_LEFT)] = mRules[RULE_NUMBER(RULE_ALIGN_PARENT_START)];
            mRules[RULE_NUMBER(RULE_ALIGN_PARENT_START)] = RULE_NUMBER(0);
        }
        if ([self hasRule:RULE_ALIGN_PARENT_END]) {
            // "end" rule resolved to "left" or "right" depending on the direction
            mRules[RULE_NUMBER(isLayoutRtl ? RULE_ALIGN_PARENT_LEFT : RULE_ALIGN_PARENT_RIGHT)] = mRules[RULE_NUMBER(RULE_ALIGN_PARENT_END)];
            mRules[RULE_NUMBER(RULE_ALIGN_PARENT_END)] = RULE_NUMBER(0);
        }
    }
    mRulesChanged = false;
    mNeedsLayoutResolution = false;
}

- (NSMutableDictionary<NSNumber*,NSNumber*>*) getRules : (LayoutDirection) layoutDirection {
    [self resolveLayoutDirection:layoutDirection];
    return mRules;
}

- (NSMutableDictionary<NSNumber*,NSNumber*>*) getRules {
    return mRules;
}

- (void) resolveLayoutDirection : (LayoutDirection) layoutDirection {
    if ([self shouldResolveLayoutDirection:layoutDirection]) {
        [self resolveRules:layoutDirection];
    }
    // This will set the layout direction.
    [super resolveLayoutDirection:layoutDirection];
}

- (BOOL) shouldResolveLayoutDirection : (LayoutDirection) layoutDirection {
    return (mNeedsLayoutResolution || [self hasRelativeRules])
    && (mRulesChanged || layoutDirection != [self getLayoutDirection]);
}

@end

