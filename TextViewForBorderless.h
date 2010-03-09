//
//  TextViewForBorderless.h
//  WindowOpener
//
//  Created by Agl on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BorderlessWindow.h"

@class BorderlessWindow;

@interface TextViewForBorderless : NSTextView {

	IBOutlet BorderlessWindow *daWindow;
	float redBackgr;
	float greenBackgr;
	float blueBackgr;
	
}

- (BOOL) isInResizingArea: (NSEvent *) anEvent;
- (void) setBackgrColor: (float)red greenC:(float)green blueC:(float)blue;
- (void)insertAttributedString:(NSAttributedString *)str;


@end
