//
//  StickyObject.m
//  Notation
//
//  Created by Agl on 25.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickyObject.h"


@implementation StickyObject

- (id) init:(NoteObject *)aNote stickyControler:(StickyControler *)aControler {
	note = aNote;
	controler = aControler;
	return self;
}

- (NoteObject *) note {
	return note;
}

- (StickyControler *) controler {
	return controler;
}

@end
