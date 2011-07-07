//
//  EZPageView.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 07/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import "EZPageView.h"

@implementation EZPageView

@synthesize delegate;

#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Book setup

- (void)setupBookWithNumberofPages:(NSUInteger)count withDelegate:(id <UIScrollViewDelegate>)svDelegate
{
    // ezPageView is instantiated by the NIB file
    super.delegate = svDelegate;
    
    // For ease in referencing sizes
    CGFloat portalHeight = self.frame.size.height;
    CGFloat portalWidth = self.frame.size.width;
    
    // Black background
    self.backgroundColor = [UIColor blackColor];
    
    // Match contentView to ezPageView's frame
    self.contentSize = CGSizeMake(self.frame.size.width * count, self.frame.size.height);
    
    // Align contentView and ezPageView origins
    self.contentOffset = CGPointZero;
    
    // Needed to lock scrolling to pages
    self.pagingEnabled = YES;
    
    // Manually load images into contentView -- this will change once Book / Page classes are implemented
    for (NSUInteger i = 0; i <= count; i++) {
        
        // Make all frames the size of ezPageView's frame, but shifted by multiples of its width
        CGRect frame = CGRectMake(self.bounds.origin.x + portalWidth * i, self.bounds.origin.y, portalWidth, portalHeight);
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"eco-page_%d.png", i]];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = frame;
        [self addSubview:view];
        [view release];
    }
}

@end
