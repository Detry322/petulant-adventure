//
//  RaceController.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "RaceController.h"

@implementation RaceController

static RaceController *controller = nil;
+ (RaceController *)sharedController {
    return controller;
}

+ (void)createRace:(BOOL)isHost withLocalPlayerIdentifier:(NSString *)localPlayerIdentifier andDelegate:(id<RaceDelegate>)raceDelegate andMapViewDelegate:(id<RaceMapViewDelegate>)raceMapViewDelegate{
    controller = [[RaceController alloc] init:isHost withLocalPlayerIdentifier:localPlayerIdentifier];
    [controller setRaceDelegate:raceDelegate];
    [controller setRaceMapViewDelegate:raceMapViewDelegate];
}

+ (void)cleanUp {
    controller = nil;
}

- (id)init:(BOOL) isHost withLocalPlayerIdentifier:(NSString *)localPlayerIdentifier{
    if (self = [super init])
    {
        _players = [[NSMutableDictionary alloc] init];
        _state = RaceInLobby;
        _isHost = isHost;
        _localPlayerIdentifier = localPlayerIdentifier;
        [self addPlayerFromIdentifier:localPlayerIdentifier];
        return self;
    }
    return nil;
}


- (void)startMatch {
    _state = RaceInProgress;
    _startDate = [NSDate date];
    //@TODO
}

- (BOOL)didMatchStart {
    return _state == RaceInProgress || _state == RaceAtFinishLine || _state == RaceFinished;
}

- (BOOL)isMatchReady {
    NSEnumerator *enumerator = [_players keyEnumerator];
    Player *localPlayer = _players[_localPlayerIdentifier];
    id key;
    while (key = [enumerator nextObject])
    {
        if (![localPlayer isCloseToOtherPlayer:_players[key]])
            return NO;
    }
    return YES;
}

- (BOOL)didAllPlayersArrive {
    NSEnumerator *enumerator = [_players keyEnumerator];
    id key;
    while (key = [enumerator nextObject])
    {
        if (![_players[key] arrived])
            return NO;
    }
    return YES;
}

- (void)destinationUpdated:(CLLocation *)newDestination {
    _destination = newDestination;
    [_raceMapViewDelegate redrawDestination];
}

- (NSTimeInterval)playerCompletionTime:(NSString *)playerIdentifier {
    Player *player = _players[playerIdentifier];
    if ([player arrived])
        return [[player arrivedTime] timeIntervalSinceDate:_startDate];
    return -1.0;
}

- (BOOL)playerUpdated:(NSString *)playerIdentifier withLocation:(CLLocation *)newLocation {
    BOOL didCreatePlayer = [self addPlayerFromIdentifier:playerIdentifier];
    Player *player = _players[playerIdentifier];
    [player setLocation:newLocation];
    if ([self didMatchStart] && [player isAtDestination:_destination])
    {
        [player arrive];
        if ([playerIdentifier isEqualToString:_localPlayerIdentifier])
        {
            [_raceDelegate localPlayerArrived];
            _state = RaceAtFinishLine;
        }
        if ([self didAllPlayersArrive])
        {
            //End the match here
        }
    }
    [_raceMapViewDelegate redrawPlayer:playerIdentifier];
    return didCreatePlayer;
}

- (void)playerDisconnected:(NSString *)playerIdentifier{
    [self matchEndedWithReason:PlayerDisconnected];
}

- (BOOL)addPlayerFromIdentifier:(NSString *)identifier {
    if (_players[identifier])
        return NO;
    Player *newPlayer = [[Player alloc] initWithIdentifier:identifier];
    _players[identifier] = newPlayer;
    return YES;
}

- (void)matchEndedWithReason:(MATCH_END_REASON)reason {
    [_raceDelegate matchEndedWithReason:reason];
}

@end
