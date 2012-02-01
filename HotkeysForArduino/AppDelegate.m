//
//  AppDelegate.m
//  HotkeysForArduino
//
/*
 Hotkeys for Arduino is licensed under the BSD 3-Clause License
 http://www.opensource.org/licenses/BSD-3-Clause
 
 Hotkeys for Arduino Copyright (c) 2012, AppsForArduino.com. All rights reserved.
 */


#import "AppDelegate.h"
#import "KeyAssignment.h"
#import "SRRecorderControl.h"

static NSString *TestHotkeyAssignmentsPrefName = @"HotkeyAssignments";

#define DEBUGG NO

@implementation AppDelegate

@synthesize window;
@synthesize arduino;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Arduino
    arduino = [[Matatino alloc] initWithDelegate:self];
    [serialSelectMenu addItemsWithTitles:[arduino deviceNames]];
    
    [connectButton setKeyEquivalent:@"\r"];
    
    // Setting all the tags since I can't find them in IB...lol
    hotKeyField1.tag = 1;
    hotKeyField2.tag = 2;
    hotKeyField3.tag = 3;
    hotKeyField4.tag = 4;
    hotKeyField5.tag = 5;
    hotKeyField6.tag = 6;
    // ---
    
    // Checking if the hotkeys user defaults are there
    if([[NSUserDefaults standardUserDefaults] objectForKey:TestHotkeyAssignmentsPrefName] == nil) {
        
        NSMutableArray *defaultHotKeys = [NSMutableArray array];
        
        [defaultHotKeys addObject:
         [KeyAssignment assignmentWithName:@"Hotkey1"
                                   keyCode:0
                             modifierFlags:(NSAlternateKeyMask | NSShiftKeyMask)]];
        
        [defaultHotKeys addObject:
         [KeyAssignment assignmentWithName:@"Hotkey2"
                                   keyCode:-1
                             modifierFlags:NSControlKeyMask]];
        
        [defaultHotKeys addObject:
         [KeyAssignment assignmentWithName:@"Hotkey3"
                                   keyCode:-1
                             modifierFlags:NSControlKeyMask]];
        
        [defaultHotKeys addObject:
         [KeyAssignment assignmentWithName:@"Hotkey4"
                                   keyCode:-1
                             modifierFlags:NSControlKeyMask]];
        
        [defaultHotKeys addObject:
         [KeyAssignment assignmentWithName:@"Hotkey5"
                                   keyCode:-1
                             modifierFlags:NSControlKeyMask]];
        
        [defaultHotKeys addObject:
         [KeyAssignment assignmentWithName:@"Hotkey6"
                                   keyCode:-1
                             modifierFlags:NSControlKeyMask]];
        
        
        NSArray *defaultHotKeysAsPlist = [KeyAssignment plistArrayFromAssignments:defaultHotKeys];
        [[NSUserDefaults standardUserDefaults] setObject:defaultHotKeysAsPlist forKey:TestHotkeyAssignmentsPrefName];
        
    }
    // ---
    
    
    // Registering the key assignments 
    NSArray *keyAssignmentsPlist = [[NSUserDefaults standardUserDefaults] objectForKey:TestHotkeyAssignmentsPrefName];
    NSArray *keyAssignments = [KeyAssignment assignmentsFromPlistArray:keyAssignmentsPlist];
    
    for (KeyAssignment *ka in keyAssignments) {
		[ka registerHotKeyAction];
        
        if([ka.name isEqualToString:@"Hotkey1"]) {
            [hotKeyField1 setKeyCombo:SRMakeKeyCombo([ka code], [ka flags])];
        } else if([ka.name isEqualToString:@"Hotkey2"]) {
            [hotKeyField2 setKeyCombo:SRMakeKeyCombo([ka code], [ka flags])];
        } else if([ka.name isEqualToString:@"Hotkey3"]) {
            [hotKeyField3 setKeyCombo:SRMakeKeyCombo([ka code], [ka flags])];
        } else if([ka.name isEqualToString:@"Hotkey4"]) {
            [hotKeyField4 setKeyCombo:SRMakeKeyCombo([ka code], [ka flags])];
        } else if([ka.name isEqualToString:@"Hotkey5"]) {
            [hotKeyField5 setKeyCombo:SRMakeKeyCombo([ka code], [ka flags])];
        } else if([ka.name isEqualToString:@"Hotkey6"]) {
            [hotKeyField6 setKeyCombo:SRMakeKeyCombo([ka code], [ka flags])];
        }
        
	}
    
    // ---
    
    [self.window makeKeyAndOrderFront:self];
    
}

- (void) awakeFromNib {
    
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.window makeKeyAndOrderFront:self];
    return YES;
    
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {
    // Safely disconnect
    [arduino disconnect];
    return NSTerminateNow;
}


#pragma mark -
#pragma mark SRRecorder delegate methods

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    
    // Finding the key combo
    NSArray *keyAssignmentsPlist = [[NSUserDefaults standardUserDefaults] objectForKey:TestHotkeyAssignmentsPrefName];
    NSArray *keyAssignments = [KeyAssignment assignmentsFromPlistArray:keyAssignmentsPlist];
    
    KeyAssignment *ka;
    
    for(KeyAssignment *keh in keyAssignments) {
        
        BOOL meep = NO;
        
        if([[keh name] isEqualToString:@"Hotkey1"] && aRecorder.tag == 1) {
            meep = YES;
        } else if([[keh name] isEqualToString:@"Hotkey2"] && aRecorder.tag == 2) {
            meep = YES;
        } else if([[keh name] isEqualToString:@"Hotkey3"] && aRecorder.tag == 3) {
            meep = YES;
        } else if([[keh name] isEqualToString:@"Hotkey4"] && aRecorder.tag == 4) {
            meep = YES;
        } else if([[keh name] isEqualToString:@"Hotkey5"] && aRecorder.tag == 5) {
            meep = YES;
        } else if([[keh name] isEqualToString:@"Hotkey6"] && aRecorder.tag == 6) {
            meep = YES;
        }
        
        if(meep) {
            ka = keh;
            break;
        }
        
	}
    // ---
    
    if(DEBUGG) NSLog(@"old: %ld %lu %@", ka.code, ka.flags, ka);
    if(DEBUGG) NSLog(@"new: %ld %lu", newKeyCombo.code, newKeyCombo.flags);
    
    [self.window makeFirstResponder:self.window];
    
    // Updating the key combo
	if (ka == nil) return;
	
	if (([ka code] == newKeyCombo.code) && ([ka flags] == newKeyCombo.flags)) return;
	
	[ka unregisterHotKeyAction];
	[ka setCode:newKeyCombo.code];
	[ka setFlags:newKeyCombo.flags];
    [ka registerHotKeyAction];
    
    // ---
    
    
    // Saving the new one to the defaults
    NSMutableArray *newKeyAssignments = [[NSMutableArray alloc] initWithArray:keyAssignments];
    
    for(int i=0; i<[newKeyAssignments count]; i++) {
        KeyAssignment *meh = [newKeyAssignments objectAtIndex:i];
        
        BOOL meep = NO;
        
        if([[meh name] isEqualToString:@"Hotkey1"] && aRecorder.tag == 1) {
            meep = YES;
        } else if([[meh name] isEqualToString:@"Hotkey2"] && aRecorder.tag == 2) {
            meep = YES;
        } else if([[meh name] isEqualToString:@"Hotkey3"] && aRecorder.tag == 3) {
            meep = YES;
        } else if([[meh name] isEqualToString:@"Hotkey4"] && aRecorder.tag == 4) {
            meep = YES;
        } else if([[meh name] isEqualToString:@"Hotkey5"] && aRecorder.tag == 5) {
            meep = YES;
        } else if([[meh name] isEqualToString:@"Hotkey6"] && aRecorder.tag == 6) {
            meep = YES;
        }
        
        if(meep) {
            [newKeyAssignments removeObject:meh];
            [newKeyAssignments addObject:ka];
            break; 
        }
        
    }
    
    NSArray *newKeyAssignmentsPlist = [KeyAssignment plistArrayFromAssignments:newKeyAssignments];
	[[NSUserDefaults standardUserDefaults] setObject:newKeyAssignmentsPlist forKey:TestHotkeyAssignmentsPrefName];
	[[NSUserDefaults standardUserDefaults] synchronize];
    // ---
    
}

#pragma mark - KeyAssignment

- (void) performHotkeyAction:(NSString *)name {
    
    if([name isEqualToString:@"Hotkey1"]) {
        if(DEBUGG) NSLog(@"1");
        [arduino send:@"1"];
    } else if([name isEqualToString:@"Hotkey2"]) {
        if(DEBUGG) NSLog(@"2");
        [arduino send:@"2"];
    } else if([name isEqualToString:@"Hotkey3"]) {
        if(DEBUGG) NSLog(@"3");
        [arduino send:@"3"];
    } else if([name isEqualToString:@"Hotkey4"]) {
        if(DEBUGG) NSLog(@"4");
        [arduino send:@"4"];
    } else if([name isEqualToString:@"Hotkey5"]) {
        if(DEBUGG) NSLog(@"5");
        [arduino send:@"5"];
    } else if([name isEqualToString:@"Hotkey6"]) {
        if(DEBUGG) NSLog(@"6");
        [arduino send:@"6"];
    }
    
}

#pragma mark - Preferences

- (IBAction) showPrefs:(id)sender {
    
    if([arduino isConnected]) { // Show the buttons as disabled
        [self setButtonsDisabled];
    } else { // Show the buttons as enabled
        [self setButtonsEnabled];
    }
    
    [self.window makeKeyAndOrderFront:self];
    
}

- (IBAction) launchWebsite:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://appsforarduino.com/hotkeys"]];
}

#pragma mark - Buttons for connection

- (IBAction) connectPressed:(id)sender {
    
    if(![arduino isConnected]) { // Pressing GO!
        
        if([arduino connect:[serialSelectMenu titleOfSelectedItem] withBaud:B115200]) {
            
            [self setButtonsDisabled];
            //[self.window orderOut:self]; // keep debating whether this should stay or not after pressing go
            
        } else {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert setMessageText:@"Connection Error"];
            [alert setInformativeText:@"Connection failed to start"];
            [alert addButtonWithTitle:@"OK"];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
        }
        
    } else { // Pressing Stop
        
        [arduino disconnect];
        [self setButtonsEnabled];
        
    }
    
}

- (void) setButtonsEnabled {
    [serialSelectMenu setEnabled:YES];
    [connectButton setTitle:@"GO!"];
    [connectButton setKeyEquivalent:@"\r"];
}

- (void) setButtonsDisabled {
    [serialSelectMenu setEnabled:NO];
    [connectButton setTitle:@"Stop"];
    [connectButton setKeyEquivalent:@""];
}

#pragma mark - Arduino Delegate Methods

- (void) receivedString:(NSString *)rx {
}

- (void) portAdded:(NSArray *)ports {
    for(NSString *portName in ports) {
        [serialSelectMenu addItemWithTitle:portName];
    }
}

- (void) portRemoved:(NSArray *)ports {
    for(NSString *portName in ports) {
        [serialSelectMenu removeItemWithTitle:portName];
    }
}

- (void) portClosed {
    [self setButtonsEnabled];
    [self.window makeKeyAndOrderFront:self];
    
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText:@"Disconnected"];
    [alert setInformativeText:@"Apparently the Arduino was disconnected!"];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}

@end
