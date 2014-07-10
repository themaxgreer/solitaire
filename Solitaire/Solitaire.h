//
//  Solitaire.h
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

#define NUM_FOUNDATIONS 4
#define NUM_TABLEAUS 7

@interface Solitaire : NSObject

- (id)init; //Create new Solitaire game model object.

- (void)freshGame; //Reshuffle and redeal cards to start a new game.
- (BOOL)gameWon; //All cards have successfully reached a foundation stack.

- (NSArray *)stock; //Face down cards in stock.
- (NSArray *)waste; //Face up card in waste.

- (NSArray *)foundation:(uint)i;  //Cards on foundation 0 ≤ i < 4.
- (NSArray *)foundationWithCard:(Card *)card; 

- (NSArray *)tableau:(uint)i; //Cards on tableau 0 ≤ i < 7.
- (NSArray *)tableauWithCard:(Card *)card; //Tableau with a given card
- (NSArray *)arrayWithCard:(Card *)card; //Array with a given card

- (NSArray *)fanBeginningWithCard:(Card *)card; //Array of face up cards stacked on top of each other.

- (BOOL)canDropCard:(Card *)c onFoundation:(int)i; //Can the given cards be legally dropped on the ith foundation?
- (void)didDropCard:(Card *)c onFoundation:(int)i; //The user did drop the given card on on the ith foundation.

- (BOOL)canDropCard:(Card *)c onTableau:(int)i;  //Can the given card be legally dropped on the i tableau?
- (void)didDropCard:(Card *)c onTableau:(int)i; //The user did drop the card on the on the i tableau.

- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i; //Can the given stack of cards be legally dropped on the i tableau?
- (void)didDropFan:(NSArray *)cards onTableau:(int)i; //A stack of cards has been dropped in the i tableau.

- (BOOL)canFlipCard:(Card *)c; //Can user legally flip the card over?
- (void)didFlipCard:(Card *)c; //The user did flip the card over.

- (BOOL)canDealCard; // move top card from stock to waste
- (void)didDealCard;  //Uses did move the top stack card to the waste.

- (void)collectWasteCardsIntoStock; //Move all waste cards back to the stock (they’re all flipped over – order is maintained).

+ (void)shuffle:(NSMutableArray *)deck;

@end
