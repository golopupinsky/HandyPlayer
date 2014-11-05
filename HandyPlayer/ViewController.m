//
//  ViewController.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "ViewController.h"
#import "Notifications.h"

@implementation ViewController
{
    VLCVideoView * videoView;
    VLCMediaPlayer *player;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileDropped:) name:kFileDroppedNotification object:nil];

}

-(void) initVideoView
{
    videoView = [[VLCVideoView alloc] initWithFrame:[self.view frame]];
    [self.view addSubview:videoView];
    [videoView setAutoresizingMask: NSViewHeightSizable|NSViewWidthSizable];
    videoView.fillScreen = YES;
    
    [VLCLibrary sharedLibrary];
    
    player = [[VLCMediaPlayer alloc] initWithVideoView:videoView];
    player.delegate = self;
}


-(void)fileDropped:(NSNotification*)notification
{
    NSString* name = notification.userInfo[@"filename"];
    VLCMedia * media = [VLCMedia mediaWithPath:name];
    [player setMedia:media];
    [player play];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}





@end
