//
//  EZFrontViewController.m
//  EcoZico
//
//  Created by Brennon Bortz on 23/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZFrontViewController.h"
#import "EcoZicoAppDelegate.h"

@implementation EZFrontViewController
@synthesize helpButton;
@synthesize readItMyselfButton;
@synthesize readItToMeButton;

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

- (IBAction)helpButtonPushed {}

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
    [helpButton release];
    [helpButton release];
    [readItMyselfButton release];
    [readItToMeButton release];
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
    [self setHelpButton:nil];
    [self setHelpButton:nil];
    [self setReadItMyselfButton:nil];
    [self setReadItToMeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
