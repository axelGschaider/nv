//
//  BorderlessView.m
//  WindowOpener
//
//  Created by Agl on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BorderlessView.h"


@implementation BorderlessView

- (id)init {
	
	
	return [super init];
	
}

- (void) awakeFromNib {
	redUpper = 0.9;
	greenUpper = 0.9;
	blueUpper = 0.9;
	
	redLow = 1;
	greenLow = 1;
	blueLow = 1;
}

- (void)drawRect:(NSRect)rect {
	
	
	
	NSGraphicsContext *graphicsContext;
    CGContextRef windowContext;
	
	graphicsContext = [NSGraphicsContext currentContext];
    windowContext = [graphicsContext graphicsPort];
	
	int draggingSpaceHight = [daWindow getDraggingSpaceHeight];
	
	NSRect low = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - draggingSpaceHight);
	
	CGContextSetRGBFillColor(windowContext, redLow, greenLow, blueLow, 1);
    NSRectFill(low);
	
	
	
	NSRect upper = NSMakeRect(rect.origin.x, rect.size.height - draggingSpaceHight, rect.size.width, draggingSpaceHight);
	CGContextSetRGBFillColor(windowContext, redUpper, greenUpper, blueUpper, 1);
	NSRectFill(upper); /* */
	
	/*CGContextSetRGBStrokeColor(windowContext, 0, 0, 0, 1);
	
	CGContextMoveToPoint(windowContext, 0, 0);//draggingSpaceHight);
	CGContextMoveToPoint(windowContext, rect.size.width, draggingSpaceHight);
	
	CGContextStrokePath(windowContext);
	CGContextClosePath(windowContext);  /* */
	
	[super drawRect:rect];
	
	
}

-(void) setLowerColor:(float)red greenC:(float)green blueC:(float)blue {
	
	redLow = red;
	greenLow = green;
	blueLow = blue;
	
}

-(void) setUpperColor:(float)red greenC:(float)green blueC:(float)blue {
	redUpper = red;
	greenUpper = green;
	blueUpper = blue;
}



@end
