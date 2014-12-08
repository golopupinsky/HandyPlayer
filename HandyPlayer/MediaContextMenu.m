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
    VLCMediaPlayer *mediaPlayer;
}

-(bool)isInitializedForFile:(NSString*)fname;
{
    return [lastFileName isEqualToString:fname];
}

-(void)setupWithPlayer:(VLCMediaPlayer*)player
{
    mediaPlayer = player;
    [self setupVideoSubmenu];
    [self setupAudioSubmenu];
    [self setupSubsSubmenu];

    lastFileName = player.media.url.absoluteString;
}

-(void)setupVideoSubmenu
{
    [videoSubmenu.submenu removeAllItems];
    [videoSubmenu setEnabled:mediaPlayer.hasVideoOut];
    
    //setup screenshot item + separator
    NSMenuItem *screenshotItem = [[NSMenuItem alloc]initWithTitle:@"Save screenshot to Desktop" action:@selector(takeScreenshot) keyEquivalent:@""];
    [screenshotItem setTarget:self];
    [videoSubmenu.submenu addItem:screenshotItem];
    NSMenuItem *separatorItem = [NSMenuItem separatorItem];
    [videoSubmenu.submenu addItem:separatorItem];

    //setup video tracks
    if(videoSubmenu.enabled)
    {
        for (NSString *s in mediaPlayer.videoTrackNames) {
            NSUInteger idx = [mediaPlayer.videoTrackNames indexOfObject:s];

            NSMenuItem *item = [[NSMenuItem alloc]initWithTitle:s action:@selector(pickVideoTrack:) keyEquivalent:@""];
            item.state = mediaPlayer.currentVideoTrackIndex == [(NSNumber*) mediaPlayer.videoTrackIndexes[idx] integerValue];
            [item setTarget:self];
            
            [videoSubmenu.submenu addItem:item];
        }
    }
}

-(void)setupAudioSubmenu
{
    [audioSubmenu.submenu removeAllItems];

    [audioSubmenu setEnabled:[mediaPlayer.audioTrackNames count] != 0];
    if(audioSubmenu.enabled)
    {
        for (NSString *s in mediaPlayer.audioTrackNames) {
            NSUInteger idx = [mediaPlayer.audioTrackNames indexOfObject:s];
            
            NSMenuItem * item = [[NSMenuItem alloc]initWithTitle:s action:@selector(pickAudioTrack:) keyEquivalent:@""];
            item.state = mediaPlayer.currentAudioTrackIndex == [(NSNumber*) mediaPlayer.audioTrackIndexes[idx] integerValue];
            [item setTarget:self];
            
            [audioSubmenu.submenu addItem:item];
        }
    }
}

-(void)setupSubsSubmenu
{
    [subtitlesSubmenu.submenu removeAllItems];

    [subtitlesSubmenu setEnabled:mediaPlayer.hasVideoOut && [mediaPlayer.videoSubTitlesNames count] > 0];
    if(subtitlesSubmenu.enabled)
    {
        for (NSString *s in mediaPlayer.videoSubTitlesNames) {
            NSUInteger idx = [mediaPlayer.videoSubTitlesNames indexOfObject:s];
            
            NSMenuItem * item = [[NSMenuItem alloc]initWithTitle:s action:@selector(pickSubsTrack:) keyEquivalent:@""];
            item.state = mediaPlayer.currentVideoSubTitleIndex == [(NSNumber*) mediaPlayer.videoSubTitlesIndexes[idx] integerValue];
            [item setTarget:self];
            
            [subtitlesSubmenu.submenu addItem:item];
        }
    }
    //external subtitles sources
    NSMenuItem *externalSubtitlesItem = [[NSMenuItem alloc]initWithTitle:@"From file..." action:@selector(pickSubtitlesFile) keyEquivalent:@""];
    [externalSubtitlesItem setTarget:self];
    [subtitlesSubmenu.submenu addItem:externalSubtitlesItem];
}

-(void)takeScreenshot
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    [mediaPlayer saveVideoSnapshotAt:path withWidth:0 andHeight:0];
}

-(void)pickSubtitlesFile
{
    NSString *path = [self chooseFile];
    if (path != nil)
    {
        [mediaPlayer openVideoSubTitlesFromFile:path];
    }
}

-(NSString*)chooseFile
{
    NSPanel *panel;
    NSInteger clicked;
    panel = [NSOpenPanel openPanel];
    [(NSOpenPanel*)panel setCanChooseFiles:YES];
    [(NSOpenPanel*)panel setCanChooseDirectories:NO];
    clicked = [(NSOpenPanel*)panel runModal];
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [(NSOpenPanel*)panel URLs]) {
            return  [url path];
        }
    }
    
    return nil;
}


-(void)pickVideoTrack:(NSMenuItem*)sender
{
    //TODO: this function sometimes hides controlls. move them to top after call
    NSUInteger idx = [mediaPlayer.videoTrackNames indexOfObject:sender.title];
    NSUInteger properIdx = [(NSNumber*) mediaPlayer.videoTrackIndexes[idx] integerValue];
    mediaPlayer.currentVideoTrackIndex = properIdx;
    
    [self unsetStateForChildren:sender.parentItem];
    sender.state = 1;
}

-(void)pickAudioTrack:(NSMenuItem*)sender
{
    NSUInteger idx = [mediaPlayer.audioTrackNames indexOfObject:sender.title];
    NSUInteger properIdx = [(NSNumber*) mediaPlayer.audioTrackIndexes[idx] integerValue];
    mediaPlayer.currentAudioTrackIndex = properIdx;

    [self unsetStateForChildren:sender.parentItem];
    sender.state = 1;
}

-(void)pickSubsTrack:(NSMenuItem*)sender
{
    NSUInteger idx = [mediaPlayer.videoSubTitlesNames indexOfObject:sender.title];
    NSUInteger properIdx = [(NSNumber*) mediaPlayer.videoSubTitlesIndexes[idx] integerValue];
    mediaPlayer.currentVideoSubTitleIndex = properIdx;

    [self unsetStateForChildren:sender.parentItem];
    sender.state = 1;
}

-(void)unsetStateForChildren:(NSMenuItem*)parent
{
    for(NSMenuItem *i in parent.submenu.itemArray)
    {
        i.state=0;
    }
}

@end
