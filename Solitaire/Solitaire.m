//
//  Solitaire.m
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import "Solitaire.h"

@implementation Solitaire {
    NSMutableArray *stock_;
    NSMutableArray *waste_;
    NSMutableArray *foundation_[NUM_FOUNDATIONS];
    NSMutableArray *tableau_[NUM_TABLEAUS];
}

- (id)init {
    self = [super init];
    if (self) {
        [self freshGame];
    }
    return self;
}

- (void)freshGame {
    //initialize the deck and shuffle it
    NSMutableArray *deck = (NSMutableArray *) [Card deck];
    [Solitaire shuffle:deck];
    
    // put cards from deck into tableaus
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        tableau_[i] = [[NSMutableArray alloc] init];
        for (int j = 0; j <= i; j++) {
            [tableau_[i] addObject:[deck objectAtIndex:0]];
            //make sure that it is removed from deck
            [deck removeObjectAtIndex:0];
        }
    }
    //Make sure the last card in each tableau is faceU
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        ((Card *) [tableau_[i] lastObject]).faceUp = YES;
    }
    
    //initialize the foundations
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        foundation_[i] = [[NSMutableArray alloc] init];
    }
    //initialize waste, place remaining cards into stock
    waste_ = [[NSMutableArray alloc] init];
    stock_ = deck;
    [self didDealCard];
}

- (BOOL)gameWon {
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        if (foundation_[i].count != 13)
            return NO; //not a full suit
    }
    return YES;
}

- (NSArray *)stock {
    return stock_;
}

- (NSArray *)waste {
    return waste_;
}

- (NSArray *)foundation:(uint)i {
    return foundation_[i];
}

- (NSArray *)foundationWithCard:(Card *)card {
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        if ([foundation_[i] containsObject:card])
            return foundation_[i];
    }
    //not in any foundation
    return nil;
}

- (NSArray *)tableau:(uint)i {
    return tableau_[i];
}

- (NSArray *)tableauWithCard:(Card *)card {
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        if ([tableau_[i] containsObject:card])
            return tableau_[i];
    }
    //not in any tableau
    return nil;
}

- (NSArray *)arrayWithCard:(Card *)card {
    NSArray *array = [self foundationWithCard:card];
    
    //if it isn't in a foundation, array will be nil
    // then check a tableau
    if (array== nil) {
        array = [self tableauWithCard:card];
    }
    //if it isn't in a tableu, array will be nil
    // then check waste, make sure it isn't the top card
    if (array == nil && [waste_ lastObject] == card) {
        array = waste_;
    }
    //lastly check stock
    if (array == nil && [stock_ lastObject] == card) {
        array = stock_;
    }
    return array;
}

- (NSArray *)fanBeginningWithCard:(Card *)card {
    NSArray *fan = nil;
    NSArray *array = [self arrayWithCard:card];
 
    //Grab the stack
    if (card.faceUp && array != nil) {
        //find the index
        int index = [array indexOfObject:card];
        NSRange range = NSMakeRange(index, [array count] - index);
        
        //return the subarray with the range
        fan = [array subarrayWithRange:range];
    }
        
    return fan;
}

- (BOOL)canDropCard:(Card *)c onFoundation:(int)i {
    NSArray *foundation = [self foundation:i];
    if ([c rank] == ACE && [foundation count] == 0)
        return YES;
    
    Card *o = (Card *) [foundation lastObject];
    if (([c rank] == [o rank] + 1) && ([c suit] == [o suit]))
        return YES;
    
    return NO;
}

- (void)didDropCard:(Card *)c onFoundation:(int)i {
    NSMutableArray *stack = (NSMutableArray *) [self arrayWithCard:c];
    [stack removeObject:c];
    [foundation_[i] addObject:c];
}

- (BOOL)canDropCard:(Card *)c onTableau:(int)i {
    NSArray *t = [self tableau:i];
    
    if ([c rank] == KING && [t count] == 0)
        return YES;
    
    Card *o = (Card *) [t lastObject];
    if (([c rank] == [o rank] - 1) && ![c isSameColor:o])
        return YES;
    
    return NO;
}

- (void)didDropCard:(Card *)c onTableau:(int)i {
    NSMutableArray *stack = (NSMutableArray *) [self arrayWithCard:c];
    [stack removeObject:c];
    [tableau_[i] addObject:c];
}

- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i {
    Card *c = (Card *) [cards objectAtIndex:0];
    return [self canDropCard:c onTableau:i];
}

- (void)didDropFan:(NSArray *)cards onTableau:(int)i {
    NSMutableArray *stack = (NSMutableArray *) [self arrayWithCard:[cards objectAtIndex:0]];
    
    for (Card *c in cards) {
        [stack removeObject:c];
        [tableau_[i] addObject:c];
    }
}

- (BOOL)canFlipCard:(Card *)c {
    NSArray *t = [self arrayWithCard:c];
    if (t != nil && [t lastObject] == c)
        return YES;
    return NO;
}

- (void)didFlipCard:(Card *)c {
    if ([stock_ containsObject:c]) {
        [self didDealCard];
    } else {
        c.faceUp = YES;   
    }
}

- (BOOL)canDealCard {
    if([stock_ count] > 0){
        return YES;
    }
    return NO;
}

- (void)didDealCard {
    //To keep order get the first element
    Card *c = [stock_ objectAtIndex:0];
    [stock_ removeObject:c];
    [waste_ addObject:c];
    //make sure the card is faceUP!!!!
    c.faceUp = YES;
}

- (void)collectWasteCardsIntoStock {
    for (Card *c in waste_) {
        //this will make all of the cards not face up
        //and ready in stock
        c.faceUp = NO;
    }
    //clean up after ourselves and remove everything from waste
    [stock_ addObjectsFromArray:waste_];
    [waste_ removeAllObjects];
}

+ (void)shuffle:(NSMutableArray *)deck {
    /* Stack overflow suggestion
     http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
     Couldn't think of the correct logic for this
     */
    NSUInteger count = [deck count];
    for (uint i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [deck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
