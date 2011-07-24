//
//  EZParagraphTransition.m
//  cocos2dTest
//
//  Created by Brennon Bortz and Donal O'Brien on 27/06/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZParagraphTransition.h"


@implementation EZParagraphTransition

@synthesize transitionFinishDelegate;

- (void)finish
{
    [super finish];    
    [transitionFinishDelegate paragraphTransitionDidFinish];
}


+ (id)transitionWithDuration:(ccTime)t scene:(CCScene *)s delegate:(id)d
{
    return [[[self alloc] initWithDuration:t scene:s delegate:d] autorelease];
}


- (id)initWithDuration:(ccTime)t scene:(CCScene *)s delegate:(id)d
{
    transitionFinishDelegate = d;    
    return [super initWithDuration:t scene:s];
}


@end
