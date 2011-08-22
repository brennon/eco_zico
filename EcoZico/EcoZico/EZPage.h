//
//  EZPage.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 03/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZPage : NSObject {
    NSArray *words;    
    NSString *audioFilePath;
    NSString *imageFilePath;
    NSArray *touchButtons;
}

@property (nonatomic, retain) NSArray *words;
@property (nonatomic, retain) NSString *audioFilePath;
@property (nonatomic, retain) NSString *imageFilePath;
@property (nonatomic, retain) NSArray *touchButtons;

- (id)initWithWords:(NSArray *)wordArray andAudioFilePath:(NSString *)audioFP andImageFilePath:(NSString *)imageFP andEZTransparentButtons:(NSArray *)buttonArray;

@end
