//
//  Node.m
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/5/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@implementation Node
@synthesize view;
@synthesize dependencies;
@synthesize dependents;

- (id) init {
    if (self = [super init]){
        
    }
    return self;
}

static NSLock *POOL_LIMIT;

+ (Node*) acquire : (UIView*) view {
    //@synchronized (POOL_LIMIT) {
        Node* n = [[Node alloc] init];
        n.view = view;
        return n;
    //}
}

- (void) releaseNode {
    self.view = nil;
    [self.dependents removeAllObjects];
    [self.dependencies removeAllObjects];
}
@end
