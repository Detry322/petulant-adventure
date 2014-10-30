//
//  GameCenterController.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "GameCenterController.h"
#import "RaceController.h"

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

#pragma mark Game Flow Control

- (void)sendLocation:(CLLocation *)location {
    [self sendData:GameCenterMessageNewLocation location:location];
}

- (void)sendDestination:(CLLocation *)destination {
    [self sendData:GameCenterMessageNewDestination location:destination];
}

- (void)sendMatchStart {
    [self sendData:GameCenterMessageStartMatch location:nil];
}

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [_containerViewController dismissModalViewControllerAnimated:YES];
    [_matchmakingDelegate matchCancelled];
    NSLog(@"User cancelled matchmaking");
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [_containerViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
    [_matchmakingDelegate matchError];
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [_containerViewController dismissModalViewControllerAnimated:YES];
    NSString *localPlayerIdentifier = [[GKLocalPlayer localPlayer] playerID];
    [RaceController createRaceWithLocalPlayerIdentifier:localPlayerIdentifier];
    _match = theMatch;
    _match.delegate = self;
    if (_match.expectedPlayerCount == 0) {
        [[RaceController sharedController] moveToLobby];
    }
    [_matchmakingDelegate matchFound];
}

- (void)findMatchWithViewController:(UIViewController *)viewController andMatchmakingDelegate:(id<MatchmakingDelegate>)delegate{
    _match = nil;
    _containerViewController = viewController;
    _matchmakingDelegate = delegate;
    [viewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc =
    [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    [_matchmakingDelegate matchSearching];
    [viewController presentModalViewController:mmvc animated:YES];
}

#pragma mark GKMatchDelegate

- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeConnectionState:(GKPlayerConnectionState)state {
    if (_match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            [[RaceController sharedController] addPlayerFromIdentifier:playerID];
            NSLog(@"Player connected!");
            
            if (theMatch.expectedPlayerCount == 0) {
                [[RaceController sharedController] moveToLobby];
            }
            
            break;
        case GKPlayerStateDisconnected:
            NSLog(@"Player disconnected!");
            [[RaceController sharedController] matchEndedWithReason:MatchFailedPlayerDisconnected];
            break;
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    if (_match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    [[RaceController sharedController] matchEndedWithReason:MatchFailedPlayerUnreachable];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    if (_match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    [[RaceController sharedController] matchEndedWithReason:MatchFailedNoDataSent];
}

- (void)sendData:(GameCenterMessageType)type location:(CLLocation *)location {
    NSUInteger len = sizeof(struct GameCenterMessage);
    GameCenterMessage *message = malloc(len);
    message->messageType = type;
    if (location) {
        message->latitude = [location coordinate].latitude;
        message->longitude = [location coordinate].longitude;
    }
    else
    {
        message->latitude = message->longitude = 0;
    }
    NSData *data = [[NSData alloc] initWithBytesNoCopy:message length:len];
    NSError *error;
    BOOL success = [_match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [[RaceController sharedController] matchEndedWithReason:MatchFailedNoDataSent];
    }
}

CLLocation* locationFromMessage(GameCenterMessage *message) {
    return [[CLLocation alloc] initWithLatitude:message->latitude longitude:message->longitude];
}

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromRemotePlayer:(NSString *)playerID {
    if (_match != theMatch) return;
    GameCenterMessage *message = [data bytes];
    switch (message->messageType)
    {
        case GameCenterMessageNewDestination:
            NSLog(@"Destination Received from (%@): <%.10f, %.10f>", playerID, message->latitude, message->longitude);
            [[RaceController sharedController] destinationUpdated:locationFromMessage(message)];
            break;
        case GameCenterMessageNewLocation:
            NSLog(@"Location Received from (%@): <%.10f, %.10f>", playerID, message->latitude, message->longitude);
            [[RaceController sharedController] playerUpdated:playerID withLocation:locationFromMessage(message)];
            break;
        case GameCenterMessageStartMatch:
            NSLog(@"Start Match command Received");
            [[RaceController sharedController] startMatch];
            break;
    }
}

@end
