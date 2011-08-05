//
//  EZBook.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 03/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZBook : NSObject {
    NSArray *pages;    
}

@property (nonatomic, retain) NSArray *pages;

- (id)initWithPlist:(NSString *)aPath;

@end
