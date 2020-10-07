//
//  ViewController.m
//  Demo
//
//  Created by AmirHossein Aghajari on 10/2/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import "ViewController.h"
#import <iAXLayouts/iAXLayouts.h>

#import "LinearLayoutVerticalController.h"
#import "LinearLayoutHorizontalController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self presentViewController:[[LinearLayoutHorizontalController alloc] init] animated:YES completion:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
