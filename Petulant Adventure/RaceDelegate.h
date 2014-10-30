//
//  RaceDelegate.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#ifndef Petulant_Adventure_RaceDelegate_h
#define Petulant_Adventure_RaceDelegate_h

typedef enum {
    MatchFailedPlayerDisconnected,
    MatchFailedPlayerQuit,
    MatchFailedPlayerUnreachable,
    MatchFailedNoDataSent,
    MatchSuccessMatchCompleted,
} MATCH_END_REASON;

@protocol RaceDelegate

-(void)matchEndedWithReason:(MATCH_END_REASON)reason;
@optional
-(void)localPlayerArrived; //for RaceViewController
-(void)lobbyReady; //for HomeViewController


@end

#endif
