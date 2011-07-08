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
#import "CCLabelBMFont.h"

@implementation EZTextView

@synthesize ezWordLabels;

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

#pragma mark - Text handling

-(void)setText:(NSString *)newText
{

    
/*    
    paraNum++;
    
    //layout text the first time
    CCScene *nextScene = [CCScene node];
    textVC = [[EZTextViewController alloc]initWithPage:self];    
    [nextScene addChild:textVC];    
    [textVC release];
    
    [[CCDirector sharedDirector] replaceScene:nextScene];
    
    [textVC layoutWords];
    
    [self loadAudioForPage:2];
 */
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
}

@end