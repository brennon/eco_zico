//
//  EZHelpViewController.m
//  EcoZico
//
//  Created by Brennon Bortz on 27/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZHelpViewController.h"
#import "EcoZicoAppDelegate.h"


@implementation EZHelpViewController
@synthesize nextButton;

@synthesize screenView, textView, handView, currentInstructions, textImageFilenames;

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
    [currentInstructions release];
    [handView release];
    [screenView release];
    [textView release];
    [nextButton release];
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
    [self setHandView:nil];
    [self setHandView:nil];
    [self setScreenView:nil];
    [self setTextView:nil];
    [self setNextButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)animateScreenshot {}

- (void)animateText
{  
    [UIView animateWithDuration:0.75 
                     animations:^ { 
                         self.textView.alpha = 0.0; 
                     } 
                     completion:^(BOOL finished) {
                         NSString *nextFilename = [self.textImageFilenames objectAtIndex:[currentInstructions intValue]];    
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
                         self.handView.frame = handRects[[currentInstructions intValue] - 1];
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
    self.currentInstructions = [NSNumber numberWithInt:[currentInstructions intValue] + 1];
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
