//
//  SolitaireView.h
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solitaire.h"
#import "SolitaireDelegate.h"

@interface SolitaireView : UIView

@property (strong,nonatomic) Solitaire *game;
@property (strong,nonatomic) NSMutableDictionary *cards;
@property (weak,nonatomic) IBOutlet id <SolitaireDelegate> delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;

- (void)addCardToSubview:(Card *)c;
- (void)layoutCards;

@end
