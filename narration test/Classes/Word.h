//
//  Word.h
//  eco zico test
//
//  Created by Donal O'Brien on 10/04/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Word : UILabel 
{
    NSTimeInterval position; 
    UIViewController *parentVC;
}

@property (nonatomic, assign) UIViewController *parentVC;
@property NSTimeInterval position;  

-(void)runWordOnAnim;
-(void)runWordOffAnim;




@end
