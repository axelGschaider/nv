//
//  BorderlessWindow.m
//  WindowOpener
//
//  Created by Agl on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BorderlessWindow.h"


@implementation BorderlessWindow

- (id) initWithContentRect: (NSRect) contentRect
                 styleMask: (NSUInteger) aStyle
                   backing: (NSBackingStoreType) bufferingType
                     defer: (BOOL) flag
{
    if ((self = [super initWithContentRect: contentRect
                                styleMask: NSBorderlessWindowMask
                                  backing: bufferingType
                                    defer: flag]))
		
	 {
		// other initialization
		resizingSpaceWidth = 20;
		resizingSpaceHeight = 20;
		draggingSpaceHeight = 17;
		draggingSpaceLeftOffset = 20;
		draggingSpaceRightOffset = 0;
		windowToolBarHeight = 22;
		minWindowWidth = 50;
		minWindowHeight = 50;
		isMinimized = NO;
		
		//[self minimize];
		
	 }
	
	
    
    return self;
}

- (BOOL) canHide {
	return NO;
	
}

- (BOOL) canBecomeKeyWindow
{
	return YES;
} 





- (BOOL) isMimimized {
	return isMinimized;
	
}



/*- (void)makeKeyAndOrderFront:(id)sender {
	
	NSLog("Bin da!!!!!");
	
	//[super makeKeyAndOrderFront:sender];
	
} /* */

- (void) minimize {
	if (!isMinimized) {
		isMinimized = YES;
		NSRect currentFrame = [self frame];
		
		unminimizedHeight = currentFrame.size.height;
		
		int heightDif = unminimizedHeight - (draggingSpaceHeight);
		
		int x = currentFrame.origin.x;
		int y = currentFrame.origin.y + heightDif;
		int width = currentFrame.size.width;
		int height = draggingSpaceHeight;
		
		NSRect newFrame = NSMakeRect(x, y, width, height);
		
		[self setFrameNoCall:newFrame display:YES animate:YES];
		
		
	}
}

- (void) unminimize {
	
	if (isMinimized) {
		isMinimized = NO;
		
		NSRect currentFrame = [self frame];
		
		int heightDif = unminimizedHeight - draggingSpaceHeight;
		
		int x = currentFrame.origin.x;
		int y = currentFrame.origin.y - heightDif;
		int width = currentFrame.size.width;
		int height = unminimizedHeight;
		
		NSRect newFrame = NSMakeRect(x, y, width, height);
		
		[self setFrameNoCall:newFrame display:YES animate:YES];
		
	}
	
}

- (void) minimizeToggle {
	if (isMinimized) {
		[self unminimize];
	}
	else {
		[self minimize];
	}
	

}

- (void) doMouseDownWork:(NSPoint) locationInWindow {
	//NSPoint tmp = [theEvent locationInWindow];
	initialLocationInWindow = NSMakePoint(locationInWindow.x, locationInWindow.y);
	
	
	
	NSPoint tmp = [self convertBaseToScreen:initialLocationInWindow];
	initialLocationOnScreen = NSMakePoint(tmp.x, tmp.y);
	
	NSRect tmpR = [self frame];
	initialWindowFrame = NSMakeRect(tmpR.origin.x, tmpR.origin.y, tmpR.size.width, tmpR.size.height);
	
	if ( [self resizingMode] ) {
		//NSLog(@"resizingMode");
		resizeAction = YES;
		dragAction = NO;
		
	}
	else {
		
		if ( [self draggingMode] ) {
			//NSLog(@"draggingMode");
			resizeAction = NO;
			dragAction = YES;
		}
		else {
			resizeAction = NO;
			dragAction = NO;
			
		}
	}
	
	/*if (resizeAction || dragAction) {
		NSCursor *cur = [NSCursor currentCursor];
		
		NSPoint p = [cur hotSpot];
		
		[cur initWithImage:[[NSCursor closedHandCursor] image] hotSpot:p ];
		
	} /* */
	
}

- (void)mouseDown:(NSEvent * )theEvent {
	
	
	
	[self doMouseDownWork:[theEvent locationInWindow]];
	
	if (! (resizeAction || dragAction) ) {
		[self mouseDownNoWindowAction:theEvent];
	}
	
} /* */



- (int) getResizingSpaceWidth {
	return resizingSpaceWidth;
}

- (int) getResizingSpaceHeight {
	return resizingSpaceHeight;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint currentLocationOnScreen = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
	
	
	NSRect windowFrame = [self frame];
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	
	if (dragAction) {
		//NSLog(@"dragging");
		int requestedPositionX = currentLocationOnScreen.x - initialLocationInWindow.x;
		int requestedPositionY = currentLocationOnScreen.y - initialLocationInWindow.y;
		
		int maxY = screenFrame.size.height - (windowFrame.size.height + windowToolBarHeight);
		int minY = draggingSpaceHeight - windowFrame.size.height;
		int maxX = screenFrame.size.width - (draggingSpaceLeftOffset + draggingSpaceHeight);
		int minX = (draggingSpaceHeight + draggingSpaceRightOffset) - windowFrame.size.width;
		
		
		if (requestedPositionY > maxY) {
			requestedPositionY = maxY;
		}
		
		if (requestedPositionY < minY) {
			requestedPositionY = minY;
		}
		
		if (requestedPositionX < minX) {
			requestedPositionX = minX;
		}
		
		if (requestedPositionX > maxX) {
			requestedPositionX = maxX;
		}
		
		NSPoint newOrigin = windowFrame.origin;
		newOrigin.x = requestedPositionX;
		newOrigin.y = requestedPositionY;
		
		[self setFrameOrigin:newOrigin];
	
		
	}
	else {
		if (resizeAction) {
			
			//NSLog(@"Resizing");
			
			float xDif = currentLocationOnScreen.x - initialLocationOnScreen.x;
			float yDif = initialLocationOnScreen.y - currentLocationOnScreen.y;
			
			
			if (initialWindowFrame.size.width + xDif < minWindowWidth) {
				xDif = minWindowWidth - initialWindowFrame.size.width;
			}
			
			if (initialWindowFrame.size.height + yDif < minWindowHeight) {
				yDif = minWindowHeight - initialWindowFrame.size.height;
			}
			
			float newY = initialWindowFrame.origin.y - yDif;
			
			float newWidth = initialWindowFrame.size.width + xDif;
			float newHeight = initialWindowFrame.size.height + yDif;
			
			if (isMinimized) {
				newY = initialWindowFrame.origin.y;
				newHeight = initialWindowFrame.size.height;
			}
			
			NSRect newFrame = NSMakeRect(initialWindowFrame.origin.x, newY, newWidth, newHeight);
			//[self setFrame:newFrame display:YES animate:NO];
			//[self setFrameForDragging:newFrame];
			
			
			
			[self setFrameNoCall:newFrame display:YES animate:NO];
		}
		else {
			[self mouseDraggedNoWindowAction:theEvent];
		}
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	
	if (dragAction && [theEvent clickCount] == 2) {
		[controler doubleClickInDragRegion];
	}
	
	if (dragAction || resizeAction) {
		dragAction = NO;
		resizeAction = NO;
	}
	else {
		[self mouseUpNoWindowAction:theEvent]; 
	}
	
}

- (int) getDraggingSpaceHeight {
	return draggingSpaceHeight;
}

- (BOOL)draggingMode {
	return initialLocationInWindow.x > draggingSpaceLeftOffset
		&& initialLocationInWindow.x < (initialWindowFrame.size.width - draggingSpaceRightOffset) 
		&& initialLocationInWindow.y > initialWindowFrame.size.height - draggingSpaceHeight;
}

- (BOOL)resizingMode {
	
	/*int initLocX = initialLocationInWindow.x;
	int initWidth = initialWindowFrame.size.width;
	int initLocY = initialLocationInWindow.y;
	
	NSLog(@"initWLocX_%d > (initWidth_%d - resSpaceWidth_%d)  &&  initWLocY_%d < resSpaceHeight_%d", initLocX, initWidth, resizingSpaceWidth, initLocY, resizingSpaceHeight);/* */
	
	return initialLocationInWindow.x > initialWindowFrame.size.width - resizingSpaceWidth && initialLocationInWindow.y < resizingSpaceHeight;
}



/*- (NSRect) transformToVisibleFrame: (NSRect) frame {
	
	return NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - windowToolBarHeight);
	
} /* */

- (void)mouseDownNoWindowAction:(NSEvent *) theEvent {
	
}
- (void)mouseDraggedNoWindowAction:(NSEvent *) theEvent {
	
}
- (void)mouseUpNoWindowAction:(NSEvent *) theEvent {
	
	
}

- (void)setResizingSpaceWidth:(int)width {
	if (width >= 0) {
		resizingSpaceWidth = width;
	}
}

- (void)setResizingSpaceHeight:(int)height {
	if (height >= 0) {
		resizingSpaceHeight = height;
	}
}

- (void)setDraggingSpaceHeight:(int)height {
	if (height >= 0) {
		draggingSpaceHeight = height;
	}
}

- (void)setDraggingOffsetLeft:(int)draggingOffsetLeft {
	if (draggingOffsetLeft >= 0) {
		draggingSpaceLeftOffset = draggingOffsetLeft;
	}
}

- (void) setDraggingOffsetRight:(int) draggingOffsetRight {
	if (draggingOffsetRight >=0) {
		draggingSpaceRightOffset = draggingOffsetRight;
	}
}
- (void) setWindowToolbarHeight:(int) height {
	if (height >= 0) {
		windowToolBarHeight = height;
	}
}

- (void) setMinWindowWidth:(int)min {
	if (min>= 0) {
		minWindowWidth = min;
	}
}

- (void) setMinWindowHeight:(int)min {
	if (min >= 0) {
		minWindowHeight = min;
	}
}

- (void) init:(BorderlessWindowControler *) contr {
	controler = contr;
	
	
	
	
	
} /* */

- (void) setTitle:(NSString *)aString {
	
	[controler setWindowTitle:aString];
	
}

- (void) textContentDidChange {
	[controler textContentDidChange];
	
}

@end
