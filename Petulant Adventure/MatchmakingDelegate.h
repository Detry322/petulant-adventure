//
//  MatchmakingDelegate.h
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/29/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#ifndef Petulant_Adventure_MatchmakingDelegate_h
#define Petulant_Adventure_MatchmakingDelegate_h

@protocol MatchmakingDelegate

- (void)matchSearching;
- (void)matchCancelled;
- (void)matchError;
- (void)matchFound;

@end


#endif
