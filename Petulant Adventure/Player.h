//
//  Player.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface Player : NSObject

@property CLLocation *location;
@property (readonly) NSString *identifier;
@property BOOL arrived;
@property NSDate *arrivedTime;

- (id)initWithIdentifier:(NSString *)identifier;
- (BOOL)isAtDestination:(CLLocation *)destination;
- (BOOL)isCloseToOtherPlayer:(Player *)otherPlayer;
- (void)arrive;

@end
