//
//  ViewController.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <VLCKit/VLCKit.h>
#import "ControllsDelegate.h"
#import "DragDropView.h"

@interface ViewController : NSViewController <VLCMediaPlayerDelegate,ControllsDelegate,DragDropDelegate>


@end

