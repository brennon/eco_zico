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
#import "EZParagraphTransition.h"


@implementation EZPageView

@synthesize idxOfLastWordLaidOut, text, words, transitionLabel, player, playPauseBut, skipParaBut;


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
    
    //TEMP
    self.words = [self createWordObjsFromText:self.text];
    
    paraNum++;
        
    //layout text the first time
    CCScene *nextScene = [CCScene node];
    textVC = [[EZTextViewController alloc]initWithPage:self];    
    [nextScene addChild:textVC];    
    [textVC release];
    
    [[CCDirector sharedDirector] replaceScene:nextScene];

    [textVC layoutWords];
    
    [self loadAudioForPage:2];
}


//TEMP
-(NSArray*)createWordObjsFromText:(NSString*)str
{
    //NSArray of individual words from the string
    NSArray *fullMsg = [str componentsSeparatedByString:@" "];
    
    NSMutableArray *wordsAr = [NSMutableArray array];
    
    //narration
    NSString *seekpoints = @"0.239 0.452 0.612 0.933 1.073 1.457 1.92 2.058 2.725 3.146 3.895 4.238 4.49 4.629 5.481 5.59 5.748 6.304 6.452 6.616 7.094 7.174 7.265 7.774 7.85 8.053 9.22 9.941 10.109 10.479 11.463 11.681 11.993 12.19 13.187 13.479 14.03 14.26 14.553 14.669 15.195 15.3 15.418 16.456 16.612 16.91 17.086 17.322 17.608 17.885 19.223 19.351 19.959 20.174 20.435 20.564 21.1 21.294 22.658 22.783 22.03 23.404 25.022 25.239 25.46 25.748 25.83 26.297 26.424 26.714 26.797 27.667 28.061 28.376 28.469 29.286 29.703 29.96 30.107 31.152 31.376";
    
    NSArray *seekpointAr = [seekpoints componentsSeparatedByString:@" "];        
    
    for (int i = 0; i < [fullMsg count]; i++)
    {
        //EZWord's are created from Lucidia30.fnt which references Lucidia30.png
		EZWord *wordObj = [[EZWord alloc]initWithString:[fullMsg objectAtIndex:i] fntFile:@"Lucidia30.fnt"];
        
        //transformations, i.e. scale, position etc. occur around the anchor point. 0,0 is bottom left. set it to top left.
        wordObj.anchorPoint = ccp(0, 1);
        
        wordObj.seekPoint = (NSTimeInterval)[[seekpointAr objectAtIndex:i] doubleValue];
        
        [wordsAr addObject:wordObj];
    }
    
    return wordsAr;
}


-(void)layoutText
{    
    //chaning scenes allows you to use the fancy transitions
    CCScene *nextScene = [CCScene node];

    // pass a refernce to self, i.e. the page, so that EZTextViewController knows where to get the words        
    textVC = [[EZTextViewController alloc]initWithPage:self];    
    [nextScene addChild:textVC];        
    [textVC release];
    
    //turn off interactions for the transition
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    //do the transition
    [[CCDirector sharedDirector] replaceScene:[EZParagraphTransition transitionWithDuration:0.25 scene:nextScene delegate:self]];
    
    //draw the paragraph
    [textVC layoutWords];
    
    paraNum++;
    paraNum%= 3;
}


-(void)loadAudioForPage:(int)pageNum
{
    //narration
    //load sound file
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"zico_audio-page_02" ofType: @"wav"];  
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: NULL];
    [fileURL release];           
    
    self.player = newPlayer;    
    [newPlayer release];        
    
    [player prepareToPlay];    
    [player setDelegate: self];
    
}


-(IBAction)playPause:(id)sender
{
    //pause / resume timers and narration animations
    [textVC playPause];
        
    //pause
    if([player isPlaying])
    {        
        NSLog(@"pv pause");
        [player pause];
    }
    //play
    else 
    {    
        NSLog(@"pv play");
        [player play];
    }
}


//for debugging - allows to skip through paragraphs in order to observer transitions more quickly.
int firstParaSkip = 10;
int secondParaSkip = 20;
int thirdParaSkip = 30;

-(IBAction)skipPara:(id)sender
{    
    [self playPause:self];
        
//    paraNum++;
    
    switch (paraNum) 
    {
        case 0:
            [self audioPlayerDidFinishPlaying:nil successfully:YES];//hack!!
            [textVC setWordPositionForTime:firstParaSkip];
            break;
        case 1:
            [self layoutText];
            [textVC setWordPositionForTime:secondParaSkip];
            break;
        case 2:
            [self layoutText];
            [textVC setWordPositionForTime:thirdParaSkip];
            break;
        default:
            break;
    }
}
   



-(void)textViewDidFinishNarratingParagraph
{
    NSLog(@"pv textViewDidFinishNarratingParagraph");
    
    [player pause];

    [self layoutText];    
}


#pragma mark - EZParagraphTransition delegate method


-(void)paragraphTransitionDidFinish
{
    NSLog(@"pv paragraphTransitionDidFinish");
    
    //re-enable interactions after the transition
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    [self playPause:self];    
}


#pragma mark - AVPlayer delegate methods

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *) player successfully:(BOOL) completed
{    
    if (completed == YES) 
    {    
        idxOfLastWordLaidOut = 0;
        
        paraNum = 0;
 
        [[words lastObject] runWordOffAnim];
                        
        //TEMP
        self.text = @"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. Another could make fireballs by clicking his fingers. One time, he'd thrown a fireball at the teacher. She hadn't been very happy about it. But Zico had yet to discover his superpower. It was so embarrassing. The other kids at school made fun of him. \"Zico has no superpower, Zico has no superpower\", they chanted.";        
    }    
}






-(void)dealloc
{
    [transitionLabel release];
    [text release];
    [words release];
    
	[player release];
    [playPauseBut release];
    [skipParaBut release];
    
    [super dealloc];
}

@end
