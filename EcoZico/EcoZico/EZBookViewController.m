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

const NSUInteger kNumberOfPages = 14;

@interface EZBookViewController ()

-(void)setupTextView;

@end

@implementation EZBookViewController

@synthesize ezPageView, ezTextView, currentPage;

#pragma mark - EZBookViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentPage = [NSNumber numberWithInt:0];
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
    
    [ezPageView setupBookWithNumberofPages:kNumberOfPages withDelegate:self];
    
    [self setupTextView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    ezPageView = nil;
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

    ezTextView.text = @"All the kids at Zico's school had amazing powers, too. One boy could fly and would swoop into the classroom with a swish of his cape. Another could make fireballs by clicking his fingers. One time, he'd thrown a fireball at the teacher. She hadn't been very happy about it. But Zico had yet to discover his superpower. It was so embarrassing. The other kids at school made fun of him. \"Zico has no superpower, Zico has no superpower\", they chanted.";
    
    [self.view addSubview:(UIView *)ezTextView];
    [ezTextView attachCocos2dToSelf];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = [NSNumber numberWithInt:(int) scrollView.contentOffset.x / scrollView.frame.size.width];
}

@end
