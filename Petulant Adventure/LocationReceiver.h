//
//  LocationReceiver.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/29/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#ifndef Petulant_Adventure_LocationReceiver_h
#define Petulant_Adventure_LocationReceiver_h
#import <CoreLocation/CLLocation.h>

@protocol LocationReceiver

- (void)receiveLocation:(CLLocation *)newLocation;

@end

#endif
