//
//  Card.h
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {SPADES, CLUBS, DIAMONDS, HEARTS};
enum {ACE=1, JACK=11, QUEEN=12, KING=13};

@interface Card : NSObject <NSCopying>

@property(readonly,nonatomic) NSUInteger suit;
@property(readonly,nonatomic) NSUInteger rank;
@property(assign,nonatomic) BOOL faceUp;

- (id)initWithRank:(uint)r Suit:(uint)s;
- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

- (NSString *)description;  // nice for diagnostics

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isBlack;
- (BOOL)isRed;
- (BOOL)isSameColor:(Card *)other;

+ (NSArray *)deck;

@end
