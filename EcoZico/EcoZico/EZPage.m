//
//  EZPage.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 03/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZPage.h"
#import "EZWord.h"

@implementation EZPage

@synthesize words = _words;
@synthesize audioFilePath = _audioFilePath;
@synthesize imageFilePath = _imageFilePath;
@synthesize touchButtons = _touchButtons;

- (id)initWithWords:(NSArray *)wordArray andAudioFilePath:(NSString *)audioFP andImageFilePath:(NSString *)imageFP andEZTransparentButtons:(NSArray *)buttonArray
{
    self = [super init];
    if (self) {
        self.words = wordArray;
        self.audioFilePath = audioFP;
        self.imageFilePath = imageFP;
        self.touchButtons = buttonArray;
    }
    return self;
}

- (void)dealloc
{
    [_words release];
    self.words = nil;
    [_audioFilePath release];
    self.audioFilePath = nil;
    [_imageFilePath release];
    self.imageFilePath = nil;
    [_touchButtons release];
    self.touchButtons = nil;
    [super dealloc];
}

- (void)setWords:(NSArray *)wordArray
{
    [_words release];
    NSMutableArray *tempWords = [NSMutableArray arrayWithCapacity:[wordArray count]];
    for (int i = 0; i < [wordArray count]; i++) {
        NSDictionary *wordDictionary = [NSDictionary dictionaryWithDictionary:[wordArray objectAtIndex:i]];
        NSString *newText = [wordDictionary objectForKey:@"text"];
        NSNumber *newSeekPoint = [NSNumber numberWithFloat:[[wordDictionary objectForKey:@"time"] floatValue]];
        EZWord *newWord = [[EZWord alloc] initWithText:newText andSeekPoint:newSeekPoint];
        [tempWords insertObject:newWord atIndex:i];
        [newWord release];
    }
    
    _words = [[NSArray arrayWithArray:(NSArray *)tempWords] retain];
}

@end
