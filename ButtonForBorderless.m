//
//  ButtonForBorderless.m
//  WindowOpener
//
//  Created by Agl on 17.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonForBorderless.h"


@implementation ButtonForBorderless

/*- (void) performClick:(int)sender {
	
	[super performClick:sender];
	
	[daWindow display];
	
} /* */

/*- (void)setState:(NSInteger)value {
	
	[super setState:value];
	
	[daWindow display];
	
} /* */

- (void)mouseDown:(NSEvent *)theEvent {
	[daWindow display];
	
	[super mouseDown:theEvent];
	
	[daWindow display];

}



@end
