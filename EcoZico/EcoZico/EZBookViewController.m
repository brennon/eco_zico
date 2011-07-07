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
        ezBook = [[EZBook alloc] initWithPlist:@"EcoZicoBook.plist"];
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
    
    [ezPageView setupWithBook:ezBook withDelegate:self];
    
    [self setupTextView];
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
    
    [self.view addSubview:(UIView *)ezTextView];
    [ezTextView attachCocos2dToSelf];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage = [NSNumber numberWithInt:(int) scrollView.contentOffset.x / scrollView.frame.size.width];
}

@end
