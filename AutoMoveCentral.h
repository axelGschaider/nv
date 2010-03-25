//
//  AutoMoveCentral.h
//  WindowOpener
//
//  Created by Agl on 11.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AutoMoveWindow.h"
#import "ManhattenAnimator.h"

@class AutoMoveWindow;

@interface AutoMoveCentral : NSObject {

	NSMutableArray *windows;
	
	
}

- (void)registerWindow:(AutoMoveWindow *) window;
- (void)unregisterWindow:(AutoMoveWindow *) window;
- (NSRect)alterFrameChange:(NSRect) frame : (AutoMoveWindow *) window;
- (void)setInitialPosition:(AutoMoveWindow *) window;
- (BOOL)isAnyBodyAtThisPosition:(AutoMoveWindow *) window;
- (void) moveAllToTop;
- (void) moveAllToBottom;
- (void) stackWindowsInCurrentOrder;

@end
