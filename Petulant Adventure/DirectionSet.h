//
//  DirectionSet.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/27/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "DirectionsReceiver.h"

@interface DirectionSet : NSObject

@property (readonly) NSString *originAddress;
@property (readonly) NSString *destinationAddress;
@property (readonly) CLLocation *originCoordinate;
@property (readonly) CLLocation *destinationCoordinate;

@property (readonly) NSArray *overviewPoints;
@property (readonly) CLLocation *overviewNortheastBound;
@property (readonly) CLLocation *overviewSouthwestBound;

@property (readonly) int steps; //Number of turns
@property (readonly) NSString *distance;
@property (readonly) NSString *duration;

@property (readonly) NSArray *directionSteps;
@property (readonly) NSArray *directionStepPoints;

+ (NSArray *)encodedPointStringToPointArray:(NSString *)encodedString;
+ (CLLocation *)createCoordinateFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)locationToString:(CLLocation *)location;
+ (void)getDirectionsFrom:(CLLocation *)origin to:(CLLocation *)destination receiver:(id<DirectionsReceiver>)receiver;

- (id)init;
- (id)initWithDirectionsData:(NSDictionary *)directionsData;

- (void)initializeOverviewWithDirectionsData:(NSDictionary *)directionsData;
- (void)initializeOriginAndDestinationWithDirectionsData:(NSDictionary *)directionsData;
- (void)initializeDirectionStepsWithDirectionsData:(NSDictionary *)directionsData;
- (void)addStepFromStepObject:(NSDictionary *)step;

@end
