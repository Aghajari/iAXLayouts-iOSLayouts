//
//  DependencyGraph.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/5/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DependencyGraph.h"

@implementation DependencyGraph
@synthesize mNodes;
@synthesize mKeyNodes;
@synthesize mRoots;

- (id) init {
    if (self = [super init]){
        mRoots = [[NSMutableArray alloc] init];
        mKeyNodes = [[NSMapTable alloc] init];
        mNodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) clear {
    NSMutableArray<Node*>* nodes = self.mNodes;
    for (Node* node in nodes){
        [node releaseNode];
    }
    [nodes removeAllObjects];
    [mKeyNodes removeAllObjects];
    [mRoots removeAllObjects];
}

- (void) add : (UIView*) view {
    NSInteger viewID = view.tag;
    Node* node = [Node acquire:view];
    if (viewID != 0) {
        [mKeyNodes setObject:node forKey:[NSNumber numberWithInteger:view.tag]];
    }
    [mNodes addObject:node];
}

- (NSMutableArray<UIView*>*) getVerticalSortedViews : (NSMutableArray<UIView*>*) sorted{
    NSMutableArray<NSNumber*>* rules = [[NSMutableArray alloc] initWithObjects:
                                 [NSNumber numberWithInt:RULE_ABOVE],
                                 [NSNumber numberWithInt:RULE_BELOW],
                                 [NSNumber numberWithInt:RULE_ALIGN_BASELINE],
                                 [NSNumber numberWithInt:RULE_ALIGN_TOP],
                                 [NSNumber numberWithInt:RULE_ALIGN_BOTTOM], nil];
    return [self getSortedViews:sorted :rules];
}

- (NSMutableArray<UIView*>*) getHorizontalSortedViews : (NSMutableArray<UIView*>*) sorted{
    NSMutableArray<NSNumber*>* rules = [[NSMutableArray alloc] initWithObjects:
                                 [NSNumber numberWithInt:RULE_LEFT_OF],
                                 [NSNumber numberWithInt:RULE_RIGHT_OF],
                                 [NSNumber numberWithInt:RULE_ALIGN_LEFT],
                                 [NSNumber numberWithInt:RULE_ALIGN_RIGHT],
                                 [NSNumber numberWithInt:RULE_START_OF],
                                 [NSNumber numberWithInt:RULE_END_OF],
                                 [NSNumber numberWithInt:RULE_ALIGN_START],
                                 [NSNumber numberWithInt:RULE_ALIGN_END], nil];
    return [self getSortedViews:sorted :rules];
}

- (NSMutableArray<UIView*>*) getSortedViews : (NSMutableArray<UIView*>*) sorted : (NSMutableArray<NSNumber*>*) rules{
    NSMutableArray<Node*>* roots =  [self findRoots:rules];
    int index = 0;
    Node* node;
    BOOL hasNode = YES;
    while (hasNode) {
        node = [roots lastObject];
        if (node!=nil){
            UIView* view = node.view;
            NSInteger key = view.tag;
            [sorted insertObject:view atIndex:index];
            index++;
            NSMapTable<Node*,NSObject*> *dependents = node.dependents;
            for (Node* dependent in dependents) {
                NSMapTable<NSNumber*,Node*> *dependencies = dependent.dependencies;
                [dependencies removeObjectForKey:[NSNumber numberWithInteger:key]];
                if (dependencies.count == 0) {
                    [roots addObject:dependent];
                }
            }
            [roots removeObject:node];
        }else{
            hasNode = NO;
        }
    }
    if (index < sorted.count) {
        @throw([NSException exceptionWithName:NSParseErrorException reason:@"Circular dependencies cannot exist in RelativeLayout" userInfo:nil]);
    }
    return sorted;
}

- (NSMutableArray<Node*>*) findRoots : (NSMutableArray<NSNumber*>*) rulesFilter{
    // Find roots can be invoked several times, so make sure to clear
    // all dependents and dependencies before running the algorithm
    for (Node* node in mNodes){
        [node.dependencies removeAllObjects];
        [node.dependents removeAllObjects];
    }
    // Builds up the dependents and dependencies for each node of the graph
    for (Node* node in mNodes) {
        RelativeLayout* layout = (RelativeLayout*) node.view.superview;
        RelativeLayoutParams* layoutParams = (RelativeLayoutParams*) [layout getChildLayoutParams:node.view];
        NSMutableDictionary<NSNumber*,NSNumber*>* rules = layoutParams.mRules;
        int rulesCount = [[NSNumber numberWithUnsignedInteger:rulesFilter.count] intValue];
        // Look only the the rules passed in parameter, this way we build only the
        // dependencies for a specific set of rules
        for (int j = 0; j < rulesCount; j++) {
            int rule = [rules[[rulesFilter objectAtIndex:j]] intValue];
            if (rule > 0 || [self isValid:rule]) {
                // The node this node depends on
                Node* dependency = [mKeyNodes objectForKey:[NSNumber numberWithInt:rule]];
                // Skip unknowns and self dependencies
                if (dependency == nil || [dependency isEqual:node]) {
                    continue;
                }
                // Add the current node as a dependent
                [dependency.dependents setObject:self forKey:node];
                // Add a dependency to the current node
                [node.dependencies setObject:dependency forKey:[NSNumber numberWithInt:rule]];
            }
        }
    }
    NSMutableArray<Node*>* roots = mRoots;
    [roots removeAllObjects];
    // Finds all the roots in the graph: all nodes with no dependencies
     for (Node* node in mNodes) {
         if (node.dependencies.count == 0) {
             [roots addObject:node];
         }
    }
    return roots;
}
                        
- (BOOL) isValid : (int) rid {
   return rid != -1 && (rid & 0xff000000) != 0 && (rid & 0x00ff0000) != 0;
}
@end
