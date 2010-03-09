//
//  StickyCentral.m
//  Notation
//
//  Created by Agl on 20.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickyCentral.h"


@implementation StickyCentral

- (void) openStickyWithNote:(NoteObject *)note textStorage:(NSTextStorage *)storage {
	
	StickyControler *controler = [[StickyControler alloc] initWithStickyCentral:self];
	
	int count = [stickies count];
	
	while (count--) {
		id obj = [stickies objectAtIndex:count];
		
		StickyObject *s = obj;
		
		if (s.note == note) {
			return;
		}
		
	}
	
	if(![NSBundle loadNibNamed:@"StickyWindow" owner:controler]) {
		NSLog(@"Error loading Nib for Sticky!");
	}
	else {
		
		StickyObject *s = [[StickyObject alloc] init:note stickyControler:controler];
		
		[stickies addObject:s];
		
		//[controler initWindowWithCentral:self];
		[controler intiWindowWithCentralAndSetWindowToInitPos:self];
		[controler setNoteObject:note textStorage:storage];

		[controler setYellow];
		[controler showWindow:self];
		//[controler setGreen];
	}/* */
	
}


- (void) openStickyWithNote:(NoteObject *)note {
	
	if (!visible) {
		[self visibleToggle];
	}
	
	[self openStickyWithNote:note textStorage:nil];

}



- (id) initWithTableView: (NotesTableView *) tableView contr:(AppController *)aControler  {
	appControler = aControler;
	notesTableView = tableView;
	stickies = [[NSMutableArray alloc] init];
	visible = YES;
	focusWindows = [[NSMutableArray alloc] init];
	focusWindowsFallback = [[NSMutableArray alloc] init];
	return [super init];
}

- (void) removeStickyWithNote:(NoteObject *) note {
	int count = [stickies count];
	
	while (count--) {
		id obj = [stickies objectAtIndex:count];
		
		StickyObject *s = obj;
		
		if ([s note] == note) {
			[stickies removeObject:obj];
			
			[self unregisterAsFocusWindow: [s controler]];
			
			//[[s controler] release];
			
			[appControler updateStickyStates];
			
			return;
		}
		
	}
}

- (BOOL) isOpenAsSticky:(NoteObject *)aNote {
	
	int count = [stickies count];
	
	while (count--) {
		id obj = [stickies objectAtIndex:count];
		
		StickyObject *s = obj;
		
		if (s.note == aNote) {
			return YES;
		}
		
	}
	
	return NO;
	
}

- (BOOL) visibleToggle {
	visible = !visible;
	
	int count = [windows count];
	
	while (count--) {
		id obj = [windows objectAtIndex:count];
		
		StickyObject *s = obj;
		
		[[s controler] setVisible:visible];
		
	}
	
	return visible;
	
}

- (void) registerAsFocusWindow:(StickyControler *)controler multipleSelection:(BOOL)mult{
	
	/*if (!mult) {
		[focusWindows removeAllObjects];
	}
	
	if (![focusWindows containsObject:controler]) {
		[focusWindows addObject:controler];
	}/* */
	
	//UPDATE FOR MULTIPLE SELECTIONS
	
	[focusWindows addObject:controler];
	
	//NSLog(@"register -> %d", [focusWindows count]);
	
	[appControler updateStickyStates];
	
}

- (void) unregisterAsFocusWindow:(StickyControler *)controler {
	
	/*if ([focusWindows containsObject:controler]) {
		[focusWindows removeObject:controler];
	}/* */
	
	//UPDATE FOR MULTIPLE SELECTIONS
	
	[focusWindows removeObject:controler];
	
	//NSLog(@"unregister -> %d", [focusWindows count]);
	
	[appControler updateStickyStates];
}

/*- (int) focusWindowIndex: (StickyControler *) controler {
	
	int count = [focusWindows count];
	
	while (count--) {
		if ([focusWindows objectAtIndex:count] == controler) {
			return count;
		}
	}
	
	return -1;
	
	
}*/

- (BOOL) isRegisteredAsFocusWindow:(StickyControler *)controler {
	
	return [windows containsObject:controler];
	
}

- (NSMutableArray*) focusWindows {
	return focusWindows;
}




/*- (BOOL) hasFocusWindow {
	return (focusWindow != nil);
}
- (BOOL) focusWindowFloatToggle {
	if (focusWindow != nil) {
		if ([focusWindow isFloating]) {
			[focusWindow setFloating:NO];
			return NO;
		}
		else {
			[focusWindow setFloating:YES];
			return YES;
		}

	}
	
	return NO;
	

}
- (BOOL) focusWindowOpaqueToggle {
	
	if (focusWindow != nil) {
		if ([focusWindow isOpaque]) {
			[focusWindow setOpaque:NO];
			return NO;
		}
		else {
			[focusWindow setOpaque:YES];
			return YES;
		}
		
	}
	
	return NO;
	
} /* */

- (void) updateTitleForNode: (NoteObject *)note {
	StickyObject * sticky = nil;
	
	NSEnumerator * enu = [stickies objectEnumerator];
	
	while ((sticky = [enu nextObject])) {
		
		if ([sticky note] == note) {
			StickyControler * contr = [sticky controler];
			
			[contr setWindowTitle: titleOfNote(note)];
			
		}
		
	}
	
}

- (NSTextStorage *) textStorageForNote:(NoteObject *)aNote {
	
	StickyObject * sticky = nil;
	
	NSEnumerator * enu = [stickies objectEnumerator];
	
	while ((sticky = [enu nextObject])) {
		
		if ([sticky note] == aNote) {
			
			return [[sticky controler] textStorage];
			
		}
		
	}
	
	return nil;
	
}



@end
