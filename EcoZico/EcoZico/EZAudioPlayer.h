//
//  EZAudioPlayer.h
//  EcoZico
//
//  Created by Brennon Bortz on 22/08/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef enum {
	kEZImageAudio,
	kEZPageTextAudio
} EZAudioPlayerType;

@interface EZAudioPlayer : AVAudioPlayer

@property (nonatomic, assign) EZAudioPlayerType playerType;

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError playerType:(EZAudioPlayerType)type;
- (id)initWithData:(NSData *)data error:(NSError **)outError playerType:(EZAudioPlayerType)type;

@end
