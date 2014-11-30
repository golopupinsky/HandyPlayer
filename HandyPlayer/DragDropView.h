//
//  DragDropView.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <VLCKit/VLCKit.h>

@protocol DragDropDelegate <NSObject>
@required
-(void)fileDropped:(NSString*)path;
@end

@interface DragDropView : NSView

@property(nonatomic,weak) IBOutlet id<DragDropDelegate> delegate;

@end
