//
//  EZPageView.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 07/05/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien Queens University Belfast. All rights reserved.
//

#import "EZPageView.h"
#import "EZBook.h"
#import "EZPage.h"

@implementation EZPageView

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

- (void)setupWithBook:(EZBook *)book 
{
    // For ease in referencing sizes
    CGFloat portalHeight = self.frame.size.height;
    CGFloat portalWidth = self.frame.size.width;
    
    // Black background
    self.backgroundColor = [UIColor whiteColor];
    
    // Match contentView to ezPageView's frame
    self.contentSize = CGSizeMake(self.frame.size.width * [book.pages count], self.frame.size.height);
    
    // Align contentView and ezPageView origins
    self.contentOffset = CGPointZero;
    
    // Needed to lock scrolling to pages
    self.pagingEnabled = YES;
    
    // Load images into contentView
    for (NSUInteger i = 0; i < [book.pages count]; i++) {
        // Make all frames the size of ezPageView's frame, but shifted by multiples of its width
        CGRect frame = CGRectMake(self.bounds.origin.x + portalWidth * i, self.bounds.origin.y, portalWidth, portalHeight);
        EZPage *ezPage = [book.pages objectAtIndex:i];
        NSString *imagePath = [ezPage imageFilePath];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.frame = frame;
        [self addSubview:view];
        [view release];
    }
}

@end
