//
//  EZHelpViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 27/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZHelpViewController.h"
#import "EcoZicoAppDelegate.h"


@implementation EZHelpViewController

@synthesize nextButton			= _nextButton;
@synthesize screenView			= _screenView;
@synthesize textView			= _textView;
@synthesize handView			= _handView;
@synthesize currentInstructions = _currentInstructions;
@synthesize textImageFilenames	= _textImageFilenames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentInstructions = [NSNumber numberWithInt:0];
        self.textImageFilenames = [NSArray arrayWithObjects:
                                   @"instructions_01.png", 
                                   @"instructions_02.png", 
                                   @"instructions_03.png",
                                   @"instructions_04.png", 
                                   nil];
        
        handRects[0] = CGRectMake(236, 570, 293, 475);
        handRects[1] = CGRectMake(-136, 320, 293, 475);
        handRects[2] = CGRectMake(236, 570, 293, 475);
    }
    return self;
}

- (void)dealloc
{
    [_currentInstructions release];
	self.currentInstructions = nil;
    [_handView release];
	self.handView = nil;
    [_screenView release];
	self.screenView = nil;
    [_textView release];
	self.textView = nil;
    [_nextButton release];
	self.nextButton = nil;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.handView = nil;
    self.screenView = nil;
    self.textView = nil;
    self.nextButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow landscape orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)animateScreenshot {}

- (void)animateText
{  
    [UIView animateWithDuration:0.75 
                     animations:^ { 
                         self.textView.alpha = 0.0; 
                     } 
                     completion:^(BOOL finished) {
                         NSString *nextFilename = [self.textImageFilenames objectAtIndex:[self.currentInstructions intValue]];    
                         UIImage *nextTextImage = [UIImage imageNamed:nextFilename];    
                         self.textView.image = nextTextImage;
                         [UIView animateWithDuration:0.75 
                                          animations:^ {
                                              self.textView.alpha = 1.0;  
                                          }];
                     }];
}

- (void)animateHand
{
    [UIView animateWithDuration:1.0 
                     animations:^ {
                         self.handView.frame = handRects[[self.currentInstructions intValue] - 1];
                     }];
}

- (void)animateHelpScreen
{
    [self animateScreenshot];
    [self animateText];
    [self animateHand];
}

- (IBAction)nextButtonPushed:(id)sender
{    
    self.currentInstructions = [NSNumber numberWithInt:[self.currentInstructions intValue] + 1];
    if ([self.currentInstructions intValue] == 3) {
        [self.nextButton removeFromSuperview];
    }
    [self animateHelpScreen];
}

- (IBAction)exitButtonPushed:(id)sender
{
    EcoZicoAppDelegate *appDelegate = (EcoZicoAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToFrontViewController];
}

@end
