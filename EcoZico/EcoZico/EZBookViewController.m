//
//  BookViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZBookViewController.h"
#import "EZPageView.h"
#import "EZTextView.h"
#import "EZBook.h"
#import "cocos2d.h"

const NSUInteger kNumberOfPages = 14;

@interface EZBookViewController ()

-(void)setupTextView;

@end

@implementation EZBookViewController

@synthesize ezPageView, ezTextView, ezBook, currentPage;

#pragma mark - EZBookViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentPage = [NSNumber numberWithInt:0];
        ezBook = [[[EZBook alloc] initWithPlist:@"EcoZicoBook.plist"] retain];
    }
    return self;
}

- (void)dealloc
{
    [ezPageView release];
    ezPageView = nil;
    [ezTextView release];
    ezTextView = nil;
    [currentPage release];
    currentPage = nil;
    [ezBook release];
    ezBook = nil;
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
    
    [ezPageView setupWithBook:ezBook withDelegate:self];
    
    [self setupTextView];
    [self attachCocos2dToSelf];
    [ezTextView loadNewPage:[ezBook.pages objectAtIndex:[currentPage intValue]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    ezPageView = nil;
    ezTextView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow landscape orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - EZTextView

- (void)setupTextView
{    
    // Calculate size for view to which to attach cocos2d    
    CGSize winsize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat height = winsize.width - ezPageView.frame.origin.y - ezPageView.frame.size.height;
    
    ezTextView = [[EZTextView alloc] initWithFrame:CGRectMake(ezPageView.frame.origin.x, ezPageView.frame.origin.y + ezPageView.frame.size.height, ezPageView.frame.size.width - PLAY_PAUSE_BUTTON_WIDTH, height)];
    
    [ezTextView setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:(UIView *)ezTextView];
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
    EAGLView *glView = [EAGLView viewWithFrame:ezTextView.bounds
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
    [ezTextView addSubview:glView];
    
    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    // You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    //set default opengl color to white
    glClearColor(0.0f, 0.5f, 1.0f, 1.0f);
    
    //start with an empty scene
    CCScene *temp = [CCScene node];
    CCLayerColor *tempL = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
    [temp addChild:tempL];
    
    [director runWithScene:temp];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = [NSNumber numberWithInt:(int) scrollView.contentOffset.x / scrollView.frame.size.width];
    [ezTextView loadNewPage:(EZPage *)[ezBook.pages objectAtIndex:[currentPage intValue]]];
}

@end
