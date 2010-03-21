//
//  AutoMoveWindow.m
//  WindowOpener
//
//  Created by Agl on 11.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AutoMoveWindow.h"


@implementation AutoMoveWindow

// sets the AutoMoveCentral and registeres itself there
- (void) initWithCentral:(AutoMoveCentral *)daCentral {
	
	central = daCentral;
	[central registerWindow:self];
	currentlyClipped = NO;
	
}

// closes this window and unregisteres itself at the AutoMoveCentral
- (void) close {
	[central unregisterWindow:self];
	[super close];
}

// used to explizitely call setFrame (for position altering)
- (void) setFrameOrigin:(NSPoint)aPoint {
	NSRect daFrame = [self frame];
	
	daFrame.origin.x = aPoint.x;
	daFrame.origin.y = aPoint.y;
	
	[self setFrame:daFrame display:YES animate:NO];
	
}

// used to possibliy alter the original request in order to clip this to the
// screen edge or other windows
- (void)setFrame:(NSRect)windowFrame display:(BOOL)displayViews animate:(BOOL)performAnimation {
	
	//request (possibly) new position
	NSRect newFrame = [central alterFrameChange:windowFrame : self];
	
	BOOL anim = performAnimation;
	
	//animate clipping and unclipping
	if (currentlyClipped) {
		if (newFrame.origin.x == windowFrame.origin.x && newFrame.origin.y == windowFrame.origin.y) {
			anim = YES;
			currentlyClipped = NO;
		}
	}
	else {
		if (newFrame.origin.x != windowFrame.origin.x || newFrame.origin.y != windowFrame.origin.y) {
			anim = YES;
			currentlyClipped = YES;
		}
	}

	
	[super setFrame: newFrame display:displayViews animate:anim];
	
}


/**
 * used to set the position while dragging the window
 */
- (void)setFrameForDragging:(NSRect) aPoint {
	
	NSRect newFrame = [central alterFrameChange:aPoint : self];
	
	if (currentlyClipped) {
		if (newFrame.origin.x == aPoint.origin.x && newFrame.origin.y == aPoint.origin.y) {
			//we just left the clipping region
			currentlyClipped = NO;
		}
	}
	else {
		if (newFrame.origin.x != aPoint.origin.x || newFrame.origin.y != aPoint.origin.y) {
			currentlyClipped = YES;
			
			//Transform so the upper left corner stays in place
			
			if (newFrame.origin.x != aPoint.origin.x) {
				newFrame.origin.x = aPoint.origin.x;
				int rightBound = aPoint.origin.x + aPoint.size.width;
				newFrame.size.width = rightBound - newFrame.origin.x;
			}
			
			if (newFrame.origin.y != aPoint.origin.y) {
				newFrame.origin.y = aPoint.origin.y;
				int upperBound = aPoint.origin.y + aPoint.size.height;
				newFrame.size.height = upperBound - newFrame.origin.y;
			}
			
		}
	}
	
	[super setFrame: newFrame display:YES animate:YES];
	
	
}

/**
 * returns the usable screen (excluding the menu bar and in the future the dock)
 */
- (NSRect) getUsableScreen {
	NSRect f = [[NSScreen mainScreen] frame];
	
	return NSMakeRect(f.origin.x, f.origin.y, f.size.width, f.size.height - 21);
	
}


/**
 * should be used when position alteration is not required
 */
- (void)setFrameNoCall:(NSRect)windowFrame display:(BOOL)displayViews animate:(BOOL)performAnimation {
	[super setFrame: windowFrame display:displayViews animate:performAnimation];
}

/**
 * should be used when position alteration is not required
 */
- (void) setFrameOriginNoCall:(NSPoint)aPoint {
	[super setFrameOrigin:aPoint];
}

- (void)setFrameManhattenAnimation:(NSRect)windowFrame {
	[self setFrameManhattenAnimation:windowFrame min:NO ifMinKeepLeft:NO ifMinKeepBottom:NO];
}

- (void)setFrameManhattenAnimation:(NSRect)windowFrame 
							   min:(BOOL)minimize 
					 ifMinKeepLeft:(BOOL)keepLeft 
				   ifMinKeepBottom:(BOOL)keepBottom {
	
	if (!minimize) {
		
		NSRect f = [self frame];
		
		f.origin.y = windowFrame.origin.y;
		
		[super setFrame: f display:YES animate:YES];
		
		[super setFrame:windowFrame display:YES animate:YES];
		
		return;
	}
	
	
	
}

- (void)minimizeWork {
	
}

- (int) minWidthPreview {
	NSRect f = [self frame];
	
	return f.size.width;
	
}
- (int) minHeightPreview {
	NSRect f = [self frame];
	
	return f.size.height;
}

@end
