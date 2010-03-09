//
//  AutoMoveCentral.m
//  WindowOpener
//
//  Created by Agl on 11.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AutoMoveCentral.h"


@implementation AutoMoveCentral

- (id) init {
	windows = [[NSMutableArray alloc] init];
	return self;
}

- (void) registerWindow:(AutoMoveWindow *)window {
	[windows addObject:window];
	
}

- (void) unregisterWindow:(AutoMoveWindow *)window {
	
	[windows removeObject:window];
	
}

- (NSRect) alterFrameChange:(NSRect)frame :(AutoMoveWindow *)window {
	
	int clip = 14;
	
	NSRect screenFrame = [window getUsableScreen];
	
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
	
	
	if (x < clip && x > -clip) {
		xUpdated = 0;
	}
	
	if (y < clip && y > -clip) {
		yUpdated = 0;
	}
	
	int tmp = screenWidth - rightX;
	
	if (tmp < clip && tmp > -clip) {
		xUpdated = screenWidth - width;
	}
	
	
	tmp = screenHeight - upperY;
	if (tmp < clip && tmp > -clip) {
		y = screenHeight - height;
	}
	
	
	unsigned count = [windows count];
	
	int closestX = clip * 3;
	int closestY = clip * 3;
	BOOL clippedX = NO;
	BOOL clippedY = NO;
	
	
	while (count--) {
		id obj = [windows objectAtIndex:count];
		
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
			
			if (!(xOverlap && yOverlap) && (xOverlap || yOverlap)) { //if windows themselfes are not overlapping but there is a x- or y-overlap
				
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

- (void)setInitialPosition:(AutoMoveWindow *) window {
	
	
	int screenHeight = [window getUsableScreen].size.height;
	int screenWidth = [window getUsableScreen].size.width;
	int windowHeight = [window frame].size.height;
	
	NSRect frame = [window frame];
	
	int startX = 30;
	int startY = screenHeight - (windowHeight + 30);
	
	frame.origin.x = startX;
	frame.origin.y = startY;
	
	//[window setFrameNoCall:frame display:NO animate:NO];
	
	int iterateX = startX;
	int iterateY = startY;
	
	while (iterateX < (screenWidth - 30)) {
		
		if (iterateY < 0) {
			startX += 60;
			iterateX = startX;
			iterateY = startY;
		}
		
		frame.origin.x = iterateX;
		frame.origin.y = iterateY;
		[window setFrameNoCall:frame display:NO animate:NO];
		
		if ([self isAnyBodyAtThisPosition:window]) {
			iterateX += 60;
			iterateY -= 60;
		}
		else {
			return;
		}
		
		
	}
	
		
}

- (BOOL)isAnyBodyAtThisPosition:(AutoMoveWindow *) window {
	
	int count = [windows count];
	
	while (count--) {
		id obj = [windows objectAtIndex:count];
		
		if (window != obj) {
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

- (void) moveAllToTop {
	
	int count = [windows count];
	
	if (count == 0) {
		return;
	}
	
	AutoMoveWindow * win = [windows objectAtIndex:0];
	
	NSRect screen = [win getUsableScreen];
	
	int currentUpperHeight = screen.size.height;
	//int futureUpperHeight = currentUpperHeight;
	int maxWindowHeight = 0;
	int xStart = screen.origin.x;
	int maxRightX = screen.origin.x + screen.size.width;//xStart + screen.size.height;
	int currentLeftX = xStart;
	
	
	int daIndex = 0;
	
	while (count > daIndex) {
		
		win = [windows objectAtIndex:daIndex];
		
		daIndex++;
		
		NSRect frame = [win frame];
		
		if (frame.size.width + currentLeftX >= maxRightX) {
			
			currentUpperHeight = currentUpperHeight - maxWindowHeight;
			
			if (currentUpperHeight <= 20) {
				currentUpperHeight = screen.size.height;
				
				xStart = xStart + 20;
				if (xStart >= 100) {
					xStart = screen.origin.x;
				}
				
			}
			
			currentLeftX = xStart;
			
			maxWindowHeight = 0;
		}
		
		//NSPoint newOrigin = NSMakePoint(currentLeftX, currentUpperHeight - frame.size.height);
		
		frame.origin.x = currentLeftX;
		frame.origin.y = currentUpperHeight - frame.size.height;
		
		//[win setFrameOriginNoCall:newOrigin];
		[win setFrameNoCall:frame display:YES animate:YES];
		
		
		if (frame.size.height > maxWindowHeight) {
			maxWindowHeight = frame.size.height;
		}
		
		currentLeftX = currentLeftX + frame.size.width;
		
	}
	
}

- (void) moveAllToBottom {
	
	int count = [windows count];
	
	if (count == 0) {
		return;
	}
	
	NSRect screen = [[windows objectAtIndex:0] getUsableScreen];
	
	int currentLowerY = screen.origin.y;
	int maxWindowHeight = 0;
	int xStart = screen.origin.x;
	int maxRightX = xStart + screen.size.width;
	int currentLeftX = xStart;
	
	int daIndex = 0;
	
	while (count > daIndex) {
		AutoMoveWindow * win = [windows objectAtIndex:daIndex];
		daIndex++;
		
		NSRect frame = [win frame];
		
		if (frame.size.width + currentLeftX >= maxRightX) {
			
			currentLowerY = currentLowerY + maxWindowHeight;
			
			if (currentLowerY + 50 >= screen.origin.y + screen.size.height) {
				currentLowerY = screen.origin.y;
				
				xStart = xStart + 20;
				if (xStart >= 100) {
					xStart = screen.origin.x;
				}
				
			}
			
			currentLeftX = xStart;
			
			maxWindowHeight = 0;
			
		}
		
		
		
		
		frame.origin.x = currentLeftX;
		frame.origin.y = currentLowerY;
		
		if (currentLowerY + frame.size.height >= screen.origin.y + screen.size.height) {
			frame.origin.y = (screen.origin.y + screen.size.height) - frame.size.height;
		}
		
		[win setFrameNoCall:frame display:YES animate:YES];
		
		if (frame.size.height > maxWindowHeight) {
			maxWindowHeight = frame.size.height;
		}
		
		currentLeftX = currentLeftX + frame.size.width;
		
	}
	
}


@end
