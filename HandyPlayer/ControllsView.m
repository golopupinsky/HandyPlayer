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
    id eventMonitor;
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
    
//    trackingArea = [[NSTrackingArea alloc]
//                                    initWithRect:[self.superview bounds]
//                                    options: NSTrackingMouseMoved | NSTrackingActiveAlways
//                                    owner:self userInfo:nil];
//    [self addTrackingArea:trackingArea];


    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask|NSScrollWheelMask|NSLeftMouseDownMask handler:
    ^NSEvent *(NSEvent *evt) {
        return [self processEvent:evt];
    }];
}


-(NSEvent*)processEvent:(NSEvent*)evt
{
    if( evt.type == NSKeyDown)
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
    else
    {
        if (evt.type == NSScrollWheel)
        {
            [self.delegate incrementVolume: evt.deltaY / 100];
        }
        else
        {//left mouse down
            static CFTimeInterval firstClick = 0;
            float delta = CACurrentMediaTime() - firstClick;
            
            if(delta < 0.25)
            {//considered as doubleclick
                [self.delegate fullscreen];
            }
            
            firstClick = CACurrentMediaTime();
        }
        
    }
    
    return evt;
}

//-(void)mouseMoved:(NSEvent *)theEvent
//{
//    NSLog(@"mouseMoved");
//}

-(void)mouseEntered:(NSEvent *)theEvent
{
    [self fadeIn];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if( !([NSEvent pressedMouseButtons] & (1<<0)) )
        [self fadeOut];
}

-(void)fadeOut
{
    self.animator.alphaValue = 0;
}

-(void)fadeIn
{
    self.animator.alphaValue = 1;
}

-(void)dealloc
{
    [NSEvent removeMonitor:eventMonitor];
}

@end
