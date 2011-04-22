//
//  BookViewController.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "BookViewController.h"

@implementation BookViewController

const NSUInteger kNumberOfPages = 14;

@synthesize pageScrollView;

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
