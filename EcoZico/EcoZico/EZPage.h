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
    NSString *audioFilePath;
    NSString *imageFilePath;
}

@property (nonatomic, retain) NSArray *words;
@property (nonatomic, retain) NSString *audioFilePath;
@property (nonatomic, retain) NSString *imageFilePath;

- (id)initWithWords:(NSArray *)wordArray andAudioFilePath:(NSString *)audioFP andImageFilePath:(NSString *)imageFP;

@end
