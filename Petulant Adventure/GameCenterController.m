//
//  GameCenterController.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "GameCenterController.h"
#import <GameKit/GameKit.h>

@implementation GameCenterController

//Since this is a singleton class, there needs to be a shared instance
static GameCenterController *controller = nil;
+ (GameCenterController *)sharedController {
    if (!controller) {
        controller = [[GameCenterController alloc] init];
    }
    return controller;
}

-(void)authStateChanged {
    _loggedIn = [GKLocalPlayer localPlayer].isAuthenticated;
}

-(void)authUser {
    if (!_loggedIn) {
        NSLog(@"Authenticating...");
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    }
    else
    {
        NSLog(@"Already Authed");
    }
}

@end
