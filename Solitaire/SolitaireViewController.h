//
//  SolitaireViewController.h
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolitaireView.h"
#import "Solitaire.h"
#import "SolitaireDelegate.h"

@interface SolitaireViewController : UIViewController <SolitaireDelegate>

@property (strong,nonatomic) Solitaire *game;
@property (weak, nonatomic) IBOutlet SolitaireView *gameView;

- (IBAction)newGamePressed:(id)sender;

@end
