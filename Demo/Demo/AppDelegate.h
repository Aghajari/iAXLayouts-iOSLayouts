//
//  AppDelegate.h
//  Demo
//
//  Created by AmirHossein Aghajari on 10/2/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

