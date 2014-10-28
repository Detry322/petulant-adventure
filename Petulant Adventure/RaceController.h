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

typedef enum {
    RaceInLobby,
    RaceInProgress,
    RaceAtFinishLine,
    RaceFinished
} RACE_STATE;

@interface RaceController : NSObject

@property (readonly) BOOL isHost; //host only picks destination, everyone sends data to everyone
@property (readonly) RACE_STATE state;
@property (readonly) CLLocation *destination;
@property (readonly) DirectionSet *directions;
@property (readonly) NSDictionary *players;


@end
