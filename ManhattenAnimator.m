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
	
	[firstAnim setDuration: 0.7];
	[secondAnim setDuration: 0.3];
	
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
	
	hookInPoint = 0.1;
	
	return [super init];
}

@end
