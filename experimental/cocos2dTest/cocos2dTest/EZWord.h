//
//  EZWord.h
//  cocos2dTest
//
//  Created by Donal O'Brien on 06/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLabelBMFont.h"
#import "cocos2d.h"

@interface EZWord : CCLabelBMFont <CCTargetedTouchDelegate>
{
    NSString *word;
    float seekPoint;
}

@property (nonatomic, retain) NSString *word;
@property float seekPoint;

-(void)runWordOnAnim;
-(void)runWordOffAnim;


@end
