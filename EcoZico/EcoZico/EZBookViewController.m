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
#import "EcoZicoAppDelegate.h"
#import "EZFrontViewController.h"


const NSUInteger kNumberOfPages = 14;

@implementation EZBookViewController

#pragma mark - Properties

@synthesize homeBut                 = _homeBut;
@synthesize ezPageView				= _ezPageView;
@synthesize textView				= _textView;
@synthesize ezBook					= _ezBook;
@synthesize currentPage				= _currentPage;
@synthesize ezWordLabels			= _ezWordLabels;
@synthesize ezTextViewScene			= _ezTextViewScene;
@synthesize idxOfLastWordLaidOut	= _idxOfLastWordLaidOut;
@synthesize ezAudioPlayer			= _ezAudioPlayer;
@synthesize playPauseBut			= _playPauseBut;
@synthesize audioIsPlaying			= _audioIsPlaying;
@synthesize isFirstPageAfterLaunch	= _isFirstPageAfterLaunch;
@synthesize touchZones				= _touchZones;
@synthesize player                  = _player;
@synthesize goHomeCalled            = _goHomeCalled;

#pragma mark - EZBookViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        self.isFirstPageAfterLaunch = YES;
		self.audioIsPlaying = NO;
        
        EcoZicoAppDelegate *appDelegate = (EcoZicoAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];        
        
        if (appDelegate.shouldContinueFromLastPageReached) {
            self.currentPage = [defaults objectForKey:NUMBER_OF_LAST_PAGE_REACHED];
        }
        else{
            self.currentPage = [NSNumber numberWithInt:0];
        }
        
        self.ezBook = [[[EZBook alloc] initWithPlist:@"EcoZicoBook.plist"] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [_homeBut release];
    _homeBut = nil;
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.view.backgroundColor = [UIColor blackColor];
    
	// Setup ezPageView with images, etc.
    self.ezPageView.delegate = self;
    [self.ezPageView setupWithBook:self.ezBook];
	
	// Startup cocos2d and attach it to the text view
    [self attachCocos2dToSelf];
	
	// Load the first page
    [self loadNewPage:[self.ezBook.pages objectAtIndex:[self.currentPage intValue]] withTransition:!self.isFirstPageAfterLaunch];    
    self.isFirstPageAfterLaunch = NO;
    
    //scroll to current page (necessary is user picket to continue from where they last left off).
    self.ezPageView.contentOffset = CGPointMake([self.currentPage intValue] * self.ezPageView.frame.size.width, self.ezPageView.frame.size.height);
    
    //save page to defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:self.currentPage forKey:NUMBER_OF_LAST_PAGE_REACHED];    
    [defaults synchronize];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.ezPageView = nil;
    self.textView = nil;
	self.playPauseBut = nil;
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
    
    // Create the EAGLView manually
    //  1. Create a RGB565 format. Alternative: RGBA8
    //	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
    EAGLView *glView = [EAGLView viewWithFrame:self.textView.bounds
                                   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                                   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
                        ];
    
    // attach the openglView to the director
    [director setOpenGLView:glView];
    
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
	
	// Show debugging FPS output
    // [director setDisplayFPS:YES];
    
    
    // make the OpenGLView a child of sentenceView
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

- (void)layoutTextWithTransition:(BOOL)withTrans
{    
    //don't change para if go home has already been called
    if (self.goHomeCalled == NO){
        
        // Changing scenes allows you to use the fancy transitions
        CCScene *nextScene = [CCScene node];
        
        // Pass a reference to self, i.e. the EZBookViewController, so that EZTextViewScene knows where to get the words        
        self.ezTextViewScene = [[[EZTextViewScene alloc] initWithEZBookView:self] autorelease];
        [nextScene addChild:self.ezTextViewScene];
        
        
        // Do the transition if not the first page shown
        if (withTrans) {
            //turn off interactions for the transition
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            DebugLog(@"(-beginIgnoringInteractionEvents)");
            
            [[CCDirector sharedDirector] replaceScene:[[EZParagraphTransitionFlipY class] transitionWithDuration:0.15 scene:nextScene delegate:self]];
        } else {
            [[CCDirector sharedDirector] replaceScene:nextScene];   
        }
        
        //draw the paragraph
        [self.ezTextViewScene layoutWords];
    }
    
}


#pragma mark - Text view-related callbacks
- (void)textViewDidFinishNarratingParagraph
{
	DebugLogFunc();
    // [self pauseAudio];
    [self layoutTextWithTransition:YES];
	DebugLog(@"ezAudioPlayer.currentTime: %f", [[self ezAudioPlayer] currentTime]);
}

- (void)paragraphTransitionDidFinish
{    
    // Re-enable interactions after the transition
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
	DebugLog(@"(-endIgnoringInteractionEvents)");
	// [self pauseAudio];
    
    [self playAudio];
}

#pragma mark - Text and image playback
- (void)loadAudioForPage:(int)pageNum
{
    // Load sound file
    NSString *audioFileName = [NSString stringWithFormat:@"zico_audio-page_%0i", pageNum];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: audioFileName ofType: @"mp3"];  
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
    DebugLogFunc();
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

- (IBAction)goHome:(id)sender
{
    DebugLogFunc();
    
    EcoZicoAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    appDelegate.window.rootViewController = (UIViewController *)[[EZFrontViewController alloc] init];
    
    [[CCDirector sharedDirector] end];
    
    self.goHomeCalled = YES;
    
    [self pauseAudio];
}

#pragma mark - AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)thisPlayer successfully:(BOOL)completed
{
	self.audioIsPlaying = NO;
	
	if ([(EZAudioPlayer *)thisPlayer playerType] == kEZImageAudio) {
		[thisPlayer release];
	} else if (completed == YES) {            
        [[self.ezWordLabels lastObject] startWordOffAnimation]; 
        
        // disable interactions on play/pause once page narration has finished
        // re-enable after turn of next page
        [self.playPauseBut setUserInteractionEnabled:NO];
    }
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int previousPage = [self.currentPage intValue];
    
    self.currentPage = [NSNumber numberWithInt:(int) scrollView.contentOffset.x / scrollView.frame.size.width];
    
    // Don't 'change the page' if the page being changed to is the same as the previous page.
    // (This delegate method fires even for minor scrolls and for the first and last pages).
    
    if ([self.currentPage intValue] != previousPage) 
    {
        // Must be set before -loadNewPage:withTransition: is called.
		self.idxOfLastWordLaidOut = 0;
        
        // Pause audio which cancells polling timer before calling -loadNewPage:withTransition:.
        // Will crash if timer is not cancelled.
        [self pauseAudio];
        
        [self loadNewPage:(EZPage *)[self.ezBook.pages objectAtIndex:[self.currentPage intValue]] withTransition:YES];
        
        // re-enable interactions after turn of next page
        
        [self.playPauseBut setUserInteractionEnabled:YES];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:self.currentPage forKey:NUMBER_OF_LAST_PAGE_REACHED];    
    [defaults synchronize];
}

@end
