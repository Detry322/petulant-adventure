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

+ (void)createRaceWithLocalPlayerIdentifier:(NSString *)localPlayerIdentifier{
    controller = [[RaceController alloc] initWithLocalPlayerIdentifier:localPlayerIdentifier];
}

+ (void)cleanUp {
    controller = nil;
}

- (id)initWithLocalPlayerIdentifier:(NSString *)localPlayerIdentifier{
    if (self = [super init])
    {
        _players = [[NSMutableDictionary alloc] init];
        _state = RacePreLobby;
        _localPlayerIdentifier = localPlayerIdentifier;
        [self addPlayerFromIdentifier:localPlayerIdentifier];
        return self;
    }
    return nil;
}

- (void)determineHost {
    NSArray *playerIdentifiers = [_players allKeys];
    NSArray *sortedPlayerIdentifiers = [playerIdentifiers sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _isHost = [_localPlayerIdentifier isEqualToString:[sortedPlayerIdentifiers firstObject]];
}

- (void)moveToLobby {
    _state = RaceInLobby;
    [self determineHost];
    [LocationManager startTrackingLocationWithReceiver:self];
}

- (void)startMatch {
    _state = RaceInProgress;
    _startDate = [NSDate date];
    [DirectionSet getDirectionsFrom:[LocationManager currentLocation] to:_destination receiver:self];
    if (_isHost)
        [[GameCenterController sharedController] sendMatchStart];
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
    if (_isHost)
        [[GameCenterController sharedController] sendDestination:newDestination];
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
            [self matchEndedWithReason:MatchSuccessMatchCompleted];
        }
    }
    [_raceMapViewDelegate redrawPlayer:playerIdentifier];
    return didCreatePlayer;
}

- (void)playerDisconnected:(NSString *)playerIdentifier{
    [self matchEndedWithReason:MatchFailedPlayerDisconnected];
}

- (BOOL)addPlayerFromIdentifier:(NSString *)identifier {
    if (_players[identifier])
        return NO;
    Player *newPlayer = [[Player alloc] initWithIdentifier:identifier];
    _players[identifier] = newPlayer;
    return YES;
}

- (void)matchEndedWithReason:(MATCH_END_REASON)reason {
    _state = (reason == MatchSuccessMatchCompleted) ? RaceFinished : RaceError;
    [_raceDelegate matchEndedWithReason:reason];
}

#pragma mark DirectionReceiver
- (void)receiveDirections:(id)set {
    _directions = set;
}
#pragma mark LocationReceiver
- (void)receiveLocation:(CLLocation *)newLocation {
    [self playerUpdated:_localPlayerIdentifier withLocation:newLocation];
    [[GameCenterController sharedController] sendLocation:newLocation];
}

@end
