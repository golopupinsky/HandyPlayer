//
//  MediaProgressView.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "MediaProgressView.h"

#define kKnobWidth      2
#define kKnobHeight     10
#define kBarHeight      2
@implementation MediaProgressView
{
    NSImageView *bar;
    NSImageView *knob;
}

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
//    knobImage = [NSImage imageNamed:@"hud_slider-knobBlack-N"];
//    [self addHandle:@"High"
//            image:img
//        initRatio:0.0
//       valueBlock:^float(float inVal) {
//           return inVal;
//       }
//    invValueBlock:^float(float inVal) {
//        return inVal;
//    }
//     ];
    
    NSImage *sliderBarImage = [self sliderBarImage];
    float startX = (self.frame.size.width - sliderBarImage.size.width) * 0.5;
    float startY = (self.frame.size.height - sliderBarImage.size.height) * 0.5;
    bar = [[NSImageView alloc] initWithFrame:NSMakeRect(startX, startY, sliderBarImage.size.width, sliderBarImage.size.height)];
    bar.image = sliderBarImage;
    [self addSubview:bar];

    NSImage *knobImage = [self knobImage];
    startX = (self.frame.size.width - knobImage.size.width) * 0.5;
    startY = (self.frame.size.height - knobImage.size.height) * 0.5;
    knob = [[NSImageView alloc] initWithFrame:NSMakeRect(0, startY, knobImage.size.width, knobImage.size.height)];
    knob.image = knobImage;
    [self addSubview:knob];


}

- (NSImage *)sliderBarImage
{
    NSImage *barImage = [[NSImage alloc] initWithSize:NSMakeSize(self.bounds.size.width, kBarHeight)];
    [barImage lockFocus];
    [[NSColor blackColor] set];
    NSRectFill(NSMakeRect(0, 0, barImage.size.width, barImage.size.height));
    [barImage unlockFocus];
    return barImage;
}

- (NSImage *)knobImage
{
    NSImage *knobImage = [[NSImage alloc] initWithSize:NSMakeSize(kKnobWidth, kKnobHeight)];
    [knobImage lockFocus];
    [[NSColor whiteColor] set];
    NSRectFill(NSMakeRect(0, 0, knobImage.size.width, knobImage.size.height));
    [knobImage unlockFocus];
    return knobImage;
}


- (void)mouseDown:(NSEvent *)theEvent
{
    [self.delegate seekStarted];
    [self drag:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [self drag:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [self.delegate seek:self.floatValue];
    [self.delegate seekEnded];
}

-(void)drag:(NSEvent *)theEvent
{
    NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    float x = MIN( MAX(0,clickPoint.x), bar.frame.size.width - kKnobWidth);
    knob.frame = CGRectMake(x, knob.frame.origin.y, knob.frame.size.width, knob.frame.size.height);
    
}


-(float) floatValue
{
    return knob.frame.origin.x / (bar.frame.size.width - kKnobWidth);
}
-(void) setFloatValue:(float)val
{
    float x = val * (bar.frame.size.width - kKnobWidth);
    knob.frame = CGRectMake(x, knob.frame.origin.y, knob.frame.size.width, knob.frame.size.height);
}


@end
