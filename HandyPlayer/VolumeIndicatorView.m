//
//  VolumeIndicator.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 08.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "VolumeIndicatorView.h"
#import "Notifications.h"

@implementation VolumeIndicatorView
{
    float volume;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:kVolumeChangedNotification object:nil];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];

    [self drawBackground];
    [self drawVolume];
    [self drawOverload];
}

-(void)drawBackground
{
    [self drawTriangleOfWidht:self.frame.size.width color: [NSColor colorWithWhite:0.5 alpha:0.5] ];
}

-(void)drawVolume
{
    float w = self.frame.size.width * volume;
    
    [self drawTriangleOfWidht:w color: [NSColor  colorWithRed:0 green:1 blue:0 alpha:0.3] ];
}

-(void)drawOverload
{
    float w = self.frame.size.width * (volume-1);
 
    [self drawTriangleOfWidht:w color: [NSColor  colorWithRed:1 green:0 blue:0 alpha:0.3] ];
}

-(void)drawTriangleOfWidht:(float)w color:(NSColor*)color
{
    float aspect = self.frame.size.height / self.frame.size.width;
    float h = w * aspect;

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(w, h)];
    [path lineToPoint:NSMakePoint(w, 0)];
    [path closePath];
    [color set];
    [path fill];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self updateVolume:theEvent];
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    [self updateVolume:theEvent];
}

-(void) updateVolume:(NSEvent *)theEvent
{
    NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    float val = clickPoint.x / self.frame.size.width;
    [self.delegate setVolume:val];
}

-(void)volumeChanged:(NSNotification*)notification
{
    volume = [(NSNumber*) notification.userInfo[@"volume"] floatValue ];
    [self setNeedsDisplay:true];
}

@end
