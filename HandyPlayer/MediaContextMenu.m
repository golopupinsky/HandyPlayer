//
//  MediaContextMenu.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 12.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "MediaContextMenu.h"
#import <VLCKit/VLCKit.h>


@implementation MediaContextMenu
{
    __weak IBOutlet NSMenuItem *videoSubmenu;
    __weak IBOutlet NSMenuItem *audioSubmenu;
    __weak IBOutlet NSMenuItem *subtitlesSubmenu;
    NSString *lastFileName;
}

-(bool)isInitializedForFile:(NSString*)fname;
{
    return [lastFileName isEqualToString:fname];
}

-(void)setupWithPlayer:(VLCMediaPlayer*)player
{
    [videoSubmenu setEnabled:player.hasVideoOut];
    [audioSubmenu setEnabled:[player.audioTrackNames count] != 0];
    [subtitlesSubmenu setEnabled:player.hasVideoOut];

    lastFileName = player.media.url.absoluteString;
}

@end
