//
//  ArcLayoutController.m
//  Demo
//
//  Created by AmirHossein Aghajari on 10/3/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArcLayoutController.h"
#import <iAXLayouts/iAXLayouts.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ArcLayoutController ()

@end

@implementation ArcLayoutController {
    ArcLayout *layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    layout = [[ArcLayout alloc] init];
    layout.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30);
    layout.arcRadius = 168;
    layout.axisRadius = 120;
    layout.arc = [[ArcType alloc] initWithGravity:[Gravity RIGHT]];
    
    
    [self addLabel :@"A" :UIColorFromRGB(0x03a9f4)];
    [self addLabel :@"B" :UIColorFromRGB(0x03a9f4)];
    [self addLabel :@"C" :UIColorFromRGB(0x03a9f4)];
    [self addLabel :@"D" :UIColorFromRGB(0x03a9f4)];
    [self addLabel :@"E" :UIColorFromRGB(0x03a9f4)];
    [self addLabel :@"F" :UIColorFromRGB(0x03a9f4)];
    
    [self.view addSubview:layout];
}

- (void) addLabel : (NSString*) text : (UIColor*) color {
    UILabel* label = [[UILabel alloc] init];
    label.layer.cornerRadius = 24;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    
    ArcLayoutParams *lp = [[ArcLayoutParams alloc] initWithSize:48 :48];
    [layout addSubview:label :lp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

