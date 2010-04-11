//
//  StickyCentral.m
//  Notation
//
//  Created by Agl on 20.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickyCentral.h"


@implementation StickyCentral

/**
 * opens a new Sticky note
 */
- (void) openStickyWithNoteWithoutShowing:(NoteObject *)note textStorage:(NSTextStorage *)storage {
	
		
	int count = [stickies count];
	
	while (count--) { //check if this note is allready open in a sticky
		id obj = [stickies objectAtIndex:count];
		
		StickyObject *s = obj;
		
		if (s.note == note) {
			return;
		}
		
	}
	
	StickyControler *controler = [[StickyControler alloc] initWithStickyCentral:self];
	
	if(![NSBundle loadNibNamed:@"StickyWindow" owner:controler]) {
		NSLog(@"Error loading Nib for Sticky!");
	}
	else {
		
		StickyObject *s = [[StickyObject alloc] init:note stickyControler:controler];
		
		[stickies addObject:s];
		
		[controler intiWindowWithCentralAndSetWindowToInitPos:self];
		[controler setNoteObject:note textStorage:storage];

		[controler setYellow];
		//[controler showWindow:self];
		[newStickies addObject:controler];
	}
	
}


- (void) openStickyWithNoteWithoutShowing:(NoteObject *)note {
	
	if (!visible) {
		[self visibleToggle];
	}
	
	[self openStickyWithNoteWithoutShowing:note textStorage:nil];

}

- (void) showNewStickies {
	int count = [newStickies count];
	int daIndex = 0;
	
	while (daIndex < count) {
		StickyControler * contr = [newStickies objectAtIndex:daIndex];
		daIndex++;
		[contr showWindow:self];
	}
	
	[newStickies removeAllObjects];
	
}



- (id) initWithTableView: (NotesTableView *) tableView contr:(AppController *)aControler  {
	appControler = aControler;
	notesTableView = tableView;
	stickies = [[NSMutableArray alloc] init];
	visible = YES;
	focusWindows = [[NSMutableArray alloc] init];
	focusWindowsFallback = [[NSMutableArray alloc] init];
	newStickies = [[NSMutableArray alloc] init];
	return [super init];
}

/**
 * removes and closes the sticky
 */
- (void) removeStickyWithNote:(NoteObject *) note {
	int count = [stickies count];
	
	while (count--) {
		id obj = [stickies objectAtIndex:count];
		
		StickyObject *s = obj;
		
		if ([s note] == note) {
			[stickies removeObject:obj];
			
			[self unregisterAsFocusWindow: [s controler]];
			
			//[[s controler] release];
			[s release];
			
			[appControler updateStickyStates];
			
			return;
		}
		
	}
}

/**
 * wether the give note is allready open as sticky
 */
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

/*
 * shows all stickies if they are hidden or hides them if they are shown
 */
- (BOOL) visibleToggle {
	visible = !visible;
	
	NSLog(@"in Central");
	
	int count = [stickies count];
	
	while (count--) {
		id obj = [stickies objectAtIndex:count];
		
		StickyObject *s = obj;
		
		
		[[s controler] setVisible:visible];
		
	}
	
	[appControler updateStickyStates];
	
	return visible;
	
}

/**
 * registers a new window as focus window (a window that has the users focus)
 */
- (void) registerAsFocusWindow:(StickyControler *)controler multipleSelection:(BOOL)mult{
	
	/*if (!mult) {
		[focusWindows removeAllObjects];
	}
	
	if (![focusWindows containsObject:controler]) {
		[focusWindows addObject:controler];
	}/* */
	
	//UPDATE FOR MULTIPLE SELECTIONS
	
	[focusWindows addObject:controler];
	
	[appControler updateStickyStates];
	
}

/**
 * unregisteres a window as focus window (a window that has the users focus)
 */
- (void) unregisterAsFocusWindow:(StickyControler *)controler {
	
	/*if ([focusWindows containsObject:controler]) {
		[focusWindows removeObject:controler];
	}/* */
	
	//UPDATE FOR MULTIPLE SELECTIONS
	
	[focusWindows removeObject:controler];
	
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

/**
 * wether the given window is registered as focus window
 */
- (BOOL) isRegisteredAsFocusWindow:(StickyControler *)controler {
	
	return [windows containsObject:controler];
	
}

/**
 * returns all focus windows (an array of StickyControlers)
 */
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

/**
 * updates the title of the stickiy for the given note
 */
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

/**
 * returns the NSTextStorage for the given window
 */
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

/**
 * minimizes all Stickies
 */
- (void) minimizeAll {
	NSEnumerator * enu = [stickies objectEnumerator];
	
	StickyObject * sticky = nil;
	
	while ((sticky = [enu nextObject])) {
		
		if (![[sticky controler] isMinimized]) {
			[[sticky controler] doubleClickInDragRegion];
			
			//[NSThread detachNewThreadSelector:@selector(doubleClickInDragRegion) toTarget:[sticky controler] withObject:nil];
			
		}
		
	}
	
}

/**
 * maximizes (or unminimizes) all stickies
 */
- (void) maximizeAll {
	NSEnumerator * enu = [stickies objectEnumerator];
	
	StickyObject * sticky = nil;
	
	while ((sticky = [enu nextObject])) {
		
		if ([[sticky controler] isMinimized]) {
			[[sticky controler] doubleClickInDragRegion];
		}
		
	}
}

/**
 * 
 */
- (void) stackWindowsAccordingToColor {
	
	StickyOrdererByColor * orderer = [[StickyOrdererByColor alloc] init];
	
	windows = [orderer sortTheWindows:stickies];
	
	[self stackWindowsInCurrentOrder];
	
}

- (void) stackWindowsAccordingToCreationDate {
	
	StickyOrdererByCreationDate * orderer = [[StickyOrdererByCreationDate alloc] init];
	
	windows = [orderer sortTheWindows:stickies];
	
	[self stackWindowsInCurrentOrder];
	
}

- (void) stackWindowsAccordingToTitle {
	StickyOrdererByTitle * orderer = [[StickyOrdererByTitle alloc] init];
	
	windows = [orderer sortTheWindows:stickies];
	
	[self stackWindowsInCurrentOrder];
}

- (BOOL) stickiesVisible {
	return visible;
}

- (BOOL) hasStickies {
	return [stickies count] > 0;
}


@end
