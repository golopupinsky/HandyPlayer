//
//  MediaProgressView.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "MediaProgressView.h"

@implementation MediaProgressView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)setup
{
}

-(void)mouseDown:(NSEvent *)theEvent
{
    [self.delegate seekStarted];
    [super mouseDown:theEvent];
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [self.delegate seekEnded];
    [super mouseUp:theEvent];
}

@end
