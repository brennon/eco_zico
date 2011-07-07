//
//  EZPage.m
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZPage.h"
#import "EZWord.h"

@implementation EZPage

@synthesize words, audioFilePath;

- (id)initWithWords:(NSArray *)wordArray andAudioFilePath:(NSString *)filepath
{
    self = [super init];
    if (self) {
        self.words = wordArray;
        self.audioFilePath = filepath;
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
    for (int i = 0; i < [wordArray count]; i++) {\
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
