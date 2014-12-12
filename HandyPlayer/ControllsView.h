//
//  ControllsView.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ControllsDelegate <NSObject>
@required
-(void)seekStarted;
-(void)seekEnded;
-(void)seek:(float)val;
-(void)pause;
-(void)fullscreen;
-(void)incrementVolume:(float)byVal;
-(void)setVolume:(float)toVal;
-(void)dragStarted;
-(void)drag;
-(void)dragEnded;
@end

@interface ControllsView : NSView

@property(nonatomic,weak) IBOutlet id<ControllsDelegate> delegate;

@end
