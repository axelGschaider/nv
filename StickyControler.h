//
//  StickyControler.h
//  Notation
//
//  Created by Agl on 20.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BorderlessWindowControler.h"
#import "NoteObject.h"
#import "StickyCentral.h"

@class StickyCentral;

@interface StickyControler : BorderlessWindowControler {

	NoteObject *myNote;
	StickyCentral *central;
	
	
}

- (void) setNoteObject: (NoteObject *) note textStorage:(NSTextStorage *)storage;
- (void) setTextStorage: (NSTextStorage *)storage;
- (NSTextStorage *) textStorage;
- (id) initWithStickyCentral: (StickyCentral *) cent;

@end
