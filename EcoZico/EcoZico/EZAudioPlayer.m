//
//  EZAudioPlayer.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 22/08/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZAudioPlayer.h"

@implementation EZAudioPlayer

@synthesize playerType = _playerType;

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
