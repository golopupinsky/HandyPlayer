//
//  AppDelegate.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "AppDelegate.h"
#import "DragDropDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSWindow *w = [NSApplication sharedApplication].windows[0];
    
    [(id<DragDropDelegate>) w.contentViewController fileDropped:filename];

    return true;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
