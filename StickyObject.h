//
//  StickyObject.h
//  Notation
//
//  Created by Agl on 25.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NoteObject.h";
#import "StickyControler.h";

@class StickyControler;

@interface StickyObject : NSObject {

	NoteObject *note;
	StickyControler *controler;
	
}

- (id) init:(NoteObject *)aNote stickyControler:(StickyControler *)aControler;
- (NoteObject *) note;
- (StickyControler *) controler;

@end
