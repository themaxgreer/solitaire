//
//  SolitaireViewController.m
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import "SolitaireViewController.h"
#import "CardView.h"

@interface SolitaireViewController ()

@end

@implementation SolitaireViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //make a new game
    self.game = [[Solitaire alloc] init];
    
    //initialize the game
    [self.game freshGame];
    
    //setters for the model and the delegate
    self.gameView.game = self.game;
    self.gameView.delegate = self;
}

- (void)viewDidUnload
{
    [self setGameView:nil];
    self.game = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)newGamePressed:(id)sender {
    [self.game freshGame];
    self.gameView.game = self.game;
    //update the view
    [self.gameView setNeedsDisplay];
}

/* Maybe this logic should be placed elsewhere ...
   but it does correspond to the solitaire delegate */

#pragma mark - Delegate methods

- (BOOL)flipCard:(Card *)c
{
    if ([_game canFlipCard:c]) {
        //update the model
        [_game didFlipCard:c];
        return YES;
    }
    return NO;
}

- (BOOL)movedCard:(Card *)c toFoundation:(uint)i
{
    if ([_game canDropCard:c onFoundation:i]) {
        //update the model
        [_game didDropCard:c onFoundation:i];
        return YES;
    }
    return NO;
}

- (BOOL)movedFan:(NSArray *)fan toTableau:(uint)i
{
    if ([_game canDropFan:fan onTableau:i]) {
        //update the model
        [_game didDropFan:fan onTableau:i];
        return YES;
    }
    return NO;
}

- (void)moveStockToWaste
{
    if ([_game canDealCard]) {
        //update the model
        [_game didDealCard];
    }
    else {
        //cards can't be dealt
        //so update the stock
        [_game collectWasteCardsIntoStock];
    }
}



@end
