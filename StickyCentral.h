//
//  StickyCentral.h
//  Notation
//
//  Created by Agl on 20.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AutoMoveCentral.h"
#import "NoteObject.h"
#import "StickyControler.h"
#import "NotesTableView.h"
#import "StickyObject.h"
#import "AppController.h"
#import "StickyOrdererByColor.h"
#import "StickyOrdererByTitle.h"
#import "StickyOrdererByPosition.h"
#import "StickyOrdererByCreationDate.h"


/*typedef struct _Sticky {
	NoteObject* note;
	StickyControler* controler;
} Sticky;/* */

@class StickyControler;
@class AppController;

@interface StickyCentral : AutoMoveCentral {
	
	NotesTableView *notesTableView;
	AppController *appControler;
	NSMutableArray *stickies;
	BOOL visible;
	NSMutableArray *focusWindows;
	NSMutableArray * focusWindowsFallback;
	
}

- (id) initWithTableView: (NotesTableView *) tableView contr:(AppController *)aControler;
- (void) openStickyWithNote: (NoteObject *) note;
- (void) openStickyWithNote:(NoteObject *)note textStorage:(NSTextStorage *)storage;
- (NSTextStorage *) textStorageForNote: (NoteObject *) aNote;
- (void) removeStickyWithNote: (NoteObject *)note;
- (BOOL) isOpenAsSticky: (NoteObject *)aNote;
- (BOOL) visibleToggle;
- (BOOL) stickiesVisible;
- (void) registerAsFocusWindow: (StickyControler *) controler multipleSelection:(BOOL)mult;
- (void) unregisterAsFocusWindow: (StickyControler *) controler;
- (NSMutableArray*) focusWindows;
- (BOOL) isRegisteredAsFocusWindow: (StickyControler *) controler;
- (void) updateTitleForNode: (NoteObject *)note;
- (void) minimizeAll;
- (void) maximizeAll;
//- (int) focusWindowIndex: (StickyControler *) controler;

- (void) stackWindowsAccordingToColor;
- (void) stackWindowsAccordingToCreationDate;

@end
