//
//  EZBook.m
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZBook.h"


@implementation EZBook

@synthesize pages;

- (id)initWithPages:(NSArray *)pageArray
{
    self = [super init];
    if (self) {
        self.pages = pageArray;
    }
    return self;
}

- (void)dealloc
{
    [pages release];
    pages = nil;
    [super dealloc];
}

@end
