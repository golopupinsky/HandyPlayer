//
//  DragDropDelegate.h
//  HandyPlayer
//
//  Created by Sergey Yuzepovich on 06.11.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#ifndef HandyPlayer_DragDropDelegate_h
#define HandyPlayer_DragDropDelegate_h

@protocol DragDropDelegate <NSObject>

@required
-(void)fileDropped:(NSString*)path;

@end

#endif
