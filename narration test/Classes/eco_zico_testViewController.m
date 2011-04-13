//
//  eco_zico_testViewController.m
//  eco zico test
//
//  Created by Donal O'Brien on 09/04/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import "eco_zico_testViewController.h"
#import "Word.h"


@implementation eco_zico_testViewController

@synthesize player, play, position, words; // the player object

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {    
        
        
    }
    return self;
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
        
    //load sound file
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"once upon a time full" ofType: @"wav"];  
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    [fileURL release];           

    self.player = newPlayer;    
    [newPlayer release];        
    
    [player prepareToPlay];    
    [player setDelegate: self];
    
    //create array of word objects
    [self createWords];    
}

/*
-(void)createWords
{
    self.words = [NSMutableArray array];
    
    Word *word1 = [[Word alloc]initWithFrame:CGRectMake(40, 900, 100, 50)];
    word1.text = @"Once";
    word1.position = 0;
    [self.view addSubview:word1];
    [word1 release];
    
    Word *word2 = [[Word alloc]initWithFrame:CGRectMake(150, 900, 100, 50)];
    word2.text = @"upon";
    word1.position = 0.361897;
    [self.view addSubview:word2];
    [word2 release];
    
    Word *word3 = [[Word alloc]initWithFrame:CGRectMake(260, 900, 100, 50)];
    word3.text = @"a";
    word3.position = 0.705;
    [self.view addSubview:word3];
    [word3 release];
    
    Word *word4 = [[Word alloc]initWithFrame:CGRectMake(370, 900, 100, 50)];
    word4.text = @"time";
    word4.position = 0.843;
    [self.view addSubview:word4];
    [word4 release];
    
    Word *word5 = [[Word alloc]initWithFrame:CGRectMake(480, 900, 100, 50)];
    word5.text = @"there";
    word5.position = 1.399;
    [self.view addSubview:word5];
    [word5 release];
    
    Word *word6 = [[Word alloc]initWithFrame:CGRectMake(590, 900, 100, 50)];
    word6.text = @"was";
    word6.position = 1.558;
    [self.view addSubview:word6];
    [word6 release];   
    
    [words addObject:word1];
    [words addObject:word2];
    [words addObject:word3];
    [words addObject:word4];
    [words addObject:word5];
    [words addObject:word6];
}
 */

-(void)createWords
{
    //word objects are subclass of UILabel
    //no code written to draw words to correct posisition on screen. used IB for speed    
    
    self.words = [self.view.subviews mutableCopy];
    
    //just keep Word objects
    for (Word *word in self.view.subviews)
    {
        if (![word isKindOfClass:[Word class]])
        {
            [words removeObject:word];
        }
    }
    
    //sort words into correct order using 'tag' property. This was set manually in IB for speed.
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];    
    [words sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //opened sound file in audacity and manually checked the correct seek point for each word. These are them...
    NSString *seekpoints = @"0.000 0.296 0.673 0.795 1.265 1.370 1.538 1.608 2.020 2.490 2.752 3.349 3.489 3.703 3.842 4.011 4.307";    
    NSArray *seekpointAr = [seekpoints componentsSeparatedByString:@" "];        

    for (int i = 0; i < [words count]; i++)
    {
        Word *word = [words objectAtIndex:i];        
        
        //set the 'position' (should be called seekPoint) property of each word 
        word.position = (NSTimeInterval)[[seekpointAr objectAtIndex:i]  doubleValue];
        
        NSLog(@"tag: %i, pos: %f",word.tag, word.position);
        
    }    
}


-(IBAction)sliderValChanged:(id)sender
{

    UISlider *slider = (UISlider*)sender;
    
    [currentWord runWordOffAnim];
    
    self.player.currentTime = self.player.duration * slider.value;
    
    [self setWordPositionForTime:self.player.currentTime];

}


-(void)setWordPositionForTime:(NSTimeInterval)time
{    
    for (int i = 0; i < [words count]; i++)
    {
        if ([(Word*)[words objectAtIndex:i]position] >= time)
        {
            wordPositionCounter = i;
            
            self.player.currentTime = [(Word*)[words objectAtIndex:wordPositionCounter] position];

            break;
        }
    }
}


-(IBAction)play:(id)sender
{
    //pause
    if([self.player isPlaying])
    {
        [timer invalidate];
  
        [self.player pause];
        
        [currentWord runWordOffAnim];
    }
    //play
    else 
    {
        //start a timer which polls the avaudio player obj for it's current position.
        timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(pollPlaybackTime) userInfo:nil repeats:YES];
        
        [self.player play];
    }
}


-(void)pollPlaybackTime
{
    currentPosition = [self.player currentTime];// current playback pos
    
    if(wordPositionCounter < [words count])
    {
        if(currentPosition >= [(Word*)[words objectAtIndex:wordPositionCounter] position])
        {
            if (wordPositionCounter > 0) 
            {
                [[words objectAtIndex:wordPositionCounter - 1] runWordOffAnim];
            }            
            
            //if playback pos is beyond next word in word array set it as the current word
            currentWord = [words objectAtIndex:wordPositionCounter];
            
            //do some animation
            [currentWord runWordOnAnim];
                        
            //inc the counter
            wordPositionCounter++;
        }
    }
    
}

//not used
-(void)setPlayPosition:(NSTimeInterval)pos
{
    self.player.currentTime = self.player.duration / pos;
}


#pragma -
#pragma AVPlayer delegate methods

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) completed
{    
    if (completed == YES) 
    {        
        wordPositionCounter = 0; 
        
        [[words lastObject] runWordOffAnim];
        
        [self.player play];
        
    }
    
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [words release];
    [play release];
    [position release];
    position = nil;
    play = nil;
    [super dealloc];
}

@end
