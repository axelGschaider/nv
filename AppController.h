/* AppController */

/*Copyright (c) 2010, Zachary Schneirov. All rights reserved.
  Redistribution and use in source and binary forms, with or without modification, are permitted 
  provided that the following conditions are met:
   - Redistributions of source code must retain the above copyright notice, this list of conditions 
     and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright notice, this list of 
	 conditions and the following disclaimer in the documentation and/or other materials provided with
     the distribution.
   - Neither the name of Notational Velocity nor the names of its contributors may be used to endorse 
     or promote products derived from this software without specific prior written permission. */


#import <Cocoa/Cocoa.h>

#import "NotationController.h"
#import "NotesTableView.h"
#import "StickyCentral.h"

@class LinkingEditor;
@class EmptyView;
@class NotesTableView;
@class GlobalPrefs;
@class PrefsWindowController;
@class DualField;
@class RBSplitView;
@class RBSplitSubview;
@class TitlebarButton;
@class LinearDividerShader;
@class StickyCentral;


@interface AppController : NSObject {
    IBOutlet DualField *field;
	IBOutlet RBSplitSubview *splitSubview;
	IBOutlet RBSplitView *splitView;
    IBOutlet NotesTableView *notesTableView;
    IBOutlet LinkingEditor *textView;
	IBOutlet EmptyView *editorStatusView;
	IBOutlet NSMenuItem *sparkleUpdateItem;
    IBOutlet NSWindow *window;
	IBOutlet NSPanel *syncWaitPanel;
	IBOutlet NSProgressIndicator *syncWaitSpinner;
	NSToolbar *toolbar;
	NSToolbarItem *dualFieldItem;
	TitlebarButton *titleBarButton;
	
	BOOL waitedForUncommittedChanges;
	
	LinearDividerShader *dividerShader;
	
	NSMutableArray *notesToOpenOnLaunch;
	
    NSUndoManager *windowUndoManager;
    PrefsWindowController *prefsWindowController;
    GlobalPrefs *prefsController;
    NotationController *notationController;
	
	ViewLocationContext listUpdateViewCtx;
	BOOL isFilteringFromTyping, typedStringIsCached;
	BOOL isCreatingANote;
	NSString *typedString;
	
	NoteObject *currentNote;
	NSArray *savedSelectedNotes;
	
	//Axels Codes
	StickyCentral *stickyCentral;
	BOOL stickiesToFloating, stickiesToOpaque;
}

void outletObjectAwoke(id sender);

- (void)setNotationController:(NotationController*)newNotation;

- (void)setupViewsAfterAppAwakened;
- (void)runDelayedUIActionsAfterLaunch;
- (void)updateNoteMenus;

- (BOOL)addNotesFromPasteboard:(NSPasteboard*)pasteboard;
- (IBAction)renameNote:(id)sender;
- (IBAction)deleteNote:(id)sender;
- (IBAction)exportNote:(id)sender;
- (IBAction)printNote:(id)sender;
- (IBAction)tagNote:(id)sender;
- (IBAction)importNotes:(id)sender;

- (IBAction)fieldAction:(id)sender;
- (NoteObject*)createNoteIfNecessary;
- (void)searchForString:(NSString*)string;
- (NSUInteger)_revealNote:(NoteObject*)note options:(NSUInteger)opts;
- (BOOL)displayContentsForNoteAtIndex:(int)noteIndex;
- (void)processChangedSelectionForTable:(NSTableView*)table;
- (void)setEmptyViewState:(BOOL)state;
- (void)_setCurrentNote:(NoteObject*)aNote;
- (NoteObject*)selectedNoteObject;

- (void)restoreListStateUsingPreferences;

- (void)_finishSyncWait;
- (IBAction)syncWaitQuit:(id)sender;

- (void)setTableAllowsMultipleSelection;

- (NSString*)fieldSearchString;
- (void)cacheTypedStringIfNecessary:(NSString*)aString;
- (NSString*)typedString;

- (IBAction)showHelpDocument:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)toggleNVActivation:(id)sender;
- (IBAction)bringFocusToControlField:(id)sender;
- (NSWindow*)window;

//Axels Code
- (IBAction)createStickies:(id)sender;
- (IBAction)stickiesToggle:(id)sender;
- (IBAction)closeSticky:(id)sender;
- (IBAction)setStickyFloatingToggle:(id)sender;
- (IBAction)setStickyOpaqueToggle:(id)sender;
- (IBAction)setStickyBlue:(id)sender;
- (IBAction)setStickyGreen:(id)sender;
- (IBAction)setStickyGrey:(id)sender;
- (IBAction)setStickyPink:(id)sender;
- (IBAction)setStickyViolet:(id)sender;
- (IBAction)setStickyYellow:(id)sender;
- (IBAction)moveStickiesToTop:(id)sender;
- (IBAction)moveStickiesToBottom:(id) sender;
- (IBAction)stackWindowsInCurrentOrder:(id) sender;
- (IBAction)stackWindowsAccordingToColor: (id) sender;
- (IBAction)stackWindowsAccordingToCreationDate: (id) sender;
- (IBAction)stackWindowsAccordingToTitle: (id) sender;
- (IBAction)minimizeAllStickies: (id) sender;
- (IBAction)maximizeAllStickies: (id) sender;
- (void) updateStickyMenus;
- (void) updateStickyStates;

@end
