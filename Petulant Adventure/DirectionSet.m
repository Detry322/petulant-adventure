//
//  DirectionSet.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/27/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "DirectionSet.h"

@implementation DirectionSet

+ (NSArray *)encodedPointStringToPointArray:(NSString *)encodedString {
    return nil;
}

+ (CLLocation *)createCoordinateFromDictionary:(NSDictionary *)dictionary {
    return nil;
}

- (id)initWithDirectionsData:(NSDictionary *)directionsData {
    if (self = [super init])
    {
        NSString *encodedOverview = directionsData[@"overview_polyline"][@"points"];
        _overviewPoints = [DirectionSet encodedPointStringToPointArray:encodedOverview];
        _overviewNortheastBound = [DirectionSet createCoordinateFromDictionary:directionsData[@"bounds"][@"northeast"]];
        _overviewSouthwestBound = [DirectionSet createCoordinateFromDictionary:directionsData[@"bounds"][@"southwest"]];
        
        NSDictionary *strippedDirectionsData = directionsData[@"legs"][0];
        
        _originAddress = strippedDirectionsData[@"start_address"];
        _destinationAddress = strippedDirectionsData[@"end_address"];
        _originCoordinate = [DirectionSet createCoordinateFromDictionary:strippedDirectionsData[@"start_location"]];
        _destinationCoordinate = [DirectionSet createCoordinateFromDictionary:strippedDirectionsData[@"end_location"]];
        
        _steps = [strippedDirectionsData[@"steps"] count];
        _distance = strippedDirectionsData[@"distance"][@"text"];
        _duration = strippedDirectionsData[@"duration"][@"text"];
        
        _directionSteps = [[NSMutableArray alloc] init];
        _directionStepPoints = [[NSMutableArray alloc] init];
        [strippedDirectionsData[@"steps"] enumerateObjectsUsingBlock:^(id step, NSUInteger idx, BOOL *stop) {
            NSArray *stepPoints = [DirectionSet encodedPointStringToPointArray:step[@"polyline"][@"points"]];
            NSString *stepString = step[@"html_instructions"];
            [(NSMutableArray *)_directionSteps addObject:stepString];
            [(NSMutableArray *)_directionSteps addObject:stepPoints];
        }];
        return self;
    }
    else
    {
        return nil;
    }
}

- (void)addStepFromStepObject:(NSDictionary *)stepObject {
    
}

@end
