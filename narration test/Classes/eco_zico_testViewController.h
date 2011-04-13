//
//  eco_zico_testViewController.h
//  eco zico test
//
//  Created by Donal O'Brien on 09/04/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@class Word;

@interface eco_zico_testViewController : UIViewController <AVAudioPlayerDelegate>
{
    Word *currentWord;
    
    UIButton *play;
    UISlider *position;
    
    NSTimer *timer;
    NSTimeInterval currentPosition;
    
    NSMutableArray *words;
    int wordPositionCounter;
}

@property (nonatomic, retain) IBOutlet UIButton *play;
@property (nonatomic, retain) IBOutlet UISlider *position;
@property (nonatomic, retain) NSMutableArray *words;
@property (nonatomic, retain) AVAudioPlayer *player;

-(void)createWords;
-(IBAction)sliderValChanged:(id)sender;
-(IBAction)play:(id)sender;
-(void)setWordPositionForTime:(NSTimeInterval)time;

@end

