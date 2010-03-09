//
//  StickyControler.m
//  Notation
//
//  Created by Agl on 20.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickyControler.h"


@implementation StickyControler

- (id) initWithStickyCentral:(StickyCentral *)cent {
	central = cent;
	
	
	//[super initWindowWithCentral:cent];
	
	id ret = [super init];
	
	
	//[central setInitialPosition:daWindow];
	
	return ret;
	
}

- (IBAction)closeWindow: (id) sender {
	
	[central removeStickyWithNote:myNote];
	
	[central unregisterAsFocusWindow:self];
	[[textView textStorage] removeLayoutManager:[textView layoutManager]];
	
	return [super closeWindow:sender];
	
}

- (void) setNoteObject:(NoteObject *)note textStorage:(NSTextStorage *)storage {
	myNote = note;
	
	[titleField setStringValue:(titleOfNote(note))];
	
	if (storage == nil) {
		[textView insertAttributedString: [note contentString]];
	}
	else {
		[self setTextStorage:storage];
	}

	
}

- (id) init {
	return [super init];
}

- (void) setTextStorage:(NSTextStorage *)storage {
	//[[textView layoutManager] setTextStorage:storage];
	[storage addLayoutManager:[textView layoutManager]];
}

- (NSTextStorage *) textStorage {
	return [[textView layoutManager] textStorage];
}

- (void) myWindowLostFocus {
	[super myWindowLostFocus];
	[central unregisterAsFocusWindow:self];
	
}

- (void) myWindowGainedFocus {
	[super myWindowGainedFocus];
	[central registerAsFocusWindow:self multipleSelection:NO];
}

- (void) textContentDidChange {
	[myNote setContentString:[textView textStorage]];
}

@end
