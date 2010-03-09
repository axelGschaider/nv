//
//  TextViewForBorderless.m
//  WindowOpener
//
//  Created by Agl on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextViewForBorderless.h"


@implementation TextViewForBorderless


-(BOOL) isInResizingArea:(NSEvent *)anEvent {
	
	int height = [daWindow getResizingSpaceHeight];
	int width = [daWindow getResizingSpaceWidth];
	
	NSRect frame = [daWindow frame];
	
	NSPoint mouse = [anEvent locationInWindow];
	
	if (mouse.y > 0 && mouse.y < height && mouse.x < frame.size.width && mouse.x > frame.size.width - width) {
		return YES;
	}
	
	return NO;
	
}

- (void)mouseDown:(NSEvent * )theEvent {
	
	if ([self isInResizingArea:theEvent]) {
		[daWindow mouseDown:theEvent];
	}
	else {
		[super mouseDown:theEvent];
	}
	
}

- (void)drawRect:(NSRect)rect {
	
	NSGraphicsContext *graphicsContext;
    CGContextRef windowContext;
	
	graphicsContext = [NSGraphicsContext currentContext];
    windowContext = [graphicsContext graphicsPort];
	
	CGContextSetRGBFillColor(windowContext, redBackgr, greenBackgr, blueBackgr, 1);
    NSRectFill(rect); /* */
	
	
	[super drawRect:rect];
	
	
	
	
	
	
	int height = [self visibleRect].size.height + [self visibleRect].origin.y; //rect.size.height;
	int width = [self visibleRect].size.width;
	
	int longlineLength = 6;
	int shortlineLength = 3;
	
	graphicsContext = [NSGraphicsContext currentContext];
    windowContext = [graphicsContext graphicsPort];
	
	CGContextSetRGBStrokeColor(windowContext, 0, 0, 0, 0.8);
	
	CGContextBeginPath(windowContext);
	CGContextMoveToPoint(windowContext,(width - (longlineLength + shortlineLength))+1,height);
	CGContextAddLineToPoint(windowContext,(width - (longlineLength + shortlineLength))+1, height - shortlineLength);
	CGContextAddLineToPoint(windowContext, (width - shortlineLength)+1, height - shortlineLength);
	CGContextAddLineToPoint(windowContext, (width - shortlineLength)+1, height - ( shortlineLength + longlineLength) );
	CGContextAddLineToPoint(windowContext, width + 1, height - (shortlineLength + longlineLength) );
	
	CGContextStrokePath(windowContext);
	//CGContextClosePath(windowContext); //throws error and does nothing ??????
	
} 

- (void) setBackgrColor:(float)red greenC:(float)green blueC:(float)blue {
	
	redBackgr = red;
	greenBackgr = green;
	blueBackgr = blue;
	
}

- (void)insertAttributedString:(NSAttributedString *)str {
    id delegate = [[self delegate] retain];
	
    
	[self setDelegate:nil];
	
    [self setString:@""];
    [self insertText:str];
	
    
	[self setDelegate:delegate];
	
    [delegate autorelease];
}



/*-(void) resetCursorRects {
	[super resetCursorRects];
	
	NSCursor *hc = [NSCursor openHandCursor];
	//[hc setOnMouseExited:NO];
	[hc setOnMouseEntered:YES];
	
	NSRect area = NSMakeRect([daWindow frame].size.width - [daWindow getResizingSpaceWidth], 0, [daWindow getResizingSpaceWidth], [daWindow getResizingSpaceHeight]);
	
	[self addCursorRect:area cursor:hc];
	
} /* */

- (void) didChangeText {
	[daWindow textContentDidChange];
	[super didChangeText];
}



@end
