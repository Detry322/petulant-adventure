//
//  DirectionsReceiver.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/29/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#ifndef Petulant_Adventure_DirectionsReceiver_h
#define Petulant_Adventure_DirectionsReceiver_h
#import "DirectionSet.h"

@protocol DirectionsReceiver

-(void)receiveDirections:(id)set;

@end

#endif
