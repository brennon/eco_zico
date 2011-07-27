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

@synthesize screenView, textView, handView;

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
    [handView release];
    [handView release];
    [handView release];
    [screenView release];
    [textView release];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)nextButtonPushed:(id)sender
{
}

- (IBAction)exitButtonPushed:(id)sender
{
    EcoZicoAppDelegate *appDelegate = (EcoZicoAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToFrontViewController];
}

@end
