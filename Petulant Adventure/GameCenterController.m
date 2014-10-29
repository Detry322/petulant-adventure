//
//  GameCenterController.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "GameCenterController.h"

@implementation GameCenterController

//Since this is a singleton class, there needs to be a shared instance
static GameCenterController *controller = nil;
+ (GameCenterController *)sharedController {
    if (!controller) {
        controller = [[GameCenterController alloc] init];
    }
    return controller;
}

- (void)authStateChanged {
    _loggedIn = [GKLocalPlayer localPlayer].isAuthenticated;
}

- (void)authUser {
    if (!_loggedIn) {
        NSLog(@"Authenticating...");
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    }
    else
    {
        NSLog(@"Already Authed");
    }
}



#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [_containerViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"User cancelled matchmaking");
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [_containerViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [_containerViewController dismissModalViewControllerAnimated:YES];
    _match = theMatch;
    _match.delegate = self;
    if (_match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        //TODO
    }
}

- (void)findMatchWithViewController:(UIViewController *)viewController{
    _match = nil;
    _containerViewController = viewController;
    [viewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc =
    [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [viewController presentModalViewController:mmvc animated:YES];
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromRemotePlayer:(NSString *)playerID {
    if (_match != theMatch) return;
    //This is really complicated and will take time.
}

- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeConnectionState:(GKPlayerConnectionState)state {
    if (_match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
            }
            
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            //TODO
            break;
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    if (_match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    //TODO
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    if (_match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    //TODO
}

@end
