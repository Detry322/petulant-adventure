//
//  RaceMapViewDelegate.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#ifndef Petulant_Adventure_RaceMapViewDelegate_h
#define Petulant_Adventure_RaceMapViewDelegate_h

@protocol RaceMapViewDelegate

-(void)redrawPlayer:(NSString *)identifier;
@optional
-(void)redrawDestination; //For RaceLobbyViewController

@end

#endif
