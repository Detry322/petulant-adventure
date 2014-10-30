//
//  LocationManager.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationReceiver.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (CLLocation *)currentLocation;
+ (void)startTrackingLocationWithReceiver:(id<LocationReceiver>)receiver;
+ (void)stopTrackingLocation;

@property id<LocationReceiver> messageReceiver;
@property (readonly) CLLocationManager *manager;
@property (readonly) CLLocation *lastLocation;

- (id)initWithReceiver:(id<LocationReceiver>)receiver;
- (id)init;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
