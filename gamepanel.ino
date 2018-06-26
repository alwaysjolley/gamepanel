/****************************
* Multi function Keyboard (9 button version)
* for simulator games or applications
* Support for color update via Serial.read()
* todo: add support for Neopixels driven by i2c
****************************/

#include <Joystick.h>

// default build is a 25 button, 2 axis game panel
Joystick_ Joystick(0x05,JOYSTICK_TYPE_JOYSTICK,25,0,true,true,false,false,false,false,false,false,false,false,false);
/*
 * ::Perams and defaults
 * hidReportId = 0x03
 * joystickType = JOYSTICK_TYPE_JOYSTICK
 * buttonCount = 32
 * hatSwitchCount = 2
 * IncludeXAxis = true
 * includeYAxis = true
 * IncludeZAxis = true
 * includeRxAxis = true
 * includeRyAxis = true
 * includeRzAxis = true
 * includeRudder = true
 * includeThroddle = true
 * includeAccelerator = true
 * includeBrake = true
 * includeSteering = true
 */


int const sendPin[] = { 4, 5, 6, 7, 8 };
int const sendPinCount = 5;
int const readPin[] = { 9,10,16,14,15 };
int const readPinCount = 5;

void setup() {
  //output pins
  for( int thisPin = 0; thisPin < sendPinCount; thisPin++) {
    pinMode(sendPin[thisPin],OUTPUT);
    digitalWrite(sendPin[thisPin], HIGH);
  }
  // pullup input pins
  for( int thisPin = 0; thisPin < readPinCount; thisPin++) {
    pinMode(readPin[thisPin],INPUT_PULLUP);
  }

  Joystick.begin();
}

void begin() {
  Serial.begin(9600);
}

void loop() {
  //button loop
  for( int x = 0; x < sendPinCount; x++) {
    digitalWrite(sendPin[x], LOW);
    for( int y = 0; y < readPinCount; y++) {
      if(digitalRead(readPin[y])==LOW){
        Joystick.pressButton((x*5)+y);
      }else{
        Joystick.releaseButton((x*5)+y);
      }
    }
    digitalWrite(sendPin[x],HIGH);
  }
  // update Axis
  Joystick.setXAxis(analogRead(A0));
  Joystick.setYAxis(analogRead(A1));
}
