//
//  EZParagraphTransition.h
//  cocos2dTest
//
//  Created by Donal O'Brien on 27/06/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCTransition.h"

//class for paragraph transitions

@interface EZParagraphTransition : CCTransitionFlipY 
{
    id transitionFinishDelegate;
}

@property (nonatomic, assign) id transitionFinishDelegate;

+ (id) transitionWithDuration:(ccTime)t scene:(CCScene *)s delegate:(id)d;
- (id) initWithDuration:(ccTime)t scene:(CCScene *)s delegate:(id)d;

@end
