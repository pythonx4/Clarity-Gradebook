//
//  AppDelegate.h
//  Clarity Gradebook
//
//  Created by tj on 12/22/12.
//  Copyright (c) 2012 Fire30. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginProcessor.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginProcessor *processor;

@end
