//
//  EZPage.m
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZPage.h"


@implementation EZPage

@synthesize words, audioFilePath;

- (id)initWithWords:(NSArray *)wordArray andAudioFilePath:(NSURL *)path
{
    self = [super init];
    if (self) {
        self.words = wordArray;
        self.audioFilePath = path;
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

@end
