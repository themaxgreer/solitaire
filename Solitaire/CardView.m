//
//  CardView.m
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import "CardView.h"
#import "Card.h"
#import "SolitaireView.h"

@implementation CardView {
    //taken from TouchFoo from previous class
    CGPoint touchStartPoint;
    CGPoint startCenter;
}
- (id)initWithFrame:(CGRect)frame andCard:(Card *)c {
    if (self = [super initWithFrame:frame]) {
        //add a nil condition here so I can easily use static
        //"empty" image
        if (c != nil){
            _card = c;
            //here I used description to populate the cards
            _frontImage = [UIImage imageNamed:[c description]];
        } else {
            // place the empty image for the card
            _frontImage = [CardView emptyImage];
        }
        //like in TouchFoo
        self.opaque = NO;
    }
    return self;
}

- (NSUInteger)hash {
    return [_card hash];
}

// Static image references

+ (UIImage *)backImage
{
    static UIImage *backImage = nil;
    if (backImage == nil) {
        backImage = [UIImage imageNamed:@"back-blue-150-3"];
    }
    return backImage;
}

+ (UIImage *)emptyImage {
    static UIImage *emptyImage = nil;
    if (emptyImage == nil) {
        emptyImage = [UIImage imageNamed:@"empty"];
    }
    return emptyImage;
}

- (BOOL)isEqual:(id)other {
    //checker to see what part of the set of face up
    //cards there are
    if (!([other class] == [Card class])) {
         return [_card isEqual:[other card]];
    }
    return [_card isEqual:other];
}

- (void)drawRect:(CGRect)rect {
    if (_card == nil || _card.faceUp)
        //if card is nil draw empty image
        //if face up it is in play
        [self.frontImage drawInRect:rect];
    else
        //It isn't in play so we draw the backImage
        [[CardView backImage] drawInRect:rect];
}

#pragma mark - Touch Code

/*  -TouchFoo had touches handled in parentview
    -So I had touches handled in parent view
    -Since cards are children of the Solitaire board view
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [(SolitaireView *)[self superview] touchesBegan:touches withEvent:event andView:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [(SolitaireView *)[self superview] touchesMoved:touches withEvent:event andView:self];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [(SolitaireView *)[self superview] touchesCancelled:touches withEvent:event andView:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [(SolitaireView *)[self superview] touchesEnded:touches withEvent:event andView:self];
}


@end
