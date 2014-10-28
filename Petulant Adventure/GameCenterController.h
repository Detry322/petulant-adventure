//
//  GameCenterController.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCenterController : NSObject

@property (readonly) BOOL loggedIn;

+ (GameCenterController *)sharedController;

-(void)authUser;
-(void)authStateChanged;


@end
