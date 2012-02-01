//
//  KeyAssignment.h
//  HotkeysForArduino
//
/*
 Hotkeys for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Hotkeys for Arduino Copyright (c) 2012, AppsForArduino.com. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "SRCommon.h"

@class DDHotKeyCenter, AppDelegate;

#define WKNoKeyCode		-1
#define WKNoKeyFlags	 0


@interface KeyAssignment : NSObject {
    
@private
    DDHotKeyCenter *hotkeyCenter;
    
    NSString *name;
    NSInteger code;
    NSUInteger flags;
    NSString *keycomboDisplay;
    
    AppDelegate *appDelegate;
    
}

@property (readwrite, copy) NSString *name;
@property (readwrite, assign) NSInteger code;
@property (readwrite, assign) NSUInteger flags;
@property (readonly) NSString *keycomboDisplay;


#pragma mark -
#pragma mark Factory methods

/*! Returns a new instance of WKHotKeyAssignment with the given values. */
+ (id)assignmentWithName:(NSString *)theName
				 keyCode:(NSInteger)theKeyCode
		   modifierFlags:(NSUInteger)theModifierFlags;


#pragma mark -
#pragma mark Converting to and from plists

/*!
 *	Elements of the returned array are instances of WKKeyAssignment.  arrayOfDicts must
 *	contain a plist of the form returned by plistArrayFromAssignments:.
 */
+ (NSArray *)assignmentsFromPlistArray:(NSArray *)arrayOfDicts;

/*! Elements of the given array must be instances of WKKeyAssignment. */
+ (NSArray *)plistArrayFromAssignments:(NSArray *)arrayOfAssignments;


#pragma mark -
#pragma mark Managing hotkey actions

/*!
 *	Registers the global hotkey specified by the receiver.  Associates it with
 *	the action specified by the receiver.
 */
- (BOOL)registerHotKeyAction;

/*! Unregisters the global hotkey specified by the receiver. */
- (void)unregisterHotKeyAction;

/*!
 *	Invoked when the user presses the receiver's global hotkey.  The WhatKeys
 *	application does not have to be the frontmost application, but it does have
 *	to be running in order for the hotkey to work.
 */
- (NSError *)performHotKeyAction;

@end
