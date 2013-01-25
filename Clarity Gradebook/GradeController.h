//
//  GradeController.h
//  Clarity Gradebook
//
//  Created by tj on 12/24/12.
//  Copyright (c) 2012 Fire30. All rights reserved.
//

#import "LoginInfo.h"
#import "LoginProcessor.h"
#import "TFHpple.h"

@interface GradeController : QuickDialogController <QuickDialogStyleProvider, QuickDialogEntryElementDelegate> {
}

@property(nonatomic) LoginProcessor *processor;

+ (QRootElement *) createGradeControllerWithHTML:(LoginProcessor *)processor;
+ (QRootElement *) setProcessor:(LoginProcessor *)processor;

@end
