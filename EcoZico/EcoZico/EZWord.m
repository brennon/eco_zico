//
//  EZWord.m
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZWord.h"


@implementation EZWord

@synthesize text, seekPoint;

- (id)initWithText:(NSString *)word andSeekPoint:(NSNumber *)milliseconds
{
    self = [super init];
    if (self) {
        self.text = word;
        self.seekPoint = milliseconds;
    }
    return self;
}

- (void)dealloc
{
    [text release];
    text = nil;
    [seekPoint release];
    seekPoint = nil;
    [super dealloc];
}

@end
