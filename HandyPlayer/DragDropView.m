//
//  DragDropView.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "DragDropView.h"

@implementation DragDropView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects: NSColorPboardType, NSFilenamesPboardType, nil]];
}


-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationEvery;
}


- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender  {
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSArray *droppedItems = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    NSString * filename = [droppedItems objectAtIndex:0];

    
    [self.delegate fileDropped:filename];
    return YES;
}

@end
