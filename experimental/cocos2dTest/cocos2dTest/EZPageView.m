//
//  EZPageView.m
//  cocos2dTest
//
//  Created by Donal O'Brien on 07/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import "EZPageView.h"
#import "EZTextViewController.h"
#import "EZWord.h"


@implementation EZPageView

@synthesize idxOfLastWordLaidOut, text, words, transitionLabel;


// TEMP - for illustrating cocos2d transitions
static int sceneIdx=0;
static NSString *transitions[] = {
	@"CCTransitionFlipAngular",    
	@"CCTransitionFlipX",    
	@"CCTransitionFlipY",    
	@"CCTransitionJumpZoom",    
	@"CCTransitionMoveInB",    
	@"CCTransitionRadialCCW",    
	@"CCTransitionRadialCW",    
	@"CCTransitionRotoZoom",    
	@"CCTransitionShrinkGrow",    
	@"CCTransitionSlideInB",    
	@"CCTransitionSplitCols",    
	@"CCTransitionSplitRows",    
	@"CCTransitionTurnOffTiles",    
	@"CCTransitionZoomFlipAngular",    
	@"CCTransitionZoomFlipX",    
	@"CCTransitionZoomFlipY",
};


// TEMP - for illustrating cocos2d transitions
Class nextTransition()
{	
	// HACK: else NSClassFromString will fail
	[CCTransitionRadialCCW node];
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}


// once text has been received, create EZWord objs and layout text.
-(void)setText:(NSString *)newText
{
    [text autorelease];
    text = [newText retain];
    
    self.words = [self createWordObjsFromText:self.text];
    
    [self layoutText];
}


-(NSArray*)createWordObjsFromText:(NSString*)str
{
    //NSArray of individual words from the string
    NSArray *fullMsg = [str componentsSeparatedByString:@" "];
    
    NSMutableArray *wordsAr = [NSMutableArray array];
    
    for (NSString *str in fullMsg)
    {
        //EZWord's are created from Lucidia30.fnt which references Lucidia30.png
		EZWord *wordObj = [[EZWord alloc]initWithString:str fntFile:@"Lucidia30.fnt"];
        
        //transformations, i.e. scale, position etc. occur around the anchor point. 0,0 is bottom left. set it to top left.
        wordObj.anchorPoint = ccp(0, 1);
        
        [wordsAr addObject:wordObj];
    }
    
    return wordsAr;
}


-(void)layoutText
{    
    //chaning scenes allows you to use the fancy transitions
    CCScene *nextScene = [CCScene node];

    // pass a refernce to self, i.e. the page, so that EZTextViewController knows where to get the words
    EZTextViewController *nextPara = [[EZTextViewController alloc]initWithPage:self];    
    [nextScene addChild:nextPara];
    
    [nextPara layoutWords];
    
    [nextPara release];
    
    Class nextTrans = nextTransition();
    
    [[CCDirector sharedDirector] replaceScene:[nextTrans transitionWithDuration:0.25 scene:nextScene]];

    transitionLabel.text = [NSString stringWithFormat:@"Transition number: %i", sceneIdx];
    
}




-(void)textViewDidFinishNarratingParagraph
{
    [self layoutText];   
}


-(void)dealloc
{
    [transitionLabel release];
    [text release];
    [words release];
    
    [super dealloc];
}

@end
