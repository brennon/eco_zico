//
//  BookViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZBookViewController.h"
#import "EZTextViewController.h"
#import "cocos2d.h"

@implementation EZBookViewController

const NSUInteger kNumberOfPages = 14;

@synthesize pageScrollView, loadOfText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [pageScrollView release];
    pageScrollView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    

    self.view.backgroundColor = [UIColor blackColor];        
    pageScrollView.backgroundColor = [UIColor blackColor];
    
    // Match contentView to pageScrollView's frame
    pageScrollView.contentSize = CGSizeMake(pageScrollView.frame.size.width * kNumberOfPages, pageScrollView.frame.size.height);
    
    // Align contentView and pageScrollView origins
    pageScrollView.contentOffset = CGPointZero;
    
    // Needed to lock scrolling to pages
    pageScrollView.pagingEnabled = YES;
    
    // This stops the possibility of scrolling past the beginning or end of the book
    // pageScrollView.bounces = NO;
    
    // For ease in referencing sizes
    CGFloat portalHeight = pageScrollView.frame.size.height;
    CGFloat portalWidth = pageScrollView.frame.size.width;
    
    // Manually load images into contentView -- this will change once Book / Page classes are implemented
    for (NSUInteger i = 0; i <= kNumberOfPages; i++) {
        
        // Make all frames the size of pageScrollView's frame, but shifted by multiples of its width
        CGRect frame = CGRectMake(pageScrollView.bounds.origin.x + portalWidth * i, pageScrollView.bounds.origin.y, portalWidth, portalHeight);
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"eco-page_%d.png", i+1]];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = frame;
        [pageScrollView addSubview:view];
        [view release];
    }
    
    //TEMP - page text
    self.loadOfText = @"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. "@"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. "@"Another could make fireballs by clicking his fingers. One time, he had thrown a fireball at the teacher. She hadn't been very happy about it. ";
    
    //calc size for view to which to attach cocos2d    
    CGSize winsize = [[UIScreen mainScreen]applicationFrame].size;    
    float heightOfSentenceView = winsize.width - pageScrollView.frame.origin.y - portalHeight;
    
    sentenceView = [[UIView alloc] initWithFrame:CGRectMake(pageScrollView.frame.origin.x, pageScrollView.frame.origin.y + portalHeight, portalWidth, heightOfSentenceView)];
    
    [self.view addSubview:sentenceView];
    [sentenceView release];
    
    //attach cocos2d to the view
    [self attachCocos2dView];
    
    //TEMP - pass text to the page
    pageScrollView.text = loadOfText;

}


-(void)attachCocos2dView
{
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[sentenceView bounds]
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
    [sentenceView addSubview:glView];
	
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    //start with an empty scene
    CCScene *temp = [CCScene node];
    CCLayer *tempL = [CCLayer node];
    [temp addChild:tempL];
    
    [director runWithScene:temp];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    pageScrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow landscape orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
