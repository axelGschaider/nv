//
//  StickyOrdererByPosition.m
//  Notation
//
//  Created by Agl on 12.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickyOrdererByPosition.h"


@implementation StickyOrdererByPosition

- (NSMutableArray *) sortTheWindows:(NSMutableArray *)theObjects {
	
	NSMutableArray * tmp = [[NSMutableArray alloc] init];
	
	[tmp addObjectsFromArray:theObjects];
	
	NSMutableArray * sorted = [self recursiveSort:tmp];
	
	NSMutableArray * ret = [[NSMutableArray alloc]init];
	
	int count = [sorted count];
	int daIndex = 0;
	StickyObject * obj = nil;
	
	while (daIndex < count) {
		obj = [sorted objectAtIndex:daIndex];
		daIndex++;
		
		[ret addObject:[[obj controler] window]];
	}
	
	return ret;
	
}


- (NSMutableArray *) recursiveSort: (NSMutableArray *)theObjects {
	
	
	
	int count = [theObjects count];
	
	if (count <= 1) {
		return theObjects;
	}
	
	if (count == 2) {
		if ([self firstOneSmaller:[theObjects objectAtIndex:0] secondObject:[theObjects objectAtIndex:1]]) {
			return theObjects;
		}
		else {
			id smaller = [theObjects objectAtIndex:1];
			id bigger = [theObjects objectAtIndex:0];
			
			[theObjects removeAllObjects];
			
			[theObjects insertObject:smaller atIndex:0];
			[theObjects insertObject:bigger atIndex:1];
			
			return theObjects;
			
		}
		
	}
	
	int half = count/2;
	
	NSMutableArray * tmp = [[NSMutableArray alloc]init];
	
	while (half >= 0) {
		[tmp insertObject:[theObjects objectAtIndex:0] atIndex:0];
		[theObjects removeObjectAtIndex:0];
		half--;
	}
	
	tmp = [self recursiveSort:tmp];
	NSMutableArray * tmp2 = [self recursiveSort:theObjects];
	
	NSMutableArray * ret = [[NSMutableArray alloc]init];
	
	while ([tmp count] != 0 && [tmp2 count ] != 0) {
		
		if ([self firstOneSmaller:[tmp objectAtIndex:0] secondObject:[tmp2 objectAtIndex:0]]) {
			[ret insertObject:[tmp objectAtIndex:0] atIndex:[ret count]];
			[tmp removeObjectAtIndex:0];
		}
		else {
			[ret insertObject:[tmp2 objectAtIndex:0] atIndex:[ret count]];
			[tmp2 removeObjectAtIndex:0];
		}
		
	}
	
	NSMutableArray * notEmpty = nil;
	
	if ([tmp count] == 0) {
		notEmpty = tmp2;
	}
	else {
		notEmpty = tmp;
	}
	
	count = [notEmpty count];
	
	int daIndex = 0;
	
	while (daIndex < count) {
		[ret insertObject:[notEmpty objectAtIndex:daIndex] atIndex:[ret count]];
		daIndex++;
	}
	
	return ret;
	
}

/**
 * quadrant 1 = left upper
 * quadrant 2 = left lower
 * quadrant 3 = right lower
 * quadrant 4 = right upper
 */
- (BOOL) firstOneSmaller: (StickyObject *) first secondObject:(StickyObject *) second {
	
	return [self getQuadrant:first] < [self getQuadrant:second];
	
}

/**
 * quadrant 1 = left upper
 * quadrant 2 = left lower
 * quadrant 3 = right lower
 * quadrant 4 = right upper
 */
- (int) getQuadrant: (StickyObject *) sticky {
	
	NSRect frame = [[[sticky controler] window] frame];
	
	int frameMiddleX = frame.origin.x + (frame.size.width / 2);
	int frameMiddleY = frame.origin.y + (frame.size.height / 2);
	
	NSRect screen = [[NSScreen mainScreen] visibleFrame];
	
	int screenMiddleX = screen.origin.x + (screen.size.width / 2);
	int screenMiddleY = screen.origin.y + (screen.size.height / 2);
	
	
	if ( frameMiddleY > screenMiddleY ) { //upper
		
		if (frameMiddleX < screenMiddleX) { //left upper
			return 1;
		}
		else { //right upper
			return 4;
		}
		
	}
	else { // lower half
		
		if (frameMiddleX < screenMiddleX) { //left lower
			return 2;
		}
		else { //right lower
			return 3;
		}
		
	}

	
	
}

@end
