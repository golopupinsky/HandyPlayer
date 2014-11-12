//
//  MediaContextMenu.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 12.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class VLCMediaPlayer;

@interface MediaContextMenu : NSMenu

-(void)setupWithPlayer:(VLCMediaPlayer*)player;
-(bool)isInitializedForFile:(NSString*)fname;

@end
