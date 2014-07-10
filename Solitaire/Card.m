//
//  Card.m
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import "Card.h"

@implementation Card

- (id)initWithRank:(uint)r Suit:(uint)s {
    self = [super init];
    if (self) {
        _rank = r;
        _suit = s;
        _faceUp = NO;
    }
    return self;
}

- (NSUInteger)hash {
    return (_rank - 1)*4 + _suit; // return 0 to 51
}

- (BOOL)isEqual:(id)other {
    return _rank == [other rank] && _suit == [other suit];
}

- (NSString *)description {
    /* Using this to return string for images as well */
    NSString *s;
    NSString *r;
    switch (_suit) {
        case SPADES:
            s = @"spades";
            break;
        case CLUBS:
            s = @"clubs";
            break;
        case DIAMONDS:
            s = @"diamonds";
            break;
        case HEARTS:
            s = @"hearts";
            break;
        default:
            s = @"empty";
            break;
    }
    switch (_rank) {
        case ACE:
            r = @"a";
            break;
        case JACK:
            r = @"j";
            break;
        case QUEEN:
            r = @"q";
            break;
        case KING:
            r = @"k";
            break;
        default:
            r = [NSString stringWithFormat:@"%d", _rank];
            break;
    }
    //NSLog(@"%@", [NSString stringWithFormat:@"%@-%@-150", s, r]);
    if (s == nil) {
        //helper test to make sure that we have a card representation
        return [NSString stringWithFormat:@"empty"];
    } else {
        return [NSString stringWithFormat:@"%@-%@-150", s, r];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    Card *copy = [[Card allocWithZone:zone] initWithRank:_rank Suit:_suit];
    return copy;
}

- (BOOL)isBlack {
    return _suit == SPADES || _suit == CLUBS;
}

- (BOOL)isRed {
    return _suit == DIAMONDS || _suit == HEARTS;
}

- (BOOL)isSameColor:(Card *)other {
    // _suit == [other suit]; wrong logic since there are 2 suits per color
    return ([self isBlack] && [other isBlack]) || ([self isRed] && [other isRed]);
}

+ (NSArray *)deck {
    /*  using enums to make it easier on myself
     and be consistent */
    NSMutableArray *deck = [[NSMutableArray alloc] init];
    for (uint i = ACE; i <= KING; i++) {
        for (uint j = SPADES; j <= HEARTS; j++) {
            Card *card = [[Card alloc] initWithRank:i Suit:j];
            [deck addObject:card];
        }
    }
    return deck;
}


@end
