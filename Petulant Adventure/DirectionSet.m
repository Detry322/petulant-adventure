//
//  DirectionSet.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/27/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "DirectionSet.h"

@implementation DirectionSet

//Thank you sedate-alien
//https://stackoverflow.com/questions/9217274/how-to-decode-the-google-directions-api-polylines-field-into-lat-long-points-in
+ (NSArray *)encodedPointStringToPointArray:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger i = 0;
    NSMutableArray *coordinateList = [[NSMutableArray alloc] init];
    
    float latitude = 0;
    float longitude = 0;
    while (i < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[i++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[i++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:finalLat longitude:finalLon];
        [coordinateList addObject:coordinate];
    }
    return coordinateList;
}

+ (CLLocation *)createCoordinateFromDictionary:(NSDictionary *)dictionary {
    float latitude = [dictionary[@"lat"] floatValue];
    float longitude = [dictionary[@"long"] floatValue];
    return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

- (id)init {
    return [super init];
}

- (id)initWithDirectionsData:(NSDictionary *)directionsData {
    if (self = [super init])
    {
        [self initializeOverviewWithDirectionsData:directionsData];
        [self initializeOriginAndDestinationWithDirectionsData:directionsData];
        [self initializeDirectionStepsWithDirectionsData:directionsData];
        return self;
    }
    else
    {
        return nil;
    }
}

- (void)initializeOverviewWithDirectionsData:(NSDictionary *)directionsData {
    NSString *encodedOverview = directionsData[@"overview_polyline"][@"points"];
    _overviewPoints = [DirectionSet encodedPointStringToPointArray:encodedOverview];
    _overviewNortheastBound = [DirectionSet createCoordinateFromDictionary:directionsData[@"bounds"][@"northeast"]];
    _overviewSouthwestBound = [DirectionSet createCoordinateFromDictionary:directionsData[@"bounds"][@"southwest"]];
    NSDictionary *strippedDirectionsData = directionsData[@"legs"][0];
    _distance = strippedDirectionsData[@"distance"][@"text"];
    _duration = strippedDirectionsData[@"duration"][@"text"];
}

- (void)initializeOriginAndDestinationWithDirectionsData:(NSDictionary *)directionsData {
    NSDictionary *strippedDirectionsData = directionsData[@"legs"][0];
    _originAddress = strippedDirectionsData[@"start_address"];
    _destinationAddress = strippedDirectionsData[@"end_address"];
    _originCoordinate = [DirectionSet createCoordinateFromDictionary:strippedDirectionsData[@"start_location"]];
    _destinationCoordinate = [DirectionSet createCoordinateFromDictionary:strippedDirectionsData[@"end_location"]];
}

- (void)initializeDirectionStepsWithDirectionsData:(NSDictionary *)directionsData {
    NSDictionary *strippedDirectionsData = directionsData[@"legs"][0];
    _steps = [strippedDirectionsData[@"steps"] count];
    _directionSteps = [[NSMutableArray alloc] init];
    _directionStepPoints = [[NSMutableArray alloc] init];
    [strippedDirectionsData[@"steps"] enumerateObjectsUsingBlock:^(id step, NSUInteger idx, BOOL *stop) {
        [self addStepFromStepObject:step];
    }];
}

- (void)addStepFromStepObject:(NSDictionary *)step {
    NSArray *stepPoints = [DirectionSet encodedPointStringToPointArray:step[@"polyline"][@"points"]];
    NSString *stepString = step[@"html_instructions"];
    [(NSMutableArray *)_directionSteps addObject:stepString];
    [(NSMutableArray *)_directionSteps addObject:stepPoints];
}

@end
