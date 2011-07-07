//
//  EZPage.h
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZPage : NSObject {
    NSArray *words;
    NSURL *audioFilePath;
}

@property (nonatomic, retain) NSArray *words;
@property (nonatomic, retain) NSURL *audioFilePath;

- (id)initWithWords:(NSArray *)wordArray andAudioFilename:(NSString *)filename;

@end
