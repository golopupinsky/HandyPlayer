//
//  ViewController.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "ViewController.h"
#import "Notifications.h"
#import "MediaProgressView.h"
#import "ControllsView.h"
#import "DragDropView.h"
#import "MediaContextMenu.h"

@implementation ViewController
{
    VLCVideoView * videoView;
    VLCMediaPlayer *player;

    __weak IBOutlet MediaProgressView *mediaProgressView;
    __weak IBOutlet ControllsView *controllsView;
    __weak IBOutlet NSButton *playButton;
    IBOutlet MediaContextMenu *contextMenu;
    
    BOOL isSeekeng;
    BOOL isDragging;
    NSPoint dragDelta;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideoView];
    [self initControlls];
}

-(void) initVideoView
{
    videoView = [[VLCVideoView alloc] initWithFrame:[self.view frame]];
    [self.view addSubview:videoView positioned:NSWindowBelow relativeTo:mediaProgressView];
    [videoView setAutoresizingMask: NSViewHeightSizable|NSViewWidthSizable];
//    videoView.fillScreen = YES;

    [VLCLibrary sharedLibrary];
    
    player = [[VLCMediaPlayer alloc] initWithVideoView:videoView];
    player.delegate = self;
    [self incrementVolume:0];
}

-(void)initControlls
{
    [self bringControllsToFront];
}


-(void)fileDropped:(NSString*)name
{
    VLCMedia * media = [VLCMedia mediaWithPath:name];
    [player setMedia:media];
    
    [self.view.window setTitle: [name lastPathComponent]];
    
    [self play:nil];
    [self.view setMenu:contextMenu];
}


- (IBAction)play:(id)sender {
    
    if([player isPlaying])
    {
        [player pause];
        [playButton setImage: [NSImage imageNamed:@"play"]];
    }
    else
    {
        [player play];
        [playButton setImage: [NSImage imageNamed:@"pause"]];
    }
}

-(void)pause
{
    [self play:nil];
}

-(void)fullscreen
{
    [self.view.window toggleFullScreen:self];
}

-(void)incrementVolume:(float)byVal
{
    [self setVolume: (float)player.audio.volume / 100 + byVal];
}

-(void)setVolume:(float)toVal
{
    player.audio.volume = toVal * 100;
    [[NSNotificationCenter defaultCenter] postNotificationName:kVolumeChangedNotification object:nil userInfo:@{@"volume":[NSNumber numberWithFloat: (float)player.audio.volume / 100 ]}];
}

-(void)dragStarted
{
    isDragging = true;

    NSPoint mouse = [NSEvent mouseLocation];
    NSPoint window = self.view.window.frame.origin;
    dragDelta = NSMakePoint(window.x - mouse.x, window.y - mouse.y);
}

-(void)drag
{
    if(isDragging)
    {
        NSPoint p = [NSEvent mouseLocation];
        [self.view.window setFrameOrigin: NSMakePoint(p.x + dragDelta.x, p.y + dragDelta.y)];
    }
}

-(void)dragEnded
{
    isDragging = false;
}

- (void)seek:(float)val {
    player.position = val;
}

-(void)seekStarted
{
    isSeekeng = true;
}

-(void)seekEnded
{
    isSeekeng = false;
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    if(player.hasVideoOut)
    {
        CGSize s = player.videoSize;
        [self.view.window.animator setContentSize:s];
    }
}

-(void)bringControllsToFront
{
    [controllsView removeFromSuperview];
    [self.view addSubview:controllsView positioned:NSWindowAbove relativeTo:videoView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:controllsView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:controllsView.superview
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.f constant:0.f];
    
    [self.view addConstraint:c];
    
    NSArray *cc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==163)]"
                                            options: 0
                                            metrics:nil
                                              views:@{@"view" : controllsView}];
    [self.view addConstraints:cc];

    cc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==66)]-6-|"
                                            options: 0
                                            metrics:nil
                                              views:@{@"view" : controllsView}];
    [self.view addConstraints:cc];


}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    float timeLeft = (float) player.time.intValue + -player.remainingTime.intValue;
    float curTime = (float) player.time.intValue;
    
    if(!isSeekeng && timeLeft != 0)
    {
        mediaProgressView.floatValue = curTime / timeLeft;
    }
    
    if(![contextMenu isInitializedForFile:player.media.url.absoluteString])
    {
        //setting up context menu
        [contextMenu setupWithPlayer:player];
        
        //controlls view for some reason goes to background after playback starts
        //so we're moving it to front
        [self bringControllsToFront];
    }
}

@end
