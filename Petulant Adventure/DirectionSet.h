//
//  DirectionSet.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/27/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface DirectionSet : NSObject

@property (readonly) NSString *originAddress;
@property (readonly) NSString *destinationAddress;

@property (readonly) NSArray *overviewPoints;
@property (readonly) CLLocationCoordinate2D overviewNortheastBound;
@property (readonly) CLLocationCoordinate2D overviewSouthwestBound;

@property (readonly) int steps; //Number of turns
@property (readonly) int distance; //in meters
@property (readonly) int duration; //in seconds

@property (readonly) NSArray *directionSteps;
@property (readonly) NSArray *directionManeuvers;
@property (readonly) NSArray *directionStepPoints;

+ (NSArray *)encodedPointStringToPointArray:(NSString *)encodedString andStartLatitude:(NSString *)startLatitude andStartLongitude:(NSString *)startLongitude;

- (id)initWithDirectionsData:(NSDictionary *)directionsData;

- (void)createStepFromStepArray:(NSArray *)stepArray;

@end
