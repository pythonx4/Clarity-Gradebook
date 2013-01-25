//
//  LoginProcessor.h
//  Clarity Gradebook
//
//  Created by tj on 12/23/12.
//  Copyright (c) 2012 Fire30. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import  "ASIFormDataRequest.h"
#import  "TFHpple.h"

@interface LoginProcessor : NSObject
{
@private
    NSString *_password;
    NSString *_login;
    NSString *_school;
    BOOL _autologin;

}

@property(strong) NSString *username;
@property(strong) NSString *password;
@property(strong) NSString *school;
@property(nonatomic) int quarter;
@property(strong) NSString *studentId;
@property(strong) NSString *AuthKey;
@property(strong) NSArray *gradeData;
@property(strong) NSMutableDictionary *classData;
@property(strong) NSString *periodString;
@property(strong) NSString *responseString;

@property(nonatomic) BOOL autologin;
@property(nonatomic) BOOL loggedIn;

@property (nonatomic, readonly) NSString *getUsername;
- (NSDictionary *) getClassData:(NSNumber *)count;
- (NSArray *) getGradeData:(NSString *)data;
@property (nonatomic, readonly) Boolean login;

@end
