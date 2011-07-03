//
//  EZWord.h
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EZWord : NSObject {
    NSString *text;
    NSNumber *seekPoint;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *seekPoint;

- (id)initWithText:(NSString *)word andSeekPoint:(NSNumber *)milliseconds;

@end
