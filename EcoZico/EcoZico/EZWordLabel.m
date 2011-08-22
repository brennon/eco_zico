//
//  EZWordLabel.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 08/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZWordLabel.h"
#import "EZWord.h"

@implementation EZWordLabel

@synthesize text, seekPoint;

- (id)initWithEZWord:(EZWord *)ezWord
{
    self = [super initWithString:ezWord.text fntFile:@"Lucidia30.fnt"];
    if(self)
    {
        self.text = [ezWord.text copy];
        self.seekPoint = [ezWord.seekPoint copy];
        self.color = ccc3(0,0,0);
        self.anchorPoint = ccp(0, 1);
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

-(void)startWordOnAnimation
{
    self.color = ccc3(255,0,0);
}


-(void)startWordOffAnimation
{
    [self runAction:[CCTintTo actionWithDuration:0.333 red:0 green:0 blue:0]];
}



-(void)dealloc
{
    [text release];
    text = nil;
    [seekPoint release];
    seekPoint = nil;
    [super dealloc];
}

@end
