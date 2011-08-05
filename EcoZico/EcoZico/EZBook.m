//
//  EZBook.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 03/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
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
    [pages release];
    NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:[somePages count]];
    for (int i = 0; i < [somePages count]; i++) {
        NSDictionary *newPageDictionary = [NSDictionary dictionaryWithDictionary:[somePages objectAtIndex:i]];
        NSArray *newWordArray = [NSArray arrayWithArray:[newPageDictionary objectForKey:@"words"]];
        NSString *audioFilepath = [[NSBundle mainBundle] pathForResource:[newPageDictionary objectForKey:@"audio"] ofType:nil];
        NSString *imageFilepath = [[NSBundle mainBundle] pathForResource:[newPageDictionary objectForKey:@"image"] ofType:nil];
        EZPage *newPage = [[EZPage alloc] initWithWords:newWordArray andAudioFilePath:audioFilepath andImageFilePath:imageFilepath];
        [tempPages insertObject:newPage atIndex:i];
        [newPage release];
    }
    
    pages = [[NSArray arrayWithArray:(NSArray *)tempPages] retain];
}

@end
