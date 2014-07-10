//
//  SolitaireDelegate.h
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol SolitaireDelegate <NSObject>

//like other protocols there are defined somewhere else

- (BOOL)movedFan:(NSArray *)fan toTableau:(uint)i;
- (BOOL)movedCard:(Card *)c toFoundation:(uint)i;
- (void)moveStockToWaste;
- (BOOL)flipCard:(Card *)c;

@end
