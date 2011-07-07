//
//  EZBook.m
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZBook.h"
#import "EZPage.h"

@implementation EZBook

@synthesize pages;

- (id)initWithPlist:(NSString *)aPath
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"EcoZicoBook" ofType:@"plist"];
        self.pages = [NSArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (void)dealloc
{
    [pages release];
    pages = nil;
    [super dealloc];
}

- (void)setPages:(NSArray *)somePages
{
    [self.pages release];
    NSMutableArray *newPages = [NSMutableArray arrayWithCapacity:[somePages count]];
    for (int i = 0; i < [somePages count]; i++) {
        NSDictionary *newPageDictionary = [NSDictionary dictionaryWithDictionary:[somePages objectAtIndex:i]];
        NSArray *newWordArray = [NSArray arrayWithObject:[newPageDictionary objectForKey:@"words"]];
        // EZPage *newPage = [[EZPage alloc] initWithWords:newWordArray andAudioFilePath:<#(NSURL *)#>];
    }
}

@end
