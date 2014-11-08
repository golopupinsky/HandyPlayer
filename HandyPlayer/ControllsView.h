//
//  ControllsView.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControllsDelegate.h"

@interface ControllsView : NSView

@property(nonatomic,weak) IBOutlet id<ControllsDelegate> delegate;

@end
