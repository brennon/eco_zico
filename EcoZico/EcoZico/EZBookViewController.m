//
//  BookViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZBookViewController.h"
#import "EZPageView.h"
#import "EZBook.h"
#import "cocos2d.h"

// TV imports
#import "EZPage.h"
#import "EZWord.h"
#import "EZWordLabel.h"
#import "EZTextViewScene.h"
#import "CCLabelBMFont.h"
#import "EZParagraphTransition.h"

@implementation EZBookViewController

@synthesize ezPageView, textView, ezBook, currentPage, ezWordLabels, ezTextViewScene, idxOfLastWordLaidOut, player, playPauseBut, skipParaBut;


#pragma mark - EZBookViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isFirstPageAfterLaunch = YES;
        currentPage = [NSNumber numberWithInt:0];
        ezBook = [[[EZBook alloc] initWithPlist:@"EcoZicoBook.plist"] retain];
    }
    return self;
}

- (void)dealloc
{
    [ezPageView release];
    ezPageView = nil;
    [textView release];
    textView = nil;
    [currentPage release];
    currentPage = nil;
    [ezBook release];
    ezBook = nil;

    [ezWordLabels release];
    ezWordLabels = nil;
    [ezTextViewScene release];
    ezTextViewScene = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - EZBookViewController view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    ezPageView.delegate = self;

    [ezPageView setupWithBook:ezBook];
    
    [self attachCocos2dToSelf];

    [self loadNewPage:[ezBook.pages objectAtIndex:[currentPage intValue]] withTransition:!isFirstPageAfterLaunch];
    
    isFirstPageAfterLaunch = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    ezPageView = nil;
    textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow landscape orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - EZTextView
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
    EAGLView *glView = [EAGLView viewWithFrame:textView.bounds
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
    [director setDisplayFPS:YES];
    
    
    // make the OpenGLView a child of sentenceView
    //[viewController setView:glView];
    [textView addSubview:glView];
    
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


- (void)loadNewPage:(EZPage *)ezPage withTransition:(BOOL)withTrans
{
    [self loadEZPageWordsAsCCLabelBMFonts:ezPage];
    
    [self loadAudioForPage:[currentPage intValue]];
    
    // Layout text
    [self layoutTextWithTransition:withTrans];
}


-(void)layoutTextWithTransition:(BOOL)withTrans
{    
    // Changing scenes allows you to use the fancy transitions
    CCScene *nextScene = [CCScene node];
    
    // pass a refernce to self, i.e. the EZTextView, so that EZTextViewScene knows where to get the words        
    ezTextViewScene = [[EZTextViewScene alloc] initWithEZBookView:self];
    [nextScene addChild:ezTextViewScene];
    
    //do the transition if not the first page shown
    if (withTrans)
    {
        //turn off interactions for the transition
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        NSLog(@"beginIgnoringInteractionEvents");
        
        [[CCDirector sharedDirector] replaceScene:[EZParagraphTransition transitionWithDuration:0.25 scene:nextScene delegate:self]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:nextScene];   
    }
    
    //draw the paragraph
    [ezTextViewScene layoutWords];
    
}


-(void)loadAudioForPage:(int)pageNum
{
    //narration
    //load sound file
    NSString *audioFileName = [NSString stringWithFormat:@"zico_audio-page_%0i", pageNum];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: audioFileName ofType: @"wav"];  
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
    NSLog(@"tv playPause");
    
    //pause
    if([player isPlaying])
    {                
        [self pauseAudio];
    }
    //play
    else 
    {            
        [self playAudio];
    }
}


-(void)playAudio
{
    [ezTextViewScene startPollingPlayer];
    
    [player play];
    
    [playPauseBut setSelected:YES];
}


-(void)pauseAudio
{
    [ezTextViewScene stopPollingPlayer];
    
    [player pause];
    
    [playPauseBut setSelected:NO];
}


//for debugging - allows to skip through paragraphs in order to observer transitions more quickly.
double firstParaSkip = 6.5;
double secondParaSkip = 20;
double thirdParaSkip = 30;

-(IBAction)skipPara:(id)sender
{    
    EZPage *currentPageObj = [self.ezBook.pages objectAtIndex:[currentPage intValue]];
    NSTimeInterval timeOfLastWordInParagraph = [[[currentPageObj.words objectAtIndex:idxOfLastWordLaidOut]seekPoint] doubleValue];
    
    [ezTextViewScene setWordPositionForTime:timeOfLastWordInParagraph - 2];
    
}


#pragma mark - callback from EZTextViewScene

-(void)textViewDidFinishNarratingParagraph
{    
    [self pauseAudio];
    
    [self layoutTextWithTransition:YES];    
}


#pragma mark - callback from EZParagraphTransition

- (void)paragraphTransitionDidFinish
{    
    //re-enable interactions after the transition
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    NSLog(@"endIgnoringInteractionEvents");
    
    [self playAudio];
    
    //  [self performSelector:@selector(playPause:) withObject:self afterDelay:2];    
}


#pragma mark - audioplayer delegate methods

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *) player successfully:(BOOL) completed
{    
    if (completed == YES) 
    {            
        [[ezWordLabels lastObject] startWordOffAnimation];       
    }    
}


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int previousPage = [self.currentPage intValue];
    
    self.currentPage = [NSNumber numberWithInt:(int) scrollView.contentOffset.x / scrollView.frame.size.width];
    
    // don't 'change the page' if the page being changed to is the same as the previous page
    // this happens for minor scrolls and for the first and last pages.
    
    if ([currentPage intValue] != previousPage) 
    {
        //must be set before loadNewPage!!
        idxOfLastWordLaidOut = 0;
        
        // pause audio which cancells polling timer before calling loadNewPage.
        // if timer is not cancelled, you get a crash.
        [self pauseAudio];

        [self loadNewPage:(EZPage *)[ezBook.pages objectAtIndex:[currentPage intValue]] withTransition:YES];
    }    
}

@end
