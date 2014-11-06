//
//  ControllsView.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "ControllsView.h"

@implementation ControllsView
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
    [self setWantsLayer:true];
    [self.layer setBackgroundColor:CGColorCreateGenericGray(0.5, 0.5)];
    self.layer.cornerRadius = 5;
}


@end
