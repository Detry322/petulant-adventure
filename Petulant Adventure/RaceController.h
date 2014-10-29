//
//  RaceController.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "DirectionSet.h"
#import "RaceDelegate.h"
#import "RaceMapViewDelegate.h"
#import "Player.h"

typedef enum {
    RaceInLobby,
    RaceInProgress,
    RaceAtFinishLine,
    RaceFinished,
    RaceError
} RACE_STATE;

@interface RaceController : NSObject

@property (readonly) BOOL isHost; //host only picks destination, everyone sends data to everyone
@property (readonly) RACE_STATE state;
@property (readonly) CLLocation *destination;
@property (readonly) DirectionSet *directions;
@property (readonly) NSMutableDictionary *players;
@property (readonly) NSDate *startDate;
@property (readonly) NSString *localPlayerIdentifier;
@property id<RaceMapViewDelegate> raceMapViewDelegate;
@property id<RaceDelegate> raceDelegate;

+ (RaceController *)sharedController;
+ (void)createRace:(BOOL)isHost withLocalPlayerIdentifier:(NSString *)localPlayerIdentifier andDelegate:(id<RaceDelegate>)raceDelegate andMapViewDelegate:(id<RaceMapViewDelegate>)raceMapViewDelegate;
+ (void)cleanUp;

- (id)init:(BOOL)isHost withLocalPlayerIdentifier:(NSString *)localPlayerIdentifier;

- (void)startMatch;

- (BOOL)isMatchReady;
- (BOOL)didMatchStart;
- (BOOL)didAllPlayersArrive;

- (BOOL)addPlayerFromIdentifier:(NSString *)identifier;

- (NSTimeInterval)playerCompletionTime:(NSString *)playerIdentifier;

- (void)destinationUpdated:(CLLocation *)newDestination;
- (BOOL)playerUpdated:(NSString *)playerIdentifier withLocation:(CLLocation *)newLocation;
- (void)playerDisconnected:(NSString *)playerIdentifier;

- (void)matchEndedWithReason:(MATCH_END_REASON)reason;

@end
