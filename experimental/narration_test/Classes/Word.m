//
//  Word.m
//  eco zico test
//
//  Created by Donal O'Brien on 10/04/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import "Word.h"


@implementation Word

@synthesize position, parentVC;

-(id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        self.font = [UIFont systemFontOfSize:30];
    }
    
    return self;
}

-(void)runWordOnAnim
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationRepeatCount:2.0];
    [UIView setAnimationRepeatAutoreverses:YES];
    
    self.textColor = [UIColor redColor];
    
    [UIView commitAnimations];    
    
//    [parentVC wordWasSelected];
}


-(void)runWordOffAnim
{
    self.textColor = [UIColor blackColor];
}

@end
