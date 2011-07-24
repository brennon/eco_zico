//
//  EZParagraphTransition.h
//  cocos2dTest
//
//  Created by Brennon Bortz and Donal O'Brien on 27/06/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCTransition.h"

// Class for paragraph transitions

@protocol EZParagraphTransitionDelegate <NSObject>
- (void)paragraphTransitionDidFinish;
@end

@interface EZParagraphTransition : CCTransitionFlipY 
{
    id <EZParagraphTransitionDelegate> transitionFinishDelegate;
}

@property (nonatomic, assign) id <EZParagraphTransitionDelegate> transitionFinishDelegate;

+ (id) transitionWithDuration:(ccTime)t scene:(CCScene *)s delegate:(id)d;
- (id) initWithDuration:(ccTime)t scene:(CCScene *)s delegate:(id)d;

@end
