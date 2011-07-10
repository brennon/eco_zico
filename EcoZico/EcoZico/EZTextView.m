//
//  EZTextView.m
//  EcoZico
//
//  Created by Brennon Bortz on 01/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZTextView.h"
#import "cocos2d.h"
#import "EZPage.h"
#import "EZWord.h"
#import "EZWordLabel.h"
#import "EZTextViewScene.h"
#import "CCLabelBMFont.h"
#import "EZParagraphTransition.h"

/*** BEGIN NEED TO CULL ***/
@interface EZTextView ()
-(void)layoutText;
@end
/*** END NEED TO CULL ***/

@implementation EZTextView

@synthesize ezWordLabels, ezTextViewScene;

/*** BEGIN NEED TO CULL ***/
@synthesize idxOfLastWordLaidOut, transitionLabel, player, playPauseBut, skipParaBut, text;
/*** END NEED TO CULL ***/

# pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    [ezWordLabels release];
    ezWordLabels = nil;
    [ezTextViewScene release];
    ezTextViewScene = nil;
    [super dealloc];
}

- (void)loadEZPageWordsAsCCLabelBMFonts:(EZPage *)ezPage
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[ezPage.words count]];
    
    for (int i = 0; i < [ezPage.words count]; i++) {
        EZWord *word = [ezPage.words objectAtIndex:i];
        EZWordLabel *wordLabel = [word generateEZWordLabel];
        [tempArray insertObject:wordLabel atIndex:i];
    }
    
    self.ezWordLabels = (NSArray *)tempArray;
}

- (void)loadNewPage:(EZPage *)ezPage
{
    [self loadEZPageWordsAsCCLabelBMFonts:ezPage];
  
    paraNum++;
     
    // Layout text
    [self layoutText];
}

/*** BEGIN NEED TO CULL ***/
#pragma mark - NEED TO CULL

-(void)layoutText
{    
    // Changing scenes allows you to use the fancy transitions
    CCScene *nextScene = [CCScene node];
    
    // pass a refernce to self, i.e. the EZTextView, so that EZTextViewScene knows where to get the words        
    ezTextViewScene = [[EZTextViewScene alloc] initWithEZTextView:self];
    [nextScene addChild:ezTextViewScene];
    
    //turn off interactions for the transition
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //do the transition
    [[CCDirector sharedDirector] replaceScene:[EZParagraphTransition transitionWithDuration:0.25 scene:nextScene delegate:self]];
    
    //draw the paragraph
    [ezTextViewScene layoutWords];
    
    paraNum++;
    paraNum %= 3;
}

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
    [player setDelegate:self];
    
}


-(IBAction)playPause:(id)sender
{
    //pause / resume timers and narration animations
    [ezTextViewScene playPause];
    
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
            [ezTextViewScene setWordPositionForTime:firstParaSkip];
            break;
        case 1:
            [self layoutText];
            [ezTextViewScene setWordPositionForTime:secondParaSkip];
            break;
        case 2:
            [self layoutText];
            [ezTextViewScene setWordPositionForTime:thirdParaSkip];
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


-(void)paragraphTransitionDidFinish
{
    NSLog(@"pv paragraphTransitionDidFinish");
    
    //re-enable interactions after the transition
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [self playPause:self];    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *) player successfully:(BOOL) completed
{    
    if (completed == YES) 
    {    
        idxOfLastWordLaidOut = 0;
        
        paraNum = 0;
        
        [[ezWordLabels lastObject] startWordOffAnimation];
        
        //TEMP
        self.text = @"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. Another could make fireballs by clicking his fingers. One time, he'd thrown a fireball at the teacher. She hadn't been very happy about it. But Zico had yet to discover his superpower. It was so embarrassing. The other kids at school made fun of him. \"Zico has no superpower, Zico has no superpower\", they chanted.";        
    }    
}
/*** END NEED TO CULL ***/

@end