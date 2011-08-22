//
//  EZTransparentButton.m
//  EcoZico
//
//  Created by Brennon Bortz on 07/08/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZTransparentButton.h"

@implementation EZTransparentButton

@synthesize audioFilePath = _audioFilePath;

- (void)dealloc
{
    [_audioFilePath release];
    self.audioFilePath = nil;
    [super dealloc];
}

@end
