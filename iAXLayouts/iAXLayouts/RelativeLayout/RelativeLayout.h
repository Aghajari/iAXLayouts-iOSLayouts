//
//  RelativeLayout.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/5/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import "MainLayout.h"



typedef NS_ENUM(int, RelativeLayoutRule) {
    RULE_TRUE = -1,
    /**
     * Rule that aligns a child's right edge with another child's left edge.
     */
    RULE_LEFT_OF = 0,
    /**
     * Rule that aligns a child's left edge with another child's right edge.
     */
    RULE_RIGHT_OF = 1,
    /**
     * Rule that aligns a child's bottom edge with another child's top edge.
     */
    RULE_ABOVE = 2,
    /**
     * Rule that aligns a child's top edge with another child's bottom edge.
     */
    RULE_BELOW = 3,
    /**
     * Rule that aligns a child's baseline with another child's baseline.
     */
    RULE_ALIGN_BASELINE = 4,
    /**
     * Rule that aligns a child's left edge with another child's left edge.
     */
    RULE_ALIGN_LEFT = 5,
    /**
     * Rule that aligns a child's top edge with another child's top edge.
     */
    RULE_ALIGN_TOP = 6,
    /**
     * Rule that aligns a child's right edge with another child's right edge.
     */
    RULE_ALIGN_RIGHT = 7,
    /**
     * Rule that aligns a child's bottom edge with another child's bottom edge.
     */
    RULE_ALIGN_BOTTOM = 8,
    /**
     * Rule that aligns the child's left edge with its RelativeLayout
     * parent's left edge.
     */
    RULE_ALIGN_PARENT_LEFT = 9,
    /**
     * Rule that aligns the child's top edge with its RelativeLayout
     * parent's top edge.
     */
    RULE_ALIGN_PARENT_TOP = 10,
    /**
     * Rule that aligns the child's right edge with its RelativeLayout
     * parent's right edge.
     */
    RULE_ALIGN_PARENT_RIGHT = 11,
    /**
     * Rule that aligns the child's bottom edge with its RelativeLayout
     * parent's bottom edge.
     */
    RULE_ALIGN_PARENT_BOTTOM = 12,
    /**
     * Rule that centers the child with respect to the bounds of its
     * RelativeLayout parent.
     */
    RULE_CENTER_IN_PARENT = 13,
    /**
     * Rule that centers the child horizontally with respect to the
     * bounds of its RelativeLayout parent.
     */
    RULE_CENTER_HORIZONTAL = 14,
    /**
     * Rule that centers the child vertically with respect to the
     * bounds of its RelativeLayout parent.
     */
    RULE_CENTER_VERTICAL = 15,
    /**
     * Rule that aligns a child's end edge with another child's start edge.
     */
    RULE_START_OF = 16,
    /**
     * Rule that aligns a child's start edge with another child's end edge.
     */
    RULE_END_OF = 17,
    /**
     * Rule that aligns a child's start edge with another child's start edge.
     */
    RULE_ALIGN_START = 18,
    /**
     * Rule that aligns a child's end edge with another child's end edge.
     */
    RULE_ALIGN_END = 19,
    /**
     * Rule that aligns the child's start edge with its RelativeLayout
     * parent's start edge.
     */
    RULE_ALIGN_PARENT_START = 20,
    /**
     * Rule that aligns the child's end edge with its RelativeLayout
     * parent's end edge.
     */
    RULE_ALIGN_PARENT_END = 21,
};

@interface RelativeLayout : MainLayout {
    int ignoreGravity;
}

/**
 * Defines which View is ignored when the gravity is applied. This setting has no
 * effect if the gravity is START|TOP.
 */
@property(nonatomic) int ignoreGravity;

/**
 * Describes how the child views are positioned. Defaults to START|TOP.
 *
 * Note that since RelativeLayout considers the positioning of each child
 * relative to one another to be significant, setting gravity will affect
 * the positioning of all children as a single unit within the parent.
 * This happens after children have been relatively positioned.
 */
- (void) setRelativeGravity: (int) gravity;
- (void) setHorizontalGravity :(int) horizontalGravity;
- (void) setVerticalGravity : (int) verticalGravity;

@end

@interface RelativeLayoutParams : MarginLayoutParams {
    NSMutableDictionary<NSNumber*,NSNumber*>* mRules;
    NSMutableDictionary<NSNumber*,NSNumber*>*  mInitialRules;
    int mLeft;
    int mTop;
    int mRight;
    int mBottom;
    /**
     * Whether this view had any relative rules modified following the most
     * recent resolution of layout direction.
     */
    BOOL mNeedsLayoutResolution;
    BOOL mRulesChanged;
    BOOL mIsRtlCompatibilityMode;
    
    /**
     * When true, uses the parent as the anchor if the anchor doesn't exist or if
     * the anchor's visibility is GONE.
     */
    BOOL alignWithParent;
}


@property(nonatomic) NSMutableDictionary<NSNumber*,NSNumber*>* _Nonnull mRules;
@property(nonatomic) NSMutableDictionary<NSNumber*,NSNumber*>* _Nonnull mInitialRules;
@property(nonatomic) int mLeft;
@property(nonatomic) int mTop;
@property(nonatomic) int mRight;
@property(nonatomic) int mBottom;
@property(nonatomic) BOOL mNeedsLayoutResolution;
@property(nonatomic) BOOL mRulesChanged;
@property(nonatomic) BOOL mIsRtlCompatibilityMode;
@property(nonatomic) BOOL alignWithParent;

- (id _Nonnull) initWithSource : (LayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithMarginSource : (MarginLayoutParams* _Nonnull) lp ;
- (id _Nonnull) initWithSize : (int) width : (int) height;
- (id _Nonnull) initWithRelativeSource : (RelativeLayoutParams* _Nonnull) lp ;

/**
 * Retrieves a complete list of all supported rules, where the index is the rule
 * verb, and the element value is the value specified, or "false" if it was never
 * set. If there are relative rules defined (*_START / *_END), they will be resolved
 * depending on the layout direction.
 */
- (NSMutableDictionary<NSNumber*,NSNumber*>* _Nonnull) getRules;
- (NSMutableDictionary<NSNumber*,NSNumber*>* _Nonnull) getRules : (LayoutDirection) layoutDirection;

/**
 * Returns the layout rule associated with a specific verb.
 */
- (int) getRule : (RelativeLayoutRule) verb;
/**
 * Removes a layout rule to be interpreted by the RelativeLayout.
 */
- (void) removeRule : (RelativeLayoutRule) verb;
/**
 * Adds a layout rule to be interpreted by the RelativeLayout.
 * viewID is the view tag and can't be 0!
 */
- (void) addRule : (RelativeLayoutRule) verb : (int) viewID;
/**
 * Adds a layout rule to be interpreted by the RelativeLayout.
 */
- (void) addRule : (RelativeLayoutRule) verb;
- (BOOL) hasRule : (RelativeLayoutRule) verb;

@end
