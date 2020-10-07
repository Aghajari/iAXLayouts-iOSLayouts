//
//  ViewController.m
//  Demo
//
//  Created by AmirHossein Aghajari on 10/2/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import "LinearLayoutVerticalController.h"
#import <iAXLayouts/iAXLayouts.h>


@interface LinearLayoutVerticalController ()

@end

@implementation LinearLayoutVerticalController {
    LinearLayout* items;
    LinearLayout* layout;
    NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    layout = [[LinearLayout alloc] initWithOrientation:ORIENTATION_VERTICAL];
    layout.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30);
    
    [self addButton];
    
    items = [[LinearLayout alloc] initWithOrientation:ORIENTATION_VERTICAL];
    [layout addSubview:items :[[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :MATCH_PARENT]];
    
    [self.view addSubview:layout];
}

- (void) addButton {
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitle:@"add" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addItem:)];
    [btn addGestureRecognizer:click];
    
    LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    lp1.leftMargin = 20;
    lp1.rightMargin = 20;
    lp1.gravity = [Gravity CENTER];
    lp1.extraHeight = 20;
    [layout addSubview:btn :lp1];
}

- (void) addItem :(UITapGestureRecognizer *)recognizer {
    UIButton* btn = [[UIButton alloc] init];
    count++;
    [btn setTitle:[@[@"Item", @(count)] componentsJoinedByString:@" "] forState:UIControlStateNormal];
    [btn setTitle:@"Tap to delete!" forState:UIControlStateHighlighted];
    [btn setBackgroundColor:[UIColor blueColor]];
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeItem:)];
    [btn addGestureRecognizer:click];
    
    LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp1 setMargins:20 :20 :20 :0];
    lp1.gravity = [Gravity CENTER];
    [items insertSubview:btn atIndex:0 :lp1];
}

- (void) removeItem :(UITapGestureRecognizer *)recognizer {
    [items removeSubview:recognizer.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

