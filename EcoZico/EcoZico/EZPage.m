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

@synthesize words, audioFilePath, imageFilePath;

- (id)initWithWords:(NSArray *)wordArray andAudioFilePath:(NSString *)audioFP andImageFilePath:(NSString *)imageFP
{
    self = [super init];
    if (self) {
        self.words = wordArray;
        self.audioFilePath = audioFP;
        self.imageFilePath = imageFP;
    }
    return self;
}

- (void)dealloc
{
    [words release];
    words = nil;
    [audioFilePath release];
    audioFilePath = nil;
    [super dealloc];
}

- (void)setWords:(NSArray *)wordArray
{
    [words release];
    NSMutableArray *tempWords = [NSMutableArray arrayWithCapacity:[wordArray count]];
    for (int i = 0; i < [wordArray count]; i++) {
        NSDictionary *wordDictionary = [NSDictionary dictionaryWithDictionary:[wordArray objectAtIndex:i]];
        NSString *newText = [wordDictionary objectForKey:@"text"];
        NSNumber *newSeekPoint = [NSNumber numberWithFloat:[[wordDictionary objectForKey:@"time"] floatValue]];
        EZWord *newWord = [[EZWord alloc] initWithText:newText andSeekPoint:newSeekPoint];
        [tempWords insertObject:newWord atIndex:i];
        [newWord release];
    }
    
    words = [[NSArray arrayWithArray:(NSArray *)tempWords] retain];
}

@end
