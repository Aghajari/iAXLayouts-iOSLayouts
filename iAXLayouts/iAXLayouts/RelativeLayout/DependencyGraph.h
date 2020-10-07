//
//  DependencyGraph.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/5/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//
#import "Node.h"
#import "RelativeLayout.h"

@interface DependencyGraph : NSObject {
    NSMutableArray<Node*> *mNodes;
    NSMapTable<NSNumber*,Node*> *mKeyNodes;
    NSMutableArray<Node*> *mRoots;
}

/**
 * List of all views in the graph.
 */
@property(nonatomic) NSMutableArray<Node*>* mNodes;
/**
 * List of nodes in the graph. Each node is identified by its
 * view id (tag)
 */
@property(nonatomic) NSMapTable<NSNumber*,Node*>* mKeyNodes;
/**
 * Temporary data structure used to build the list of roots
 * for this graph.
 */
@property(nonatomic) NSMutableArray<Node*>* mRoots;

/**
 * Clears the graph.
 */
- (void) clear;

/**
 * Adds a view to the graph.
 *
 * @param view The view to be added as a node to the graph.
 */
- (void) add : (UIView*) view;

- (NSMutableArray<UIView*>*) getVerticalSortedViews : (NSMutableArray<UIView*>*) sorted;
- (NSMutableArray<UIView*>*) getHorizontalSortedViews : (NSMutableArray<UIView*>*) sorted;

/**
 * Builds a sorted list of views. The sorting order depends on the dependencies
 * between the view. For instance, if view C needs view A to be processed first
 * and view A needs view B to be processed first, the dependency graph
 * is: B -> A -> C. The sorted array will contain views B, A and C in this order.
 *
 * @param sorted The sorted list of views. The length of this array must
 *        be equal to getChildCount().
 * @param rules The list of rules to take into account.
 */
- (NSMutableArray<UIView*>*) getSortedViews : (NSMutableArray<UIView*>*) sorted : (NSMutableArray<NSNumber*>*) rules;

/**
 * Finds the roots of the graph. A root is a node with no dependency and
 * with [0..n] dependents.
 *
 * @param rulesFilter The list of rules to consider when building the
 *        dependencies
 *
 * @return A list of node, each being a root of the graph
 */
- (NSMutableArray<Node*>*) findRoots : (NSMutableArray<NSNumber*>*) rulesFilter;

@end

