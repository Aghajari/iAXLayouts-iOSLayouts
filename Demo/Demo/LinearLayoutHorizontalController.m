//
//  LinearLayoutHorizontalController.m
//  Demo
//
//  Created by AmirHossein Aghajari on 10/2/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LinearLayoutHorizontalController.h"
#import <iAXLayouts/iAXLayouts.h>


@interface LinearLayoutHorizontalController ()

@end

@implementation LinearLayoutHorizontalController {
    LinearLayout* items;
    LinearLayout* items2;
    LinearLayout* items3;
    LinearLayout* layout;
    NSInteger count;
    NSInteger count2;
    NSInteger count3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    layout = [[LinearLayout alloc] initWithOrientation:ORIENTATION_VERTICAL];
    layout.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30);
    
    [self addButton : 1];
    
    items = [[LinearLayout alloc] initWithOrientation:ORIENTATION_HORIZONTAL];
    [layout addSubview:items :[[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :100]];
    
    [self addButton : 2];
 
    items2 = [[LinearLayout alloc] initWithGravity:ORIENTATION_HORIZONTAL:[Gravity RIGHT]];
    [layout addSubview:items2 :[[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :100]];
    
    [self addButton : 3];
    
    items3 = [[LinearLayout alloc] initWithGravity:ORIENTATION_HORIZONTAL:[Gravity CENTER]];
    [layout addSubview:items3 :[[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :100]];
    
    [self.view addSubview:layout];
}

- (void) addButton : (int) btnID {
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitle:@"ADD" forState:UIControlStateNormal];
    [btn setTag:btnID];
    
    switch (btnID) {
        case 1:
            [btn setBackgroundColor:[UIColor blueColor]];
            break;
        case 2:
            [btn setBackgroundColor:[UIColor darkGrayColor]];
            break;
        case 3:
            [btn setBackgroundColor:[UIColor redColor]];
            break;
        default:
            break;
    }
    
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
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeItem:)];
    [btn addGestureRecognizer:click];
    
    LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:WRAP_CONTENT :MATCH_PARENT];
    lp1.gravity = [Gravity CENTER];
    
    switch (recognizer.view.tag) {
        case 1:
            [btn setBackgroundColor:[UIColor blueColor]];
            [lp1 setMargins:20 :20 :0 :20];
            count++;
            [btn setTitle:[@(count) stringValue] forState:UIControlStateNormal];
            [items insertSubview:btn atIndex:0 :lp1];
            break;
        case 2:
            [btn setBackgroundColor:[UIColor darkGrayColor]];
            [lp1 setMargins:0 :20 :20 :20];
            count2++;
            [btn setTitle:[@(count2) stringValue] forState:UIControlStateNormal];
            [items2 addSubview:btn :lp1];
            break;
        case 3 :
            [btn setBackgroundColor:[UIColor redColor]];
            [lp1 setMargins:10 :20 :10 :20];
            count3++;
            [btn setTitle:[@(count3) stringValue] forState:UIControlStateNormal];
            [items3 insertSubview:btn atIndex:0 :lp1];
        default:
            break;
    }
}

- (void) removeItem :(UITapGestureRecognizer *)recognizer {
    [items removeSubview:recognizer.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

