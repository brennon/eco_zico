//
//  BookViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZBookViewController.h"
#import "EZPageView.h"

@interface EZBookViewController ()

-(void)setupPageView; 

@end

@implementation EZBookViewController

const NSUInteger kNumberOfPages = 14;

@synthesize ezPageView;

#pragma mark - EZBookViewController lifecycle

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
    [ezPageView release];
    ezPageView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - EZBookview lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupPageView];
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

#pragma mark - EZPageView
- (void)setupPageView
{
    // BEGIN ezPageView SETUP
    ezPageView.backgroundColor = [UIColor blackColor];
    
    // Match contentView to ezPageView's frame
    ezPageView.contentSize = CGSizeMake(ezPageView.frame.size.width * kNumberOfPages, ezPageView.frame.size.height);
    
    // Align contentView and ezPageView origins
    ezPageView.contentOffset = CGPointZero;
    
    // Needed to lock scrolling to pages
    ezPageView.pagingEnabled = YES;
    
    // This stops the possibility of scrolling past the beginning or end of the book
    // ezPageView.bounces = NO;
    
    // For ease in referencing sizes
    CGFloat portalHeight = ezPageView.frame.size.height;
    CGFloat portalWidth = ezPageView.frame.size.width;
    
    // Manually load images into contentView -- this will change once Book / Page classes are implemented
    for (NSUInteger i = 0; i <= kNumberOfPages; i++) {
        
        // Make all frames the size of ezPageView's frame, but shifted by multiples of its width
        CGRect frame = CGRectMake(ezPageView.bounds.origin.x + portalWidth * i, ezPageView.bounds.origin.y, portalWidth, portalHeight);
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"eco-page_%d.png", i+1]];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = frame;
        [ezPageView addSubview:view];
        [view release];
    }
}

@end
