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


-(id) initWithString:(NSString*)theString fntFile:(NSString*)fntFile
{
    if((self = [super initWithString:theString fntFile:fntFile]))
    {
        word = [theString copy];
        
        color_ = ccc3(0,0,0);
    }
    
    return self;
}

#pragma mark - Touch handling mehods

-(void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}


- (CGRect)rectInPixels
{
	CGSize s = [self boundingBoxInPixels].size;
    return CGRectMake(-(s.width * self.anchorPoint.x) , -(s.height * self.anchorPoint.y), s.width, s.height);
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
    NSLog(@"%@", [self string]);
	return YES;
}


#pragma mark - Animation mehods

-(void)runWordOnAnim
{
    self.color = ccc3(255,0,0);
}


-(void)runWordOffAnim
{
    self.color = ccc3(0,0,0);
}



-(void)dealloc
{
    [word release];    
    [super dealloc];
}

@end
