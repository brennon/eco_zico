//
//  EZWordLabel.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 08/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLabelBMFont.h"
#import "cocos2d.h"

@class EZWord;

@interface EZWordLabel : CCLabelBMFont <CCTargetedTouchDelegate>

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *seekPoint;

- (id)initWithEZWord:(EZWord *)ezWord;
- (void)startWordOnAnimation;
- (void)startWordOffAnimation;

@end
