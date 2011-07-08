//
//  EZWord.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 06/05/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EZWord : NSObject {
    NSString *text;
    NSNumber *seekPoint;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *seekPoint;

- (id)initWithText:(NSString *)word andSeekPoint:(NSNumber *)milliseconds;
- (id)generateEZWordLabel;

@end