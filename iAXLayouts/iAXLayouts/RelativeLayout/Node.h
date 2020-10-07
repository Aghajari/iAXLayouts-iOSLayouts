//
//  Node.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/5/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

/**
 * A node in the dependency graph. A node is a view, its list of dependencies
 * and its list of dependents.
 *
 * A node with no dependent is considered a root of the graph.
 */

#import <UIKit/UIKit.h>

@interface Node : NSObject {
    UIView* view;
    NSMapTable<Node*,NSObject*> *dependents;
    NSMapTable<NSNumber*,Node*> *dependencies;
}

/**
 * The view representing this node in the layout.
 */
@property(nonatomic) UIView* view;
/**
 * The list of dependents for this node; a dependent is a node
 * that needs this node to be processed first.
 */
@property(nonatomic) NSMapTable<Node*,NSObject*> *dependents;
/**
 * The list of dependencies for this node.
 */
@property(nonatomic) NSMapTable<NSNumber*,Node*>* dependencies;

+ (Node*) acquire : (UIView*) view;
- (void) releaseNode;

@end
