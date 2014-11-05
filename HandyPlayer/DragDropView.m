//
//  DragDropView.m
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 05.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "DragDropView.h"
#import "Notifications.h"

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

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//    
//    // Drawing code here.
//}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
//    NSLog(@"draggingEntered");
    return NSDragOperationEvery;
}

//-(NSDragOperation) draggingUpdated:(id<NSDraggingInfo>)sender
//{
////    NSLog(@"draggingUpdated");
//    return NSDragOperationEvery;
//}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender  {
//    NSLog(@"prepareForDragOperation");
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
//    NSLog(@"performDragOperation");
    NSArray *droppedItems = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    NSString * filename = [droppedItems objectAtIndex:0];

    [[NSNotificationCenter defaultCenter] postNotificationName:kFileDroppedNotification object:nil userInfo:@{@"filename":filename}];
    
    return YES;
}

@end
