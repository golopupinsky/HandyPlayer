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

@implementation ViewController
{
    VLCVideoView * videoView;
    VLCMediaPlayer *player;
    __weak IBOutlet MediaProgressView *mediaProgressView;
    __weak IBOutlet ControllsView *controllsView;
    BOOL isSeekeng;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideoView];
    [self initControlls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileDropped:) name:kFileDroppedNotification object:nil];
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
}

-(void)initControlls
{
    mediaProgressView.delegate = self;
    ((DragDropView*) self.view).delegate = self;
}


-(void)fileDropped:(NSString*)name
{
    mediaProgressView.enabled = true;
    
    VLCMedia * media = [VLCMedia mediaWithPath:name];
    [player setMedia:media];
    [player play];
}

- (IBAction)play:(id)sender {
    
    if([player isPlaying])
    {
        [player pause];
    }
    else
    {
        [player play];
    }

}

- (IBAction)seek:(MediaProgressView*)sender {
    NSLog(@"set to:%f",sender.floatValue);
    player.position = sender.floatValue / (player.time.intValue + -player.remainingTime.intValue);
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
    [self bringControllsToFront];
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
    if(!isSeekeng)
    {
        mediaProgressView.minValue = 0;
        mediaProgressView.maxValue = player.time.intValue + -player.remainingTime.intValue;
        mediaProgressView.doubleValue = player.time.intValue;
    }
}

@end
