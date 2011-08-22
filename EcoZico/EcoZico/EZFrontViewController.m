//
//  EZFrontViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 23/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZFrontViewController.h"
#import "EcoZicoAppDelegate.h"

@implementation EZFrontViewController

@synthesize helpButton			= _helpButton;
@synthesize readItMyselfButton	= _readItMyselfButton;
@synthesize readItToMeButton	= _readItToMeButton;

- (IBAction)readItToMeButtonPushed 
{
    EcoZicoAppDelegate *appDelegate = (EcoZicoAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToBookViewController];
}

- (IBAction)readItMyselfButtonPushed 
{
    EcoZicoAppDelegate *appDelegate = (EcoZicoAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToBookViewController];
}

- (IBAction)helpButtonPushed
{
    EcoZicoAppDelegate *appDelegate = (EcoZicoAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToHelpViewController];
}

- (void)dealloc
{
    [_helpButton release];
    self.helpButton = nil;
    [_readItMyselfButton release];
	self.readItMyselfButton = nil;
    [_readItToMeButton release];
	self.readItToMeButton = nil;
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
    self.helpButton = nil;
    self.readItMyselfButton = nil;
    self.readItToMeButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow landscape orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
