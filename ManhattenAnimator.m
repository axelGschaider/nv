//
//  ManhattenAnimator.m
//  Notation
//
//  Created by Agl on 24.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ManhattenAnimator.h"


@implementation ManhattenAnimator

- (void) registerForAnimation: (NSWindow *) aWindow withEndFrame:(NSRect) aFrame {
	
	float firstAnimDur = 0.5;
	float secondAnimDur = 0.5;
	
	NSMutableDictionary * firstDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
	NSMutableDictionary * secondDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
	
	NSRect middleTarget = [aWindow frame];
	middleTarget.origin.y = aFrame.origin.y;
	middleTarget.size.height = aFrame.size.height;
	
	[firstDictionary setObject: aWindow 
						forKey: NSViewAnimationTargetKey];
	[firstDictionary setObject: [NSValue valueWithRect: [aWindow frame]] 
						forKey: NSViewAnimationStartFrameKey];
	[firstDictionary setObject: [NSValue valueWithRect: middleTarget] 
						forKey: NSViewAnimationEndFrameKey];
	
	
	[secondDictionary setObject: aWindow 
						forKey: NSViewAnimationTargetKey];
	[secondDictionary setObject: [NSValue valueWithRect: middleTarget] 
						forKey: NSViewAnimationStartFrameKey];
	[secondDictionary setObject: [NSValue valueWithRect: aFrame] 
						forKey: NSViewAnimationEndFrameKey];
	
	/*[firstArray addObject: firstDictionary];
	[secondArray addObject: secondDictionary];*/
	
	NSViewAnimation * firstAnim = [[NSViewAnimation alloc] initWithViewAnimations: [NSArray arrayWithObjects:firstDictionary, nil] ];
	NSViewAnimation * secondAnim = [[NSViewAnimation alloc] initWithViewAnimations: [NSArray arrayWithObjects:secondDictionary, nil] ];
	
	int windowX = [aWindow frame].origin.x;
	int windowY = [aWindow frame].origin.x;
	
	int endX = aFrame.origin.x;
	int endY = aFrame.origin.y;
	
	int xDif = windowX - endX;
	int yDif = windowY - endY;
	
	if (xDif == 0) {
		xDif = 1;
	}
	
	if (yDif == 0) {
		yDif = 0;
	}
	
	double xFactor = fabs((double) xDif/[[NSScreen mainScreen] visibleFrame].size.width);
	double yFactor = fabs((double) yDif/[[NSScreen mainScreen] visibleFrame].size.height);
	
	double d1 = (firstAnimDur * yFactor * 0.9) + (firstAnimDur * 0.1);
	double d2 = (secondAnimDur * xFactor * 0.5) + (secondAnimDur * 0.5);
	
	[firstAnim setDuration: d1];
	[secondAnim setDuration: d2];
	
	[firstAnim setAnimationCurve: NSAnimationEaseIn];
	[secondAnim setAnimationCurve: NSAnimationEaseIn];
	
	[firstAnim addProgressMark: hookInPoint];
	[firstAnim addProgressMark: 1];
	
	[secondAnim startWhenAnimation: firstAnim reachesProgress: 1];
	
	if ( startOff == nil ) {
		startOff = firstAnim;
		hookIn = firstAnim;
	}
	else {
		 
		[firstAnim startWhenAnimation: hookIn reachesProgress: hookInPoint];
		hookIn = firstAnim;
		
	}

	
	
}

- (void) animateAll {
	
	/*firstAnimation = [[NSViewAnimation alloc] initWithViewAnimations:firstArray];
	secondAnimation = [[NSViewAnimation alloc] initWithViewAnimations:secondArray];
	
	[firstAnimation setDuration:0.5];
	[secondAnimation setDuration:0.5];
	
	[firstAnimation setAnimationCurve:NSAnimationEaseIn];
	[secondAnimation setAnimationCurve:NSAnimationEaseIn];
	
	[firstAnimation addProgressMark: 1];
	[secondAnimation addProgressMark: 1];
	
	[secondAnimation setDelegate: self];
	[secondAnimation startWhenAnimation: firstAnimation reachesProgress: 1];
	
	[firstAnimation startAnimation]; /* */
	
	[startOff startAnimation];
	
}

- (id) init {
	/*firstArray = [[NSMutableArray alloc] init];
	secondArray = [[NSMutableArray alloc] init]; /* */
	
	hookInPoint = 0.02;
	
	return [super init];
}

@end
