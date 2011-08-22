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
#import "EZPage.h"
#import "EZWord.h"
#import "EZWordLabel.h"
#import "EZTextViewScene.h"
#import "CCLabelBMFont.h"
#import "EZParagraphTransitions.h"
#import "EZTransparentButton.h"
#import "EZAudioPlayer.h"

const NSUInteger kNumberOfPages = 14;

@implementation EZBookViewController

#pragma mark - Properties

@synthesize ezPageView				= _ezPageView;
@synthesize textView				= _textView;
@synthesize ezBook					= _ezBook;
@synthesize currentPage				= _currentPage;
@synthesize ezWordLabels			= _ezWordLabels;
@synthesize ezTextViewScene			= _ezTextViewScene;
@synthesize idxOfLastWordLaidOut	= _idxOfLastWordLaidOut;
@synthesize ezAudioPlayer			= _ezAudioPlayer;
@synthesize playPauseBut			= _playPauseBut;
@synthesize skipParaBut				= _skipParaBut;
@synthesize audioIsPlaying			= _audioIsPlaying;
@synthesize isFirstPageAfterLaunch	= _isFirstPageAfterLaunch;
@synthesize touchZones				= _touchZones;

#pragma mark - EZBookViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        self.isFirstPageAfterLaunch = YES;
		self.audioIsPlaying = NO;
        self.currentPage = [NSNumber numberWithInt:0];
        self.ezBook = [[[EZBook alloc] initWithPlist:@"EcoZicoBook.plist"] retain];
    }
    return self;
}

- (void)dealloc
{
    [_ezPageView release];
    self.ezPageView = nil;
    [_textView release];
    self.textView = nil;
    [_currentPage release];
    self.currentPage = nil;
    [_ezBook release];
    self.ezBook = nil;
    [_ezWordLabels release];
    self.ezWordLabels = nil;
    [_ezTextViewScene release];
    self.ezTextViewScene = nil;
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
    self.ezPageView.delegate = self;
    [self.ezPageView setupWithBook:self.ezBook];
    
    [self attachCocos2dToSelf];

    [self loadNewPage:[self.ezBook.pages objectAtIndex:[self.currentPage intValue]] withTransition:!self.isFirstPageAfterLaunch];
    
    self.isFirstPageAfterLaunch = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.ezPageView = nil;
    self.textView = nil;
	self.playPauseBut = nil;
	self.skipParaBut = nil; // For debugging
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow landscape orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Text view setup/manipulation

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
    EAGLView *glView = [EAGLView viewWithFrame:self.textView.bounds
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
    [self.textView addSubview:glView];
    
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
    
    [self loadAudioForPage:[self.currentPage intValue]];
    
    // Layout text
    [self layoutTextWithTransition:withTrans];
    
    for (UIView *view in [self.ezPageView subviews]) {
        if ([view isKindOfClass:[EZTransparentButton class]]) {
            [view removeFromSuperview];
        }        
    }
    
    for (UInt16 i = 0; i < [ezPage.touchButtons count]; i++) {
        EZTransparentButton *buttonToAdd = [ezPage.touchButtons objectAtIndex:i];
        [buttonToAdd addTarget:self action:@selector(playImageAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.ezPageView addSubview:buttonToAdd];        
    }
}

-(void)layoutTextWithTransition:(BOOL)withTrans
{    
    // Changing scenes allows you to use the fancy transitions
    CCScene *nextScene = [CCScene node];
    
    // pass a refernce to self, i.e. the EZTextView, so that EZTextViewScene knows where to get the words        
    self.ezTextViewScene = [[EZTextViewScene alloc] initWithEZBookView:self];
    [nextScene addChild:self.ezTextViewScene];
    
    //do the transition if not the first page shown
    if (withTrans) {
        //turn off interactions for the transition
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        DebugLog(@"(-beginIgnoringInteractionEvents)");
        
        //show a different transition every other page.
        Class trans = [self.currentPage intValue] % 2 == 0 ? [EZParagraphTransitionFlipY class] : [EZParagraphTransitionMoveInB class];
        
        [[CCDirector sharedDirector] replaceScene:[trans transitionWithDuration:0.25 scene:nextScene delegate:self]];
    } else {
        [[CCDirector sharedDirector] replaceScene:nextScene];   
    }
    
    //draw the paragraph
    [self.ezTextViewScene layoutWords];
    
}

#pragma mark - Text view-related callbacks

- (void)textViewDidFinishNarratingParagraph
{    
    [self pauseAudio];    
    [self layoutTextWithTransition:YES];    
}

- (void)paragraphTransitionDidFinish
{    
    // Re-enable interactions after the transition
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
	DebugLog(@"(-endIgnoringInteractionEvents)");
    
    [self playAudio];
}

#pragma mark - Text and image playback

- (void)loadAudioForPage:(int)pageNum
{
    // Load sound file
    NSString *audioFileName = [NSString stringWithFormat:@"zico_audio-page_%0i", pageNum];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: audioFileName ofType: @"wav"];  
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	EZAudioPlayer *newPlayer = [[EZAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL playerType:kEZPageTextAudio];
    [fileURL release];           
    
    self.ezAudioPlayer = newPlayer;    
    [newPlayer release];        
    
    [self.ezAudioPlayer prepareToPlay];    
    [self.ezAudioPlayer setDelegate:self];
    
}

- (void)playImageAudio:(id)sender
{
	if (!self.audioIsPlaying) {
		NSString *filename = [(EZTransparentButton *)sender audioFilePath];
		NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];  
		NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
		EZAudioPlayer *localPlayer = [[EZAudioPlayer alloc] initWithContentsOfURL:url error:NULL playerType:kEZImageAudio];
		[url release];
		
		self.audioIsPlaying = YES;		
		[localPlayer play];    
		[localPlayer setDelegate:self];
	}
}


- (IBAction)playPause:(id)sender
{
    DebugLogFunc();
    
    if([self.ezAudioPlayer isPlaying]) {
        [self pauseAudio];
		self.audioIsPlaying = NO;
    } else {            
        [self playAudio];
		self.audioIsPlaying = YES;
    }
}


- (void)playAudio
{
    [self.ezTextViewScene startPollingPlayer];    
    [self.ezAudioPlayer play];
	self.audioIsPlaying = YES;    
    self.playPauseBut.selected = YES;
}


- (void)pauseAudio
{
    [self.ezTextViewScene stopPollingPlayer];    
    [self.ezAudioPlayer pause];
	self.audioIsPlaying = NO;
    self.playPauseBut.selected = NO;
}


//for debugging - allows to skip through paragraphs in order to observer transitions more quickly.
double firstParaSkip = 6.5;
double secondParaSkip = 20;
double thirdParaSkip = 30;

- (IBAction)skipPara:(id)sender
{    
    EZPage *currentPageObj = [self.ezBook.pages objectAtIndex:[self.currentPage intValue]];
    NSTimeInterval timeOfLastWordInParagraph = [[[currentPageObj.words objectAtIndex:self.idxOfLastWordLaidOut]seekPoint] doubleValue];
    
    [self.ezTextViewScene setWordPositionForTime:timeOfLastWordInParagraph - 2];
    
}

#pragma mark - AVAudioPlayerDelegate methods

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)thisPlayer successfully:(BOOL)completed
{
	self.audioIsPlaying = NO;
	
    if (completed == YES) {            
        [[self.ezWordLabels lastObject] startWordOffAnimation];       
    }
	
	if ([(EZAudioPlayer *)thisPlayer playerType] == kEZImageAudio) {
		[thisPlayer release];
	}
}


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int previousPage = [self.currentPage intValue];
    
    self.currentPage = [NSNumber numberWithInt:(int) scrollView.contentOffset.x / scrollView.frame.size.width];
    
    // Don't 'change the page' if the page being changed to is the same as the previous page.
    // (This delegate method fires even for minor scrolls and for the first and last pages.
    
    if ([self.currentPage intValue] != previousPage) 
    {
        // Must be set before -loadNewPage:withTransition: is called.
		self.idxOfLastWordLaidOut = 0;
        
        // Pause audio which cancells polling timer before calling -loadNewPage:withTransition:.
        // Will crash if timer is not cancelled.
        [self pauseAudio];

        [self loadNewPage:(EZPage *)[self.ezBook.pages objectAtIndex:[self.currentPage intValue]] withTransition:YES];
    }    
}

@end
