//
//  BorderlessView.h
//  WindowOpener
//
//  Created by Agl on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BorderlessWindow.h"

@class BorderlessWindow;

@interface BorderlessView : NSView {

	IBOutlet BorderlessWindow *daWindow;
	float redUpper;
	float greenUpper;
	float blueUpper;
	
	float redLow;
	float greenLow;
	float blueLow;
	
}

-(void) setUpperColor: (float) red greenC:(float) green blueC:(float) blue;
-(void) setLowerColor: (float) red greenC:(float) green blueC:(float) blue;


@end
