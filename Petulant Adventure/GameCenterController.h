//
//  GameCenterController.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MatchmakingDelegate.h"

typedef enum {
    GameCenterMessageNewLocation = 0,
    GameCenterMessageNewDestination,
    GameCenterMessageStartMatch,
} GameCenterMessageType;

typedef struct GameCenterMessage {
    GameCenterMessageType messageType;
    double latitude;
    double longitude;
} GameCenterMessage;

@interface GameCenterController : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (readonly) BOOL loggedIn;
@property (retain) UIViewController *containerViewController;
@property (retain) GKMatch *match;
@property id<MatchmakingDelegate> matchmakingDelegate;

+ (GameCenterController *)sharedController;

- (void)authUser;
- (void)authStateChanged;

- (void)findMatchWithViewController:(UIViewController *)viewController andMatchmakingDelegate:(id<MatchmakingDelegate>)delegate;

#pragma mark Game Flow Control

- (void)sendLocation:(CLLocation *)location;
- (void)sendDestination:(CLLocation *)destination;
- (void)sendMatchStart;

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController;
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error;
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch;

#pragma mark GKMatchDelegate

- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeConnectionState:(GKPlayerConnectionState)state;
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error;
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error;

#pragma mark Data Control
- (void)sendData:(GameCenterMessageType)type location:(CLLocation *)location;
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromRemotePlayer:(NSString *)playerID;


@end
