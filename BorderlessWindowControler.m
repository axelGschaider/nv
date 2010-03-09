//
//  BorderlessWindowControler.m
//  WindowOpener
//
//  Created by Agl on 12.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BorderlessWindowControler.h"


@implementation BorderlessWindowControler

- (void) setWindowTitle:(NSString *)theTitle {
	[titleField setStringValue:theTitle];
	[self refreshWindow];
}

- (void) windowDidBecomeKey:(NSNotification *) notification {
	if (notification.object == daWindow) {
		
		[self myWindowGainedFocus];
		if (!hasFocus) {
			[daWindow display];
		}
		hasFocus = YES;
	}
	else {
		if (hasFocus) {
			[self myWindowLostFocus];
		}
		
		if (hasFocus) {
			[daWindow display];
		}
		
		hasFocus = NO;
	}
}



- (void) myWindowLostFocus {
	[minimizeButton setAlphaValue:0.5];
	[closeButton setAlphaValue:0.5];
	[titleField setAlphaValue:0.5];
	
}

- (void) myWindowGainedFocus {
	[minimizeButton setAlphaValue:1];
	[closeButton setAlphaValue:1];
	[titleField setAlphaValue:1];
	[daWindow doMouseDownWork:[daWindow convertScreenToBase:[NSEvent mouseLocation]]];
}

- (void) doubleClickInDragRegion {
	
	[minimizeButton performClick:minimizeButton];
	//[daWindow display];

	
}

- (IBAction)minimizeToggle: (id) sender {
	[daWindow minimizeToggle];
	[self refreshWindow];
	//[daWindow display];
	
	/*BOOL minimized = [daWindow isMimimized];
	BOOL triangleDown = [closeButton state] == NSOnState;
	
	
	if (minimized && triangleDown) {
		[closeButton setState:NSOnState];
	}
	
	if (!minimized && !triangleDown) {
		[closeButton setState:NSOnState];
	}*/
	
}

- (void) resetColors {
	yellow = NO;
	green = NO;
	grey = NO;
	blue = NO;
	violet = NO;
	pink = NO;
}

- (void) setYellow {
	//[textView setBackgroundColor:[NSColor colorWithCalibratedRed:0.996 green:0.957 blue:0.612 alpha:1]];
	[textView setBackgrColor:0.996 greenC:0.957 blueC:0.612];
	[view setLowerColor:0.996 greenC:0.957 blueC:0.612];
	[view setUpperColor:0.966 greenC:0.918 blueC:0.239];
	
	[self resetColors];
	yellow = YES;
	
	[self refreshWindow];
	
}

- (void) setBlue {
	[textView setBackgrColor:0.678 greenC:0.957 blueC:1];
	[view setLowerColor:0.678 greenC:0.957 blueC:1];
	[view setUpperColor:0.537 greenC:0.957 blueC:1];
	
	[self resetColors];
	blue = YES;
	
	[self refreshWindow];
}

- (void) setGreen {
	[textView setBackgrColor:0.698 greenC:1 blueC:0.63];
	[view setLowerColor:0.698 greenC:1 blueC:0.63];
	[view setUpperColor:0.514 greenC:0.996 blueC:0.514];
	
	[self resetColors];
	green = YES;
	
	[self refreshWindow];
}

- (void) setPink {
	[textView setBackgrColor:1 greenC:0.78 blueC:0.78];
	[view setLowerColor:1 greenC:0.78 blueC:0.78];
	[view setUpperColor:1 greenC:0.698 blueC:0.698];
	
	[self resetColors];
	pink = YES;
	
	[self refreshWindow];
}

- (void) setViolet {
	[textView setBackgrColor:0.714 greenC:0.792 blueC:1];
	[view setLowerColor:0.714 greenC:0.792 blueC:1];
	[view setUpperColor:0.608 greenC:0.714 blueC:0.996];
	
	[self resetColors];
	violet = YES;
	
	[self refreshWindow];
}

- (void) setGrey {
	[textView setBackgrColor:0.933 greenC:0.933 blueC:0.933];
	[view setLowerColor:0.933 greenC:0.933 blueC:0.933];
	[view setUpperColor:0.855 greenC:0.855 blueC:0.855];
	
	[self resetColors];
	grey = YES;
	
	[self refreshWindow];
}

- (void) setOpaque:(BOOL)setOpaque {
	if (setOpaque) {
		[daWindow setAlphaValue:0.73];
	}
	else {
		[daWindow setAlphaValue:1];
	}
	opaque = setOpaque;
}

- (void) setFloating:(BOOL)setFloating {
	if (setFloating) {
		[daWindow setLevel:NSFloatingWindowLevel];
	}
	else {
		[daWindow setLevel:NSNormalWindowLevel];
	}
	
	onTop = setFloating;

}

- (void) initWindow {
	[daWindow init:self];
	
}

- (void) initWindowWithCentral: (AutoMoveCentral *)central {
	[self initWindow];
	[daWindow initWithCentral:central];
	
}


- (void) intiWindowWithCentralAndSetWindowToInitPos: (AutoMoveCentral *)central {
	[self initWindowWithCentral:central];
	[central setInitialPosition:daWindow];
}




- (id) init {
	visible = NO;
	opaque = NO;
	onTop = NO;
	
	
	if (! ( green || grey || blue || pink || violet ) ) {
		[self setYellow];
	}
	
	[self initWindow];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:nil];
	
	
	return self;
	
}

- (void) showWindow:(id)sender {
	[daWindow minimize];
	[daWindow makeKeyAndOrderFront:self];
	[daWindow unminimize];
	visible = YES;
}

- (IBAction)closeWindow: (id) sender {
	[self closeWindowAndFreeAll];
}

- (void) closeWindowAndFreeAll {
	[daWindow minimize];
	[daWindow close];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[daWindow release];
	visible = NO;
}

/*- (BOOL) isVisible {
	return visible;
}*/

- (BOOL) isFloating {
	return onTop;
}

- (BOOL) isOpaque {
	return opaque;
}

- (BOOL) isGrey {
	return grey;
}

- (BOOL) isViolet {
	return violet;
}

- (BOOL) isPink {
	return pink;
}

- (BOOL) isGreen {
	return green;
}

- (BOOL) isBlue {
	return blue;
}

- (BOOL) isYellow {
	return yellow;
}

- (void) refreshWindow {
	if (visible) {
		[daWindow display];
	}
}

- (void) setVisible:(BOOL) vis {
	if (vis) {
		[daWindow makeKeyAndOrderFront:self];
	}
	else {
		[daWindow orderOut:self];
	}
	
	visible = vis;

}

- (void) textContentDidChange {
	//NSLog(@"Change in Controler");
}

@end
