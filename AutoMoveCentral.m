//
//  AutoMoveCentral.m
//  WindowOpener
//
//  Created by Agl on 11.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AutoMoveCentral.h"


@implementation AutoMoveCentral


/**
 * initiates this and creates the windows array
 */
- (id) init {
	windows = [[NSMutableArray alloc] init];
	return self;
}

/**
 * adds the given window to the registered windows
 */
- (void) registerWindow:(AutoMoveWindow *)window {
	[windows addObject:window];
	
}


/**
 * removes the given window from the registered windows
 */
- (void) unregisterWindow:(AutoMoveWindow *)window {
	
	[windows removeObject:window];
	
}

/**
 * alters the given frame to "clip" AutoMoveWindows to each other, when they
 * are moved close to each other
 */
- (NSRect) alterFrameChange:(NSRect)frame :(AutoMoveWindow *)window {
	
	int clip = 14;
	
	NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];//[window getUsableScreen];
	
	int x = frame.origin.x;
	int y = frame.origin.y;
	int xUpdated = x;
	int yUpdated = y;
	int width = frame.size.width;
	int height = frame.size.height;
	int rightX = x + width;
	int upperY = y + height;
	int screenHeight = screenFrame.size.height;
	int screenWidth = screenFrame.size.width;
	
	// we are close to the left screen edge
	if (x < clip && x > -clip) {
		xUpdated = 0;
	}
	
	// we are close to the bottom edge
	if (y < clip && y > -clip) {
		yUpdated = 0;
	}
	
	int tmp = screenWidth - rightX;
	
	
	// we are close to the right edge
	if (tmp < clip && tmp > -clip) {
		xUpdated = screenWidth - width;
	}
	
	// we are close to the top edge
	tmp = screenHeight - upperY;
	if (tmp < clip && tmp > -clip) {
		y = screenHeight - height;
	}
	
	
	unsigned count = [windows count];
	
	int closestX = clip * 3;
	int closestY = clip * 3;
	BOOL clippedX = NO;
	BOOL clippedY = NO;
	
	
	while (count--) { //for all windows:
		
		id obj = [windows objectAtIndex:count];
		
		//only if it's not the window to be altered
		if (obj != window) {
			
			AutoMoveWindow *amw = obj;
			
			BOOL xOverlap = NO;
			BOOL yOverlap = NO;
			
			NSRect testFrame = [amw frame];
			
			int xLeftTest = testFrame.origin.x;
			int xRightTest = testFrame.origin.x + testFrame.size.width;
			int yDownTest = testFrame.origin.y;
			int yUpTest = testFrame.origin.y + testFrame.size.height;
			
			
			if ( x >= xLeftTest && x <= xRightTest ) { // -> left corner x is enclosed by other window x
				xOverlap = YES;
			}
			
			if (rightX >= xLeftTest && rightX <= xRightTest) { // -> right corner x is enclosed by other window x
				xOverlap = YES;
			}
			
			if (x <= xLeftTest && rightX >= xRightTest) { // -> we are bigger than the other window but still overlap
				xOverlap = YES;
			}
			
			if ( y >= yDownTest && y <= yUpTest ) {
				yOverlap = YES;
			}
			
			if ( upperY >= yDownTest && upperY <= yUpTest ) {
				yOverlap = YES;
			}
			
			if (y <= yDownTest && upperY >= yUpTest) {
				yOverlap = YES;
			}
			
			if (!(xOverlap && yOverlap) && (xOverlap || yOverlap)) { //if windows themselfes are not overlapping but there is a x- or y-overlap (i.e. not both)
				
				if (xOverlap) {
					//no yOverlap -> this window must be to the above or bellow the other one
					
					BOOL didUpdate = NO;
					
					if ( y < yDownTest ) { // we are bellow
						int distance = yDownTest - upperY;
						
						if (distance < closestY && distance < clip) { // -> bring them close
							yUpdated = (y + distance) - 1;
							//xUpdated = x;
							closestY = distance;
							clippedY = YES;
							didUpdate = YES;
						}
					}
					else {   // we are above
						int distance = y - yUpTest;
						
						if (distance < closestY && distance < clip) { // -> bring them close
							yUpdated = (y - distance) + 1;
							//xUpdated = x;
							closestY = distance;
							clippedY = YES;
							didUpdate = YES;
						}
						
					}
					
					if (didUpdate && !clippedX) { // -> alligne Edges?
						int distLeft = xLeftTest - x;
						int distRight = xRightTest - rightX;
						
						if ( distLeft * distLeft < clip * clip) {
							xUpdated = x + distLeft;
						}
						
						if (distRight * distRight < clip * clip && distRight * distRight < distLeft * distLeft) {
							xUpdated = x + distRight;
						}
						
					}/* */

					
				}
				else { // must be yOverlap
					
					BOOL didUpdate = NO;
					
					if ( x < xLeftTest) { //we are at the left side
						
						int distance = xLeftTest - rightX;
						
						if (distance < closestX && distance < clip) { // -> bring them close
							xUpdated = x + distance -1;
							//yUpdated = y;
							closestX = distance;
							clippedX = YES;
							didUpdate = YES;
						}
						
					}
					else { // we are on the right side
						int distance = x - xRightTest;
						
						if (distance < closestX && distance < clip) { // -> bring them close
							xUpdated = (x - distance) + 1;
							//yUpdated = y;
							closestX = distance;
							clippedX = YES;
							didUpdate = YES;
						}
						
					}
					
					if (didUpdate && !clippedY) { // -> alligne Edges?
						int distDown = yDownTest - y;
						int distUp = yUpTest - upperY;
						
						if ( distDown * distDown < clip * clip) {
							yUpdated = y + distDown;
						}
						
						if (distUp * distUp < clip * clip && distUp * distUp < distDown * distDown) {
							yUpdated = y + distUp;
						}
						
					}

					
				}

				
			}
			
		}
		
	}
	
	
	NSRect ret = NSMakeRect(xUpdated, yUpdated, width, height);
	return ret;
	
	
}

/**
 * Sets a (new) window wo its initial position. If an other window is allready
 * at this position, a new position is computed and so on . . . 
 */
- (void)setInitialPosition:(AutoMoveWindow *) window {
	
	
	NSRect visibleScreen = [[NSScreen mainScreen] visibleFrame];
	
	int screenHeight = visibleScreen.size.height + visibleScreen.origin.y;
	int screenWidth = visibleScreen.size.width + visibleScreen.origin.x;
	int screenLeftStart = visibleScreen.origin.x;
	int screenLowerStart = visibleScreen.origin.y;
	int windowHeight = [window frame].size.height;
	
	NSRect frame = [window frame];
	
	int startX = screenLeftStart;
	int startY = screenHeight - windowHeight;
	
	frame.origin.x = startX;
	frame.origin.y = startY;
	
	int iterateX = startX;
	int iterateY = startY;
	
	while (iterateX < (screenWidth - 30)) {
		
		if (iterateY < screenLowerStart) {
			startX += 100;
			iterateX = startX;
			iterateY = startY;
		}
		
		frame.origin.x = iterateX;
		frame.origin.y = iterateY;
		[window setFrameNoCall:frame display:NO animate:NO];
		
		if ([self isAnyBodyAtThisPosition:window]) {
			iterateX += 30;
			iterateY -= 30;
		}
		else {
			return;
		}
		
		
	}
	
		
}

/**
 * returnes wether thers is allready another window at this position
 */
- (BOOL)isAnyBodyAtThisPosition:(AutoMoveWindow *) window {
	
	int count = [windows count];
	
	while (count--) {
		id obj = [windows objectAtIndex:count];
		
		if (window != obj) { //only if it's not the given window
			AutoMoveWindow *w = obj;
			NSPoint wRec1 = [window frame].origin;
			NSPoint wRec2 = [w frame].origin;
			
			if (wRec1.x == wRec2.x && wRec1.y == wRec2.y) {
				return YES;
			}
		}

		
	}
	
	return NO;
	
}

/**
 * moves all windows to the top of the screen. If a line is full the next line
 * is set bellow the highest one of the previous one.
 */
- (void) moveAllToTop {
	
	int count = [windows count];
	
	if (count == 0) {
		return;
	}
	
	AutoMoveWindow * win = nil;
	
	NSRect screen = [[NSScreen mainScreen]visibleFrame];//[win getUsableScreen];
	
	
	int screenHight = screen.size.height + screen.origin.y;
	int currentUpperHeight = screenHight;
	int maxWindowHeight = 0;
	int xStart = screen.origin.x;
	int maxRightX = screen.origin.x + screen.size.width;//xStart + screen.size.height;
	int currentLeftX = xStart;
	
	ManhattenAnimator * animator = [[ManhattenAnimator alloc] init];
	
	
	int daIndex = 0;
	
	// set the windows
	while (count > daIndex) {
		
		win = [windows objectAtIndex:daIndex];
		
		daIndex++;
		
		NSRect frame = [win frame];
		
		//if the current window is to broad for the current line, start a new one
		if (frame.size.width + currentLeftX >= maxRightX) {
			
			currentUpperHeight = currentUpperHeight - maxWindowHeight;
			
			//if we have almost reached the bottom of the screen, jump back to
			//top and start again from a little x-offset
			if (currentUpperHeight - frame.size.height <= screen.origin.y) {
				currentUpperHeight = screenHight;
				
				xStart = xStart + 20;
				if (xStart >= 100) {
					xStart = screen.origin.x;
				}
				
			}
			
			currentLeftX = xStart;
			
			maxWindowHeight = 0;
		}
		
		//set the windows new position
		frame.origin.x = currentLeftX;
		frame.origin.y = currentUpperHeight - frame.size.height;
		
		//[win setFrameNoCall:frame display:YES animate:YES];
		// AXELS_TODO [win setFrameManhattenAnimation:frame];
		[animator registerForAnimation:win withEndFrame:frame];
		
		
		//check if this is the currently highest window in the current line
		if (frame.size.height > maxWindowHeight) {
			maxWindowHeight = frame.size.height;
		}
		
		//itterate the x position
		currentLeftX = currentLeftX + frame.size.width;
		
	}
	
	[animator animateAll];
	
}

/**
 * moves all windows to the bottom of the screen and starts new lines if not all
 * of them fit there
 */
- (void) moveAllToBottom {
	
	int count = [windows count];
	
	if (count == 0) { //no windows. Quick end
		return;
	}
	
	NSRect screen = [[NSScreen mainScreen]visibleFrame];//[[windows objectAtIndex:0] getUsableScreen];
	
	int currentLowerY = screen.origin.y;
	int maxWindowHeight = 0;
	int xStart = screen.origin.x;
	int maxRightX = xStart + screen.size.width;
	int currentLeftX = xStart;
	
	int daIndex = 0;
	
	ManhattenAnimator * animator = [[ManhattenAnimator alloc] init];
	
	
	// for all windows ...
	while (count > daIndex) {
		AutoMoveWindow * win = [windows objectAtIndex:daIndex];
		daIndex++;
		
		NSRect frame = [win frame];
		
		//if the current window is to broad for the rest of the line...
		if (frame.size.width + currentLeftX >= maxRightX) {
			
			//one line higher
			currentLowerY = currentLowerY + maxWindowHeight;
			
			// if we almost reached the top of the screen, jump back to bottom
			// and continue with a little x offset
			if (currentLowerY + 50 >= screen.origin.y + screen.size.height) {
				currentLowerY = screen.origin.y;
				
				xStart = xStart + 20;
				if (xStart >= 100) {
					xStart = screen.origin.x;
				}
				
			}
			
			//reset to left edge
			currentLeftX = xStart;
			
			maxWindowHeight = 0;
			
		}
		
		
		//set new window position
		frame.origin.x = currentLeftX;
		frame.origin.y = currentLowerY;
		
		//if we're to high (so the title bar would be out of the visible space)
		if (currentLowerY + frame.size.height >= screen.origin.y + screen.size.height) {
			frame.origin.y = (screen.origin.y + screen.size.height) - frame.size.height;
		}
		
		//[win setFrameNoCall:frame display:YES animate:YES];
		// AXELS_TODO [win setFrameManhattenAnimation:frame];
		[animator registerForAnimation:win withEndFrame:frame];
		
		// check if this is the highest window in the current line
		if (frame.size.height > maxWindowHeight) {
			maxWindowHeight = frame.size.height;
		}
		
		// itterate x position
		currentLeftX = currentLeftX + frame.size.width;
		
	}
	
	[animator animateAll];
	
}

- (void) moveAllToRight {
	
	int count = [windows count];
	
	if (count == 0) {
		return;
	}
	
	//AutoMoveWindow * win = nil;
	
	NSRect screen = [[NSScreen mainScreen]visibleFrame];
	
	int screenHeight = screen.size.height + screen.origin.y;
	int minLeftX = screen.origin.x;
	int minLowerY = screen.origin.y;
	int maxWindowWidth = 0;
	int currentUpperY = screenHeight;
	int xStart = screen.origin.x;
	int currentRightX = xStart;
	
	ManhattenAnimator * animator = [[ManhattenAnimator alloc] init];
	int daIndex = 0;
	
	while (daIndex < count) {
		AutoMoveWindow * win = [windows objectAtIndex:daIndex];
		daIndex++;
		
		NSRect frame = [win frame];
		
		//if the current window is to high for the rest of the collumn
		if (currentUpperY - frame.size.height <= minLowerY) {
			
			//one column to the left
			currentRightX -= maxWindowWidth;
			
			currentUpperY = screenHeight;
			
			maxWindowWidth = 0;
		}
		
		//this window would hit the left border . . . 
		if ( currentRightX - frame.size.width < minLeftX) {
			
			xStart -= 30;
			
			if (xStart <= (screen.size.width + screen.origin.x) - 100) {
				xStart = screen.size.width + screen.origin.x;
			}
			
			currentRightX = xStart;
			currentUpperY = screenHeight;
			maxWindowWidth = 0;
			
		}
		
		//set new window position
		frame.origin.x = currentRightX - frame.size.width;
		frame.origin.y = currentUpperY - frame.size.height;
		
		[animator registerForAnimation:win withEndFrame:frame];
		
		if (frame.size.width > maxWindowWidth) {
			maxWindowWidth = frame.size.width;
		}
		
		//itterate y position
		currentUpperY -= frame.size.height + 1;
		
	}
	
	[animator animateAll];
	
}

- (void) moveAllToLeft {
	
	int count = [windows count];
	
	if (count == 0) {
		return;
	}
	
	NSRect screen = [[NSScreen mainScreen]visibleFrame];
	
	int screenHeight = screen.size.height + screen.origin.y;
	int maxRightX = screen.size.width + screen.origin.x;
	int minLowerY = screen.origin.y;
	int maxWindowWidth = 0;
	int currentUpperY = screenHeight;
	int xStart = screen.origin.x;
	int currentLeftX = xStart;
	
	ManhattenAnimator * animator = [[ManhattenAnimator alloc] init];
	int daIndex = 0;
	
	while (daIndex < count) {
		AutoMoveWindow * win = [windows objectAtIndex:daIndex];
		daIndex++;
		
		NSRect frame = [win frame];
		
		//if current window is to high for the rest of the collumn
		if (currentUpperY - frame.size.height <= minLowerY) {
			
			//one column to to the right and up
			currentLeftX += maxWindowWidth;
			currentUpperY = screenHeight;
			maxWindowWidth = 0;
			
		}
		
		//if this window would hit the right border
		if (currentLeftX + frame.size.width >= maxRightX) {
			xStart += 30;
			
			if (xStart >= screen.origin.x + 120) {
				xStart = screen.origin.x;
			}
			
			currentLeftX = xStart;
			currentUpperY = screenHeight;
			maxWindowWidth = 0;
			
		}
		
		//set new window position
		frame.origin.x = currentLeftX;
		frame.origin.y = currentUpperY - frame.size.height;
		
		[animator registerForAnimation:win withEndFrame:frame];
		
		if (frame.size.width > maxWindowWidth) {
			maxWindowWidth = frame.size.width;
		}
		
		//itterate y positon
		currentUpperY -= frame.size.height + 1;
		
	}
	
	[animator animateAll];
	
}

// stacks the windows in the current order
- (void) stackWindowsInCurrentOrder {
	
	int count = [windows count];
	
	if (count == 0) {
		return;
	}
	
	NSRect screen = [[NSScreen mainScreen]visibleFrame];//[[windows objectAtIndex:0] getUsableScreen];
	
	int daIndex = 0;
	
	
	int maxY = screen.origin.y + screen.size.height;
	int minY = screen.origin.y;
	int maxX = screen.origin.x + screen.size.width;
	int minX = screen.origin.x;
	
	int xStart = minX;
	int currentLeftX = xStart;
	int currentUpperY = maxY;
	
	ManhattenAnimator * animator = [[ManhattenAnimator alloc] init];
	
	// for every window
	while (daIndex < count) {
		AutoMoveWindow * win = [windows objectAtIndex:daIndex];
		daIndex++;
		
		NSRect frame = [win frame];
		
		// if we reached the bottom or the right edge, reset to the next
		// top-left starting point
		if ( currentUpperY - frame.size.height < minY ||
			 currentLeftX + frame.size.width > maxX) {
			
			xStart = xStart + 100;
			currentLeftX = xStart;
			currentUpperY = maxY;
			
		}
		
		//set the new frames position
		
		frame.origin.y = currentUpperY - frame.size.height;
		frame.origin.x = currentLeftX;
		[win orderFront:self];
		/*[win setFrameNoCall:frame display:YES animate:YES];
		
		
		frame = [win frame];
		
		frame.origin.x = currentLeftX;
		[win setFrameNoCall:frame display:YES animate:YES];*/
		
		
		// AXELS_TODO [win setFrameManhattenAnimation:frame];
		[animator registerForAnimation:win withEndFrame:frame];
		
		/*FrameWrapper * wr = [[FrameWrapper alloc]init];
		[wr setFrame:frame];
		[NSThread detachNewThreadSelector:@selector(setFrameManhattenAnimationWithWrapper:) toTarget:win withObject:wr];
		/* */
		
		//itterate for next window
		//currentLeftX += 15;
		currentUpperY -= 18;
		
		
		
	}
	
	[animator animateAll];
	
}

/*- (void) orderAccordingToColor {
	
	NSMutableArray * ordereredWindows = [[NSMutableArray alloc] init];
	
	NSEnumerator * enu = [windows objectEnumerator];
	
	AutoMoveWindow * sticky = nil;
	
	while ((sticky = [enu nextObject])) {
		if ([[sticky controler] isYellow]) {
			[ordereredWindows insertObject:sticky atIndex:0];
		}
	}
	
	while ((sticky = [enu nextObject])) {
		if ([[sticky controler] isViolet]) {
			[ordereredWindows insertObject:sticky atIndex:0];
		}
	}
	
	while ((sticky = [enu nextObject])) {
		if ([[sticky controler] isPink]) {
			[ordereredWindows insertObject:sticky atIndex:0];
		}
	}
	
	while ((sticky = [enu nextObject])) {
		if ([[sticky controler] isGrey]) {
			[ordereredWindows insertObject:sticky atIndex:0];
		}
	}
	
	while ((sticky = [enu nextObject])) {
		if ([[sticky controler] isGreen]) {
			[ordereredWindows insertObject:sticky atIndex:0];
		}
	}
	
	while ((sticky = [enu nextObject])) {
		if ([[sticky controler] isBlue]) {
			[ordereredWindows insertObject:sticky atIndex:0];
		}
	}
	
	[windows release];
	
	windows = ordereredWindows;
	
} */


@end
