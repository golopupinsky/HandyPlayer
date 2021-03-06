//
//  MediaProgressView.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControllsView.h"

@interface MediaProgressView : NSControl

@property(nonatomic,weak) IBOutlet id<ControllsDelegate> delegate;

@property float floatValue;

@end
