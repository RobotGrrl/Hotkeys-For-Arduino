[Hotkeys for Arduino](http://appsforarduino.com/hotkeys)
==================

Control your Arduino with custom global keyboard shortcuts using Hotkeys for Arduino!

[Get it now on the Mac App Store!](http://itunes.apple.com/us/app/hotkeys-for-arduino/id498494016?mt=12)


FEATURES

- Works in background
- Six customizable keyboard shortcuts
- Example sketch
- Easy to integrate into projects


WORKS GREAT FOR

- Home automation - Command what actions should happen with the hotkeys. For example: turning on/off lights in a room!
- Accent lighting - Easily control LEDs to create a mixture of colours to suit your need
- Quick testing - Experiment with different actions without having to dig through the code each time
- Live demos - Effectively communicate your project's ideas and concepts with others
- And more! - Arduino projects are only limited by your imagination! Create the next best project, and use Hotkeys for Arduino to control it.


##Usage

Hotkeys for Arduino demonstrates how you can use [Matatino](http://appsforarduino.com/matatino) to interact with your Arduino.

[Hotkeys_LEDs.ino](http://appsforarduino.com/hotkeys-dist/Hotkeys_LEDs.ino) - Here is a pre-baked example sketch that you can use to test! We have LEDs connected on pins 13-6.

Or, you can just inset this snippet of code into your existing sketch. Make sure that Serial is running at 115200 baud, and currentAction is an int.

	if(Serial.available() > 0) {
    	char c = (char)Serial.read();
    	currentAction = atoi(&c);
  	}
 
  	switch(currentAction) {
   		case 1:
      	// Action 1
      	break;
    	case 2:
      	// Action 2
      	break;
    	case 3:
      	// Action 3
      	break;
    	case 4:
      	// Action 4
      	break;
    	case 5:
      	// Action 5
      	break;
    	case 6:
      	// Action 6
      	break;
  	}

If you are going to be using Hotkeys for Arduino to build the application to use it as a standalone, then do a Tweetware micro-action on [this page](http://appsforarduino.com/hotkeys). It's an honour system, I know you'll be cool!


##Contribute

Hotkeys for Arduino is Open Source under the BSD 3-Clause license! Fork the repository, and modify it all you want. We encourage you to redistribute your code. If you do create something cool or improve upon this, please let us know!

There aren't that many more features that you can add on to hotkeys… maybe annoying sound effects?

:D Either way, contributions are welcome!


##License

Hotkeys for Arduino is released under the [BSD 3-Clause license](http://www.opensource.org/licenses/BSD-3-Clause). You can view our other legal information in legal.markdown or on the [website](http://appsforarduino.com/hotkeys).