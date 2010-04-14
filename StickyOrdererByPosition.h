//
//  StickyOrdererByPosition.h
//  Notation
//
//  Created by Agl on 12.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StickyObject.h"
#import "StickyControler.h"
#import "BorderlessWindow.h"

@class StickyObject;

@interface StickyOrdererByPosition : NSObject/*StickyOrdererByColor/* */ {

}

- (NSMutableArray *) sortTheWindows:(NSMutableArray *)theObjects;
- (NSMutableArray *) recursiveSort: (NSMutableArray *)theObjects;
- (BOOL) firstOneSmaller: (StickyObject *) first secondObject:(StickyObject *) second; 
- (int) getQuadrant: (StickyObject *) sticky;


@end
