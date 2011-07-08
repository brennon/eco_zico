//
//  EZWordLabel.h
//  EcoZico
//
//  Created by Brennon Bortz on 08/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLabelBMFont.h"
#import "cocos2d.h"

@class EZWord;

@interface EZWordLabel : CCLabelBMFont <CCTargetedTouchDelegate>
{
    NSString *text;
    NSNumber *seekPoint;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *seekPoint;

- (id)initWithEZWord:(EZWord *)ezWord;
- (void)startWordOnAnimation;
- (void)startWordOffAnimation;

@end
