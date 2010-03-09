//
//  BorderlessWindowControler.h
//  WindowOpener
//
//  Created by Agl on 12.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BorderlessWindow.h"
#import "BorderlessView.h"
#import "TextViewForBorderless.h"

@class BorderlessWindow;
@class BorderlessView;
@class TextViewForBorderless;

@interface BorderlessWindowControler : NSWindowController {

	IBOutlet BorderlessWindow *daWindow;
	IBOutlet NSButton *closeButton;
	IBOutlet NSButton *minimizeButton;
	IBOutlet NSTextField *titleField;
	IBOutlet BorderlessView *view;
	IBOutlet TextViewForBorderless *textView;
	BOOL hasFocus;
	BOOL visible;
	BOOL onTop;
	BOOL opaque;
	BOOL yellow;
	BOOL blue;
	BOOL green;
	BOOL pink;
	BOOL violet;
	BOOL grey;
	
	
}

- (void) setWindowTitle:(NSString*) theTitle;
- (IBAction)minimizeToggle: (id) sender;
- (IBAction)closeWindow: (id) sender;
- (void) myWindowGainedFocus;
- (void) myWindowLostFocus;
- (void) doubleClickInDragRegion;
- (void) setYellow;
- (BOOL) isYellow;
- (void) setBlue;
- (BOOL) isBlue;
- (void) setGreen;
- (BOOL) isGreen;
- (void) setPink;
- (BOOL) isPink;
- (void) setViolet;
- (BOOL) isViolet;
- (void) setGrey;
- (BOOL) isGrey;
- (void) setOpaque: (BOOL) opaque;
- (void) setFloating: (BOOL) floating;
- (void) setVisible:(BOOL) vis;
- (id) init;
- (void) showWindow:(id)sender;
- (void) closeWindowAndFreeAll;
//- (BOOL) isVisible;
- (BOOL) isFloating;
- (BOOL) isOpaque;
- (void) refreshWindow;
- (void) initWindow;
- (void) initWindowWithCentral: (AutoMoveCentral *) central;
- (void) intiWindowWithCentralAndSetWindowToInitPos: (AutoMoveCentral *) central;
- (void) textContentDidChange;



@end
