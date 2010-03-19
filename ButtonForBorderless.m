//
//  ButtonForBorderless.m
//  WindowOpener
//
//  Created by Agl on 17.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonForBorderless.h"


@implementation ButtonForBorderless


/**
 * repaints the whole window
 */
- (void)mouseDown:(NSEvent *)theEvent {
	[daWindow display];
	
	[super mouseDown:theEvent];
	
	[daWindow display];

}



@end
