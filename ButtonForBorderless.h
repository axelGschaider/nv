//
//  ButtonForBorderless.h
//  WindowOpener
//
//  Created by Agl on 17.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BorderlessWindow.h"

@class BorderlessWindow;


@interface ButtonForBorderless : NSButton {

	IBOutlet BorderlessWindow *daWindow;
	
}

@end
