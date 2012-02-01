//
//  KeyAssignment.m
//  HotkeysForArduino
//
/*
 Hotkeys for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Hotkeys for Arduino Copyright (c) 2012, AppsForArduino.com. All rights reserved.
 */

#import "KeyAssignment.h"
#import "DDHotKeyCenter.h"
#import "AppDelegate.h"

@implementation KeyAssignment 

@synthesize name, code, flags, keycomboDisplay;


#pragma mark -
#pragma mark Factory methods

+ (id)assignmentWithName:(NSString *)theName
				 keyCode:(NSInteger)theKeyCode
		   modifierFlags:(NSUInteger)theModifierFlags {
    
	KeyAssignment *keyAssignment = [[[[self class] alloc] init] autorelease];
	
	[keyAssignment setName:theName];
	[keyAssignment setCode:theKeyCode];
	[keyAssignment setFlags:theModifierFlags];
	
	return keyAssignment;
}


#pragma mark -
#pragma mark Init/awake/dealloc

- (id)init {
    
	self = [super init];
	if (self) {
		hotkeyCenter = [[DDHotKeyCenter alloc] init];
		name = @"Untitled";
		code = WKNoKeyCode;
		flags = WKNoKeyFlags;
        appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	}
	
	return self;
}

- (void)dealloc {
    [hotkeyCenter release];
	[name release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString *)keyComboDisplayString {
	if (code == WKNoKeyCode) {
		return @"";
	} else {
		return SRStringForCocoaModifierFlagsAndKeyCode(flags, code);
	}
}

- (NSString *) description {
    return [self keyComboDisplayString];
}

#pragma mark -
#pragma mark Converting to and from plists

+ (NSArray *)assignmentsFromPlistArray:(NSArray *)arrayOfDicts {
	NSMutableArray *keyAssignments = [NSMutableArray array];
	
	for (NSDictionary *dict in arrayOfDicts) {
		KeyAssignment *givenKeyAssignment = [[[self alloc] init] autorelease];
		
		[givenKeyAssignment setValuesForKeysWithDictionary:dict];
		[keyAssignments addObject:givenKeyAssignment];
	}
	
	return keyAssignments;
}

+ (NSArray *)plistArrayFromAssignments:(NSArray *)arrayOfAssignments {
	NSMutableArray *plistArray = [NSMutableArray array];
	
	for (KeyAssignment *ka in arrayOfAssignments) {
		[plistArray addObject:[ka dictionaryWithValuesForKeys:[NSArray arrayWithObjects:
															   @"name",
															   @"code",
															   @"flags",
                                                               nil]]];
	}
	
	return plistArray;
}


#pragma mark -
#pragma mark Managing hotkey actions

- (BOOL)registerHotKeyAction {
	BOOL success = [hotkeyCenter registerHotKeyWithKeyCode:code
                                             modifierFlags:flags
                                                    target:self
                                                    action:@selector(_handleHotkeyWithEvent:)
                                                    object:nil];
    
	if (!success) {
        NSLog(@"%ld %lu", [self code], [self flags]);
		NSLog(@"Failed to register hotkey: %@", [self keyComboDisplayString]);
	}
	
	return ok;
}

- (void)unregisterHotKeyAction {
    [hotkeyCenter unregisterHotKeyWithKeyCode:[self code] modifierFlags:[self flags]];
}

- (NSError *)performHotKeyAction {
	NSError *error = nil;
	
    [appDelegate performHotkeyAction:[self name]];
    
	return error;
}


#pragma mark -
#pragma mark Private methods

- (void)_handleHotkeyWithEvent:(NSEvent *)event {
	[self performHotKeyAction];
}

- (NSError *)_errorWithDict:(NSDictionary *)errorDict {
	return [NSError errorWithDomain:@"TestKeys" code:0 userInfo:errorDict];
}

- (NSError *)_errorWithMessage:(NSString *)errorMessage {
	return [self _errorWithDict:[NSDictionary dictionaryWithObjectsAndKeys:
								 errorMessage, NSLocalizedDescriptionKey,
								 nil]];
}

@end