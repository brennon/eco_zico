//
//  EZAudioPlayer.m
//  EcoZico
//
//  Created by Brennon Bortz on 22/08/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZAudioPlayer.h"

@implementation EZAudioPlayer

@synthesize playerType;

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError playerType:(EZAudioPlayerType)type
{
	self = [super initWithContentsOfURL:url error:outError];
    if (self) {
        self.playerType = type;
    }
    
    return self;
}

- (id)initWithData:(NSData *)data error:(NSError **)outError playerType:(EZAudioPlayerType)type
{
	self = [super initWithData:data error:outError];
    if (self) {
        self.playerType = type;
    }
    
    return self;
}

@end
