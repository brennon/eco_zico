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

@implementation EZTextView

@synthesize ezWordLabels;

/*** BEGIN NEED TO CULL ***/
@synthesize idxOfLastWordLaidOut, transitionLabel, player, playPauseBut, skipParaBut;
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

- (void)attachCocos2dToSelf
{
    // Try to use CADisplayLink director
    // if it fails (SDK < 3.1) use the default director
    if(![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
        [CCDirector setDirectorType:kCCDirectorTypeDefault];
    
    
    CCDirector *director = [CCDirector sharedDirector];
    
    //
    // Create the EAGLView manually
    //  1. Create a RGB565 format. Alternative: RGBA8
    //	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
    //
    //
    EAGLView *glView = [EAGLView viewWithFrame:[self bounds]
                                   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                                   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
                        ];
    
    // attach the openglView to the director
    [director setOpenGLView:glView];
    
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    //	if( ! [director enableRetinaDisplay:YES] )
    //		CCLOG(@"Retina Display Not supported");
    
    //
    // VERY IMPORTANT:
    // If the rotation is going to be controlled by a UIViewController
    // then the device orientation should be "Portrait".
    //
    // IMPORTANT:
    // By default, this template only supports Landscape orientations.
    // Edit the RootViewController.m file to edit the supported orientations.
    //
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
    [director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
    [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
    
    [director setAnimationInterval:1.0/60];
    [director setDisplayFPS:NO];
    
    
    // make the OpenGLView a child of sentenceView
    //[viewController setView:glView];
    [self addSubview:glView];
    
    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    // You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    //set default opengl color to white
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    
    //start with an empty scene
    CCScene *temp = [CCScene node];
    CCLayerColor *tempL = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
    [temp addChild:tempL];
    
    [director runWithScene:temp];
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
  
     // paraNum++;
     
     //layout text the first time
     
     ezTextViewScene = [[EZTextViewScene alloc]initWithEZPageView:self];    
    /* 
    [nextScene addChild:textVC];    
     [textVC release];
     
     [[CCDirector sharedDirector] replaceScene:nextScene];
     
     [textVC layoutWords];
     
     [self loadAudioForPage:2];
     */
}

/*** BEGIN NEED TO CULL ***/
#pragma mark - NEED TO CULL
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
        
        [[words lastObject] runWordOffAnim];
        
        //TEMP
        self.text = @"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. Another could make fireballs by clicking his fingers. One time, he'd thrown a fireball at the teacher. She hadn't been very happy about it. But Zico had yet to discover his superpower. It was so embarrassing. The other kids at school made fun of him. \"Zico has no superpower, Zico has no superpower\", they chanted.";        
    }    
}
/*** END NEED TO CULL ***/

@end