//
//  ControllsDelegate.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#ifndef HandyPlayer_ControllsDelegate_h
#define HandyPlayer_ControllsDelegate_h

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
@end

#endif
