//
//  EZWord.m
//  cocos2dTest
//
//  Created by Donal O'Brien on 06/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import "EZWord.h"


@implementation EZWord

@synthesize word, seekPoint;


-(void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}


- (CGRect)rectInPixels
{
	CGSize s = [self boundingBoxInPixels].size;
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}


- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
//	if (state != kPaddleStateUngrabbed) return NO;
	if ( ![self containsTouchLocation:touch] ) return NO;
//	
//	state = kPaddleStateGrabbed;
	return YES;
}


-(void)dealloc
{
    [word release];
    
    [super dealloc];
}

@end
