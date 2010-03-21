//
//  BorderlessWindow.h
//  WindowOpener
//
//  Created by Agl on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AutoMoveWindow.h"
#import "BorderlessWindowControler.h"

@class BorderlessWindowControler;

@interface BorderlessWindow : AutoMoveWindow {

	/*BOOL shouldDrag;
	BOOL shouldRedoInitials;
	NSPoint initialLocation;
	NSPoint initialLocationOnScreen;
	NSRect initialFrame;
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect screenFrame;
	NSRect windowFrame;
	float minY; /* */
	BOOL dragAction;
	BOOL resizeAction;
	NSPoint initialLocationInWindow;
	NSPoint initialLocationOnScreen;
	//NSPoint initialWindowLocation;
	NSRect initialWindowFrame;
	int draggingSpaceHeight;
	int draggingSpaceLeftOffset;
	int draggingSpaceRightOffset;
	int resizingSpaceHeight;
	int resizingSpaceWidth;/* */
	int windowToolBarHeight;
	int minWindowWidth;
	int minWindowHeight;
	BorderlessWindowControler *controler;
	int unminimizedHeight;
	BOOL isMinimized;
	
}

- (int) getResizingSpaceHeight;
- (int) getResizingSpaceWidth;
- (int) getDraggingSpaceHeight;
- (void) mouseDownNoWindowAction:(NSEvent *) theEvent;
- (void) mouseDraggedNoWindowAction:(NSEvent *) theEvent;
- (void) mouseUpNoWindowAction:(NSEvent *) theEvent;
- (void) doMouseDownWork:(NSPoint) locationInWindow;
- (BOOL) draggingMode;
- (BOOL) resizingMode;
- (void) setResizingSpaceHeight:(int) height;
- (void) setResizingSpaceWidth:(int) width;
- (void) setDraggingSpaceHeight:(int) height;
- (void) setDraggingOffsetLeft:(int) draggingOffsetLeft;
- (void) setDraggingOffsetRight:(int) draggingOffsetLeft;
- (void) setWindowToolbarHeight:(int) height;
- (void) setMinWindowHeight:(int) min;
- (void) setMinWindowWidth:(int) min;
- (void) init:(BorderlessWindowControler *) contr;
- (void) textContentDidChange;

- (void) minimize;
- (void) unminimize;
- (void) minimizeToggle;
- (BOOL) isMimimized;


@end
