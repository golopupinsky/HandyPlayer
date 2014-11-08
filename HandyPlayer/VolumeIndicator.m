//
//  VolumeIndicator.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 08.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "VolumeIndicator.h"
#import "Notifications.h"

@implementation VolumeIndicator
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
}

-(void)drawBackground
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(self.frame.size.width, self.frame.size.height)];
    [path lineToPoint:NSMakePoint(self.frame.size.width, 0)];
    [path closePath];
    [[NSColor colorWithWhite:0.5 alpha:0.5] set];
    [path fill];
}

-(void)drawVolume
{
    float aspect = self.frame.size.height / self.frame.size.width;
    float w = self.frame.size.width * volume;
    float h = w * aspect;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(w, h)];
    [path lineToPoint:NSMakePoint(w, 0)];
    [path closePath];
    [[NSColor colorWithRed:0 green:1 blue:0 alpha:0.3] set];
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
