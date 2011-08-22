//
//  EZBook.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 03/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZBook.h"
#import "EZPage.h"
#import "EZTransparentButton.h"

@implementation EZBook

@synthesize pages = _pages;

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
    [_pages release];
    self.pages = nil;
    [super dealloc];
}

- (void)setPages:(NSArray *)somePages
{
    [_pages release];
    NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:[somePages count]];
    for (int i = 0; i < [somePages count]; i++) {
        NSDictionary *newPageDictionary = [NSDictionary dictionaryWithDictionary:[somePages objectAtIndex:i]];
        NSArray *newWordArray = [NSArray arrayWithArray:[newPageDictionary objectForKey:@"words"]];
        NSString *audioFilepath = [[NSBundle mainBundle] pathForResource:[newPageDictionary objectForKey:@"audio"] ofType:nil];
        NSString *imageFilepath = [[NSBundle mainBundle] pathForResource:[newPageDictionary objectForKey:@"image"] ofType:nil];
        NSArray *touchButtonsInfo = [newPageDictionary objectForKey:@"touchButtons"];
        
        NSMutableArray *touchButtons = [NSMutableArray arrayWithCapacity:[touchButtonsInfo count]];
        
        for (UInt16 j = 0; j < [touchButtonsInfo count]; j++) {
            NSDictionary *buttonDict = [touchButtonsInfo objectAtIndex:j];
            EZTransparentButton *newButton = [EZTransparentButton buttonWithType:UIButtonTypeCustom];
            CGFloat x = [[buttonDict objectForKey:@"x"] floatValue];
            CGFloat y = [[buttonDict objectForKey:@"y"] floatValue];
            CGFloat width = [[buttonDict objectForKey:@"width"] floatValue];
            CGFloat height = [[buttonDict objectForKey:@"height"] floatValue];
            CGRect buttonFrame = CGRectMake(0.f, 0.f, width, height);            
            newButton.frame = buttonFrame;
            newButton.center = CGPointMake(x + (width/2) + (i * 1024), y + (height/2));
            newButton.backgroundColor = [UIColor clearColor];
            newButton.audioFilePath = [buttonDict objectForKey:@"audio"];
            [touchButtons insertObject:newButton atIndex:j];
        }   
        
        EZPage *newPage = [[EZPage alloc] initWithWords:newWordArray andAudioFilePath:audioFilepath andImageFilePath:imageFilepath andEZTransparentButtons:touchButtons];
        [tempPages insertObject:newPage atIndex:i];
        [newPage release];
    }
    
    _pages = [[NSArray arrayWithArray:(NSArray *)tempPages] retain];
}

@end
