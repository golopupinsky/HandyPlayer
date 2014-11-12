//
//  VolumeIndicator.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 08.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControllsDelegate.h"

@interface VolumeIndicatorView : NSView

@property (nonatomic,weak) IBOutlet id<ControllsDelegate> delegate;

@end