//
//  AutoMoveWindow.h
//  WindowOpener
//
//  Created by Agl on 11.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AutoMoveCentral.h"

@class AutoMoveCentral;

@interface AutoMoveWindow : NSWindow {

	AutoMoveCentral *central;
	
	BOOL currentlyClipped;
	
}

- (void) initWithCentral: (AutoMoveCentral *) daCentral;
- (void)setFrameNoCall:(NSRect)windowFrame display:(BOOL)displayViews animate:(BOOL)performAnimation;
- (void)setFrameOriginNoCall:(NSPoint)aPoint;
- (void)setFrameForDragging:(NSRect) aPoint;
- (void)minimizeWork;
- (int) minWidthPreview;
- (int) minHeightPreview;
- (NSRect) getUsableScreen;

@end
