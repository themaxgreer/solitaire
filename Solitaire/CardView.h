//
//  CardView.h
//  Solitaire
//
//  Created by Max Greer on 5/4/13.
//  Copyright (c) 2013 Max Greer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

@property (strong, nonatomic) UIImage *frontImage;
@property (strong, nonatomic) Card *card;

- (id)initWithFrame:(CGRect)frame andCard:(Card *)c;

- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

+ (UIImage *)backImage; //static
+ (UIImage *)emptyImage; //static

@end
