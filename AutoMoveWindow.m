//
//  AutoMoveWindow.m
//  WindowOpener
//
//  Created by Agl on 11.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AutoMoveWindow.h"


@implementation AutoMoveWindow

- (void) initWithCentral:(AutoMoveCentral *)daCentral {
	

	
	central = daCentral;
	[central registerWindow:self];
	currentlyClipped = NO;
	
}

- (void) close {
	[central unregisterWindow:self];
	[super close];
}

- (void) setFrameOrigin:(NSPoint)aPoint {
	NSRect daFrame = [self frame];
	
	daFrame.origin.x = aPoint.x;
	daFrame.origin.y = aPoint.y;
	
	[self setFrame:daFrame display:YES animate:NO];
	
}

- (void)setFrame:(NSRect)windowFrame display:(BOOL)displayViews animate:(BOOL)performAnimation {
	
	NSRect newFrame = [central alterFrameChange:windowFrame : self];
	
	/*int x = windowFrame.origin.x;
	int y = windowFrame.origin.y;
	int w = windowFrame.size.width;
	int h = windowFrame.size.height;
	
	NSLog(@"old: %d %d %d %d",x,y,w,h);
	
	x = newFrame.origin.x;
	y = newFrame.origin.y;
	w = newFrame.size.width;
	h = newFrame.size.height;
	
	NSLog(@"new: %d %d %d %d",x,y,w,h);
	
	if (central == nil) {
		NSLog(@"Cluster Fuck");
	} /* */
	
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
- (void)setFrameForDragging:(NSRect) aPoint {
	
	NSRect newFrame = [central alterFrameChange:aPoint : self];
	
	if (currentlyClipped) {
		if (newFrame.origin.x == aPoint.origin.x && newFrame.origin.y == aPoint.origin.y) {
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

- (NSRect) getUsableScreen {
	NSRect f = [[NSScreen mainScreen] frame];
	
	return NSMakeRect(f.origin.x, f.origin.y, f.size.width, f.size.height - 21);
	
}



- (void)setFrameNoCall:(NSRect)windowFrame display:(BOOL)displayViews animate:(BOOL)performAnimation {
	[super setFrame: windowFrame display:displayViews animate:performAnimation];
}

- (void) setFrameOriginNoCall:(NSPoint)aPoint {
	[super setFrameOrigin:aPoint];
}

@end
