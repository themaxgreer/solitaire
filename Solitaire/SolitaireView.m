//
//  SolitaireView.m
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import "SolitaireView.h"
#import "Card.h"
#import "CardView.h"


#define MARGIN 20

@implementation SolitaireView {
    CGFloat _w;
    CGFloat _h;
    CGFloat _s;
    CGFloat _f;
    
    CGPoint touchStartPoint;
    CGPoint startCenter;
    
    CGFloat gameOffset;

    CardView *gameFoundation[NUM_FOUNDATIONS];
    CardView *gameTableau[NUM_TABLEAUS];
    CardView *gameStock;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.game = _game;
        self.cards = _cards;
        self.delegate = _delegate;
    }
    return self;
}

- (void)awakeFromNib {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    _w = ((width - 2*MARGIN)/7.0) - 2.0; //w and h are properties of the cards
    _h = (height - 2*MARGIN)/6.5; //need .5 here due to cards on top of each other
    _s = _h/8.0;  //s is the space between the cards and foundation bottom
    _f = _h/4.0; //f is the space between the cards
    
    CGFloat tabY = MARGIN + _h + _s;
    //CGFloat offSet = _w + 4;
    gameOffset = _w + 4;
    
    //set up foundations and tableaus
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        CGFloat foundationX = MARGIN + (((i+3) * gameOffset) - 2.0);
        //place an "empty" card there
        CardView *v = [[CardView alloc] initWithFrame:CGRectMake(foundationX, MARGIN, _w, _h) andCard:nil];
        gameFoundation[i] = v;
    }
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tabX = MARGIN + (i * gameOffset - 2.0);
        //place an "empty" card there
        CardView *v = [[CardView alloc] initWithFrame:CGRectMake(tabX, tabY, _w, _h) andCard:nil];
        gameTableau[i] = v;
    }
    
    //place a blank card in the stock
    gameStock = [[CardView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _h) andCard:nil];
}

- (void)addBoardToSubview {
    //add the stock, foundations and waste to solitaireView
    [self addSubview:gameStock];
    
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        [self addSubview:gameFoundation[i]];
    }
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        [self addSubview:gameTableau[i]];
    }
}
//below is a setter for the game
- (void)setGame:(Solitaire *)game {
    //NSLog(@"game: setter got called");
    _game = game;
    _cards = [[NSMutableDictionary alloc] init]; 
    
    /* make sure this is called
    * to restore the order of subviews
    */
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addBoardToSubview];
    
    /* for the game go through each type of card
     and add it to the games subview */
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        for (Card *c in [_game tableau:i]) {
            //Note: must place in correct tableau
            [self addCardToSubview:c];
            [self layoutCards];
        }
    }
    
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        for (Card *c in [_game foundation:i]) {
            //Note: must place in correct tableau
            [self addCardToSubview:c];
            [self layoutCards];
        }
    }
    //lastly place the stock and waste in correct subview
    for(Card *c in _game.stock) {
        [self addCardToSubview:c];
        [self layoutCards];
    }
    
    for (Card *c in _game.waste) {
        [self addCardToSubview:c];
        [self layoutCards];
    }

    //[self computeLayoutSubviews];
}
- (void)addCardToSubview:(Card *)c {
    //function to place card in the correct subview
    CardView *v = [[CardView alloc]
                   initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _h)
                   andCard:c];
    //update the dictionary
    [_cards setObject:v forKey:c];
    //put in Solitaire subview
    [self addSubview:v];
}
//last but not least
- (void)layoutCards {
    
    //animation with block taken from TouchFoo
    //except deal with all of the different views
    
    [UIView animateWithDuration:0.2 animations:^{
        CardView *cardView;
        for (int i = _game.stock.count - 1; i >= 0; i--) {
            Card *c = [_game.stock objectAtIndex:i];
            cardView = [_cards objectForKey:c];
            cardView.frame = CGRectMake(MARGIN, MARGIN, _w, _h);
            [cardView setNeedsDisplay]; //update view
            [self bringSubviewToFront:cardView]; //move view
        }
        
        /* Most of this logic is like in the awakeFromNib
         * Albeit with new "views" to populate */
        
        CGFloat wasteX = MARGIN + _w + 2.0;
        CGFloat wasteY = MARGIN;
        for (Card *c in _game.waste) {
            cardView = [_cards objectForKey:c];
            cardView.frame = CGRectMake(wasteX, wasteY, _w, _h);
            [self bringSubviewToFront:cardView];
        }
        
        //go through tableaus
        for (int i = 0; i < NUM_TABLEAUS; i++) {
            CGFloat tabX = MARGIN + ((i * (gameOffset)) - 2.0);
            NSArray *tab = [_game tableau:i];
            //inner loop instead of making doing j = 0, j++ logic
            for (int j = 0; j < [tab count]; j++) {
                Card *c = [tab objectAtIndex:j];
                CGFloat tabY = MARGIN + _h + _s + (j * _f);
                cardView = [_cards objectForKey:c];
                cardView.frame = CGRectMake(tabX, tabY, _w, _h);
                [self bringSubviewToFront:cardView];
            }
        }
        
        for (int i = 0; i < NUM_FOUNDATIONS; i++) {
            CGFloat foundationX = MARGIN + (((i+3) * gameOffset) - 2.0);
            for (Card *c in [_game foundation:i]) {
                //iterate though foundations
                cardView = [_cards objectForKey:c];
                cardView.frame = CGRectMake(foundationX, MARGIN, _w, _h);
                [self bringSubviewToFront:cardView];
            }
        }
    }];
    
    [self setNeedsDisplay]; //update board
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view {
    //NSLog(@"============================");
    //NSLog(@"SolitaireView: touchesBegan:withEvent:andView:");
    touchStartPoint = [[touches anyObject] locationInView:self];
    startCenter = view.center;
    
    Card *card = [(CardView *)view card];
    
    if ([_game.stock containsObject:card] || (CardView *)view == gameStock) {
        //if got here move the stock card to waste
        [_delegate moveStockToWaste];
        //calculate new top of the waste
        Card *newTopCardInWaste = (Card *) [_game.waste lastObject];
        //update view
        [(CardView *)[_cards objectForKey:newTopCardInWaste] setNeedsDisplay];
        
        //do the same for stock, since we are pulling cards from the front
        //the lastObject is the correct logic
        Card *newStock = (Card *) [_game.stock lastObject];
        //update view
        [(CardView *)[_cards objectForKey:newStock] setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view {
    //NSLog(@"============================");
    //NSLog(@"SolitaireView: touchesMoved:withEvent:andView:");
    
    
    //taken from touchFoo MainView
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint delta = CGPointMake(touchPoint.x - touchStartPoint.x, touchPoint.y - touchStartPoint.y);
    CGPoint newCenter = CGPointMake(startCenter.x + delta.x, startCenter.y + delta.y);
    
    Card *card = [(CardView *)view card];
    
    NSArray *fan = [_game fanBeginningWithCard:card];
    
    if (fan == nil && _game.waste.lastObject == card) {
        //if fan is nil then there is no fan with the card
        //if waste's last object is card then you can move the card
        CardView *cardView = [_cards objectForKey:card];
        cardView.center = CGPointMake(newCenter.x, newCenter.y);
        [self bringSubviewToFront:cardView];
    } else {    
        for (int i = 0; i < fan.count; i++) {
            Card *c = [fan objectAtIndex:i];
            CardView *cardView = [_cards objectForKey:c];
            cardView.center = CGPointMake(newCenter.x, newCenter.y + (i * _f)); //f is the space between the cards
            [self bringSubviewToFront:cardView];
        }
    }
}

#pragma mark - Touch Code

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view {
    //never gets called
    //NSLog(@"Touches Cancelled!");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view {
    //NSLog(@"============================");
    //NSLog(@"SolitaireView: touchesBegan:withEvent:andView:");
    
    Card *card = [(CardView *)view card];
    
    if (!card.faceUp) {
        if ([_delegate flipCard:card]) {
            //NSLog(@"touchesEnded: Delegate: \"You may flip a card!\"");
            [(CardView *)[_cards objectForKey:card] setNeedsDisplay];
        }
        [self layoutCards];
    } else {
        //most of this logic I had to as Ryan for
        BOOL dropped = NO;
        
        NSArray *fan = [_game fanBeginningWithCard:card];
        
        if (fan == nil) {
            //if fan is nil then we must create an array for further checking
            fan = [[NSArray alloc] initWithObjects:card, nil];
        }
        for (int i = 0; i < NUM_TABLEAUS; i++) {
            //check tableaus
            NSArray *tab = [_game tableau:i];
            for (int j = 0; j < [tab count]; j++) {
                CardView *other = [_cards objectForKey:[tab objectAtIndex:j]];
                
                if (view == other) continue; //same view
                
                if (CGRectIntersectsRect(view.frame, other.frame)) {
                    //NSLog(@"touchesEnded: moved onto tableau");
                    if ([_delegate movedFan:fan toTableau:i]) {
                        //NSLog(@"touchesEnded: Delegate: \"You may move a fan\"");
                        //toggle changed to exit condition
                        dropped = YES;
                    }
                }
            }
        }
        if (!dropped){
            for (int i = 0; i < NUM_TABLEAUS; i++) {
                CardView *other = gameTableau[i];
                if (CGRectIntersectsRect(view.frame, other.frame)) {
                    if ([_delegate movedFan:fan toTableau:i]) {
                        //NSLog(@"touchesEnded: Delegate: \"You may move onto tableau\"");
                        //toggle changed to exit condition
                        dropped = YES;
                    }
                }

            }
        }
        if (!dropped) {
           //if we hit here we only have one card and it is going to the foundation
            if ([fan count] == 1) { //make sure that it is only one card
                for (int i = 0; i < NUM_FOUNDATIONS; i++) {
                    //go through the foundations and see it is the one it hit
                    CardView *foundView = gameFoundation[i];
                    if (CGRectIntersectsRect(view.frame, foundView.frame)) {
                        if ([_delegate movedCard:card toFoundation:i]) {
                            //NSLog(@"touchesEnded: Delegate: \"You may move onto foundation\"");
                            //toggle changed to exit coundtion
                            dropped = YES;
                        }
                    }
                }
            }
        }
    }
    [self layoutCards];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
