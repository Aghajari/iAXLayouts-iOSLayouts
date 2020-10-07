//
//  RelativeLayoutController.m
//  Demo
//
//  Created by AmirHossein Aghajari on 10/6/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RelativeLayoutController.h"
#import <iAXLayouts/iAXLayouts.h>

@interface RelativeLayoutController ()

@end

@implementation RelativeLayoutController {
    RelativeLayout *layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    layout = [[RelativeLayout alloc] init];
    layout.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30);
    [self.view addSubview:layout];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"TOP";
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.tag = 1;
    RelativeLayoutParams *lp = [[RelativeLayoutParams alloc] initWithSize:MATCH_PARENT :112];
    [lp addRule:RULE_ALIGN_PARENT_TOP];
    [lp setMargins:20 :20 :20 :20];
    [layout addSubview:label :lp];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"BOTTOM";
    label2.backgroundColor = [UIColor redColor];
    label2.textColor = [UIColor whiteColor];
    label2.tag = 2;
    RelativeLayoutParams *lp2 = [[RelativeLayoutParams alloc] initWithSize:MATCH_PARENT :112];
    [lp2 addRule:RULE_ALIGN_PARENT_BOTTOM];
    [lp2 setMargins:20 :20 :20 :20];
    [layout addSubview:label2 :lp2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"RIGHT";
    label3.backgroundColor = [UIColor darkGrayColor];
    label3.textColor = [UIColor whiteColor];
    label3.tag = 3;
    RelativeLayoutParams *lp3 = [[RelativeLayoutParams alloc] initWithSize:168 :MATCH_PARENT];
    [lp3 addRule:RULE_BELOW:1];
    [lp3 addRule:RULE_ABOVE:2];
    [lp3 addRule:RULE_ALIGN_PARENT_END];
    [lp3 setMargins:20 :0 :20 :0];
    [layout addSubview:label3 :lp3];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"LEFT";
    label4.backgroundColor = [UIColor lightGrayColor];
    label4.textColor = [UIColor whiteColor];
    label4.tag = 4;
    RelativeLayoutParams *lp4 = [[RelativeLayoutParams alloc] initWithSize:MATCH_PARENT:MATCH_PARENT];
    [lp4 addRule:RULE_BELOW:1];
    [lp4 addRule:RULE_ABOVE:2];
    [lp4 addRule:RULE_ALIGN_PARENT_START];
    [lp4 addRule:RULE_LEFT_OF:3];
    [lp4 setMargins:20 :0 :0 :0];
    [lp4 setLayoutDirection:LAYOUT_DIRECTION_RTL];
    [layout addSubview:label4 :lp4];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


