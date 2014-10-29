//
//  GameCenterController.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterController : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (readonly) BOOL loggedIn;
@property (retain) UIViewController *containerViewController;
@property (retain) GKMatch *match;

+ (GameCenterController *)sharedController;

- (void)authUser;
- (void)authStateChanged;

- (void)findMatchWithViewController:(UIViewController *)viewController;


#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController;
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error;
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch;

#pragma mark GKMatchDelegate

- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromRemotePlayer:(NSString *)playerID;
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeConnectionState:(GKPlayerConnectionState)state;
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error;
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error;


@end
