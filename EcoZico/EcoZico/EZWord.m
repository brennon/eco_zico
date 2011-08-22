//
//  EZWord.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 06/05/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZWord.h"
#import "EZWordLabel.h"

@implementation EZWord

@synthesize text = _text;
@synthesize seekPoint = _seekPoint;

- (id)initWithText:(NSString *)word andSeekPoint:(NSNumber *)milliseconds
{
    self = [super init];
    if (self) {
        self.text = word;
        self.seekPoint = milliseconds;
    }
    
    return self;
}

- (id)generateEZWordLabel
{
    return [[[EZWordLabel alloc] initWithEZWord:self] autorelease];
}

- (void)dealloc
{
    [_text release];
    self.text = nil;
    [_seekPoint release];
    self.seekPoint = nil;
    [super dealloc];
}

@end