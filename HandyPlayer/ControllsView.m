//
//  ControllsView.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "ControllsView.h"
#import <Carbon/Carbon.h>

@implementation ControllsView
{
    NSMutableArray *eventMonitors;
    BOOL mouseOverControlls;
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
    [self setWantsLayer:true];
    [self.layer setBackgroundColor:CGColorCreateGenericGray(0.5, 0.5)];
    self.layer.cornerRadius = 5;
        
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc]
                                    initWithRect:[self bounds]
                                    options: NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                    owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    trackingArea = [[NSTrackingArea alloc]
//                                    initWithRect: CGRectOffset([self.superview bounds], -self.frame.origin.x, -self.frame.origin.y)
                                    initWithRect: CGRectZero
                                    options: NSTrackingMouseMoved | NSTrackingActiveAlways | NSTrackingInVisibleRect
                                    owner:self userInfo:nil];
    [self.superview addTrackingArea:trackingArea];


    [self addEventMonitors];
}

-(void)addEventMonitors
{
    NSEvent *e;
    eventMonitors = [[NSMutableArray alloc]init];
    
    e = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:
         ^NSEvent *(NSEvent *evt) {
             return [self processKeyboardEvent:evt];
         }];
    [eventMonitors addObject:e];
    
    e = [NSEvent addLocalMonitorForEventsMatchingMask:NSScrollWheelMask handler:
         ^NSEvent *(NSEvent *evt) {
             return [self processMouseWheelEvent:evt];
         }];
    [eventMonitors addObject:e];
    
    e = [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:
         ^NSEvent *(NSEvent *evt) {
             return [self processMouseDownEvent:evt];
         }];
    [eventMonitors addObject:e];
    
    e = [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDraggedMask handler:
         ^NSEvent *(NSEvent *evt) {
             return [self processMouseDragEvent:evt];
         }];
    [eventMonitors addObject:e];

}

-(NSEvent*)processKeyboardEvent:(NSEvent*)evt
{
    switch ([evt keyCode]) {
        case kVK_Return:
            [self.delegate fullscreen];
            return nil;
        case kVK_Space:
            [self.delegate pause];
            return nil;
        default:
            return evt;
    }

}

-(NSEvent*)processMouseWheelEvent:(NSEvent*)evt
{
    [self.delegate incrementVolume: evt.deltaY / 100];

    return nil;
}

-(NSEvent*)processMouseDownEvent:(NSEvent*)evt
{
    static CFTimeInterval firstClick = 0;
    float delta = CACurrentMediaTime() - firstClick;
    
    if(delta < 0.25)
    {//considered as doubleclick
        [self.delegate fullscreen];
    }
    else
    {
        [self.delegate dragStarted];
    }
    
    firstClick = CACurrentMediaTime();
    
    return evt;
}

-(NSEvent*)processMouseDragEvent:(NSEvent*)evt
{
    NSPoint p = [self convertPoint: evt.locationInWindow fromView:nil];
    if( NSPointInRect(p, self.bounds))
        return evt;
    
    [self.delegate drag];
    
    return evt;
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    [self fadeIn];
    [self fadeOutDelayedBy:1];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    mouseOverControlls = true;
}

-(void)mouseExited:(NSEvent *)theEvent
{
    mouseOverControlls = false;
}

-(BOOL) isMousePressed
{
    return false;
    return [NSEvent pressedMouseButtons] & (1<<0);
}

-(void)fadeIn
{
    if(self.alphaValue < 0.99)
        self.animator.alphaValue = 1;
}

-(void)fadeOut
{
    if(self.alphaValue > 0.99)
        self.animator.alphaValue = 0;
}

-(void)fadeOutDelayedBy:(CFTimeInterval)seconds
{
    static int staticRandom;
    int localRandom;
    
    staticRandom = localRandom = rand();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(staticRandom == localRandom)
            if(!mouseOverControlls && ![self isMousePressed])
                [self fadeOut];
    });
}


-(void)dealloc
{
    for (NSEvent *e  in eventMonitors) {
        [NSEvent removeMonitor:e];
    }
}

@end
