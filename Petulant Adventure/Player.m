//
//  Player.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithIdentifier:(NSString *)identifier {
    if (self = [super init])
    {
        _identifier = identifier;
        _arrived = NO;
        return self;
    }
    return nil;
}

- (BOOL)isAtDestination:(CLLocation *)destination {
    double distance = [destination distanceFromLocation:_location];
    return distance < 10;
}

- (BOOL)isCloseToOtherPlayer:(Player *)otherPlayer {
    return [self isAtDestination:[otherPlayer location]];
}

- (void)arrive {
    _arrived = YES;
    _arrivedTime = [NSDate date];
}

@end
