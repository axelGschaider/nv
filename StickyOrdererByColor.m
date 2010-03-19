//
//  StickyOrdererByColor.m
//  Notation
//
//  Created by Agl on 12.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickyOrdererByColor.h"


@implementation StickyOrdererByColor

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

- (BOOL) firstOneSmaller: (StickyObject *) first secondObject:(StickyObject *) second {
	
	int firstColorCode = -1;
	int secondColorCode = -1;
	
	StickyControler * contr = [first controler];
	
	if ([contr isBlue]) {
		firstColorCode = 0;
	} else if ([contr isGreen]) {
		firstColorCode = 1;
	} else if ([contr isGrey]) {
		firstColorCode = 2;
	} else if ([contr isPink]) {
		firstColorCode = 3;
	} else if ([contr isViolet]) {
		firstColorCode = 4;
	} else {
		firstColorCode = 5;
	}
	
	contr = [second controler];
	
	if ([contr isBlue]) {
		secondColorCode = 0;
	} else if ([contr isGreen]) {
		secondColorCode = 1;
	} else if ([contr isGrey]) {
		secondColorCode = 2;
	} else if ([contr isPink]) {
		secondColorCode = 3;
	} else if ([contr isViolet]) {
		secondColorCode = 4;
	} else {
		secondColorCode = 5;
	}
	
	return (firstColorCode < secondColorCode);
	
}

@end
