//
//  FrameLayoutController.m
//  Demo
//
//  Created by AmirHossein Aghajari on 10/3/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FrameLayoutController.h"
#import <iAXLayouts/iAXLayouts.h>



@interface FrameLayoutController () 

@end

@implementation FrameLayoutController {
    FrameLayout *layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    layout = [[FrameLayout alloc] init];
    layout.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30);
    [self.view addSubview:layout];
    
    // TOP
    UILabel *header = [[UILabel alloc] init];
    [header setText:@"FrameLayout Top"];
    [header setTextColor:[UIColor whiteColor]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setBackgroundColor:[UIColor blueColor]];
    LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp1 setMargins:20 :20 :20 :20];
    lp1.gravity = [Gravity TOP];
    lp1.extraHeight = 20;
    [layout addSubview:header :lp1];
    
    // BOTTOM
    UILabel *footer = [[UILabel alloc] init];
    [footer setText:@"FrameLayout Bottom"];
    [footer setTextColor:[UIColor whiteColor]];
    [footer setTextAlignment:NSTextAlignmentCenter];
    [footer setBackgroundColor:[UIColor darkGrayColor]];
    LinearLayoutParams *lp2 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp2 setMargins:20 :20 :20 :20];
    lp2.gravity = [Gravity BOTTOM];
    lp2.extraHeight = 20;
    [layout addSubview:footer :lp2];
    [self.view addSubview:layout];
    
    // CENTER
    UILabel *center = [[UILabel alloc] init];
    [center setText:@"FrameLayout Center"];
    [center setTextColor:[UIColor whiteColor]];
    [center setTextAlignment:NSTextAlignmentCenter];
    [center setBackgroundColor:[UIColor redColor]];
    LinearLayoutParams *lp3 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp3 setMargins:20 :20 :20 :20];
    lp3.gravity = [Gravity CENTER];
    lp3.extraHeight = 20;
    [layout addSubview:center :lp3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

