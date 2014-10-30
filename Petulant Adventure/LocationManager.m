

//
//  LocationManager.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

static LocationManager *instance = nil;
static CLLocationManager *manager = nil;

+ (CLLocation *)currentLocation {
    return [instance lastLocation];
}

+ (void)startTrackingLocationWithReceiver:(id<LocationReceiver>)receiver {
    if (!instance)
        instance = [[LocationManager alloc] initWithReceiver:receiver];
    if (!manager)
        manager = [[CLLocationManager alloc] init];
    [manager setDelegate:instance];
    [manager setDesiredAccuracy:kCLLocationAccuracyBest];
    [manager setDistanceFilter:5];
    [manager startUpdatingLocation];
}

+ (void)stopTrackingLocation {
    [manager stopUpdatingLocation];
    instance = nil;
    manager = nil;
}

- (id)initWithReceiver:(id<LocationReceiver>)receiver {
    if (self = [super init])
    {
        [self setMessageReceiver:receiver];
        return self;
    }
    return nil;
}

- (id)init {
    return [super init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations lastObject];
    _lastLocation = loc;
    [_messageReceiver receiveLocation:loc];
}

@end
