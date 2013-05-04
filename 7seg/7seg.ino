// Arduino 7 segment display example software
// http://www.hacktronics.com/Tutorials/arduino-and-7-segment-led.html
// License: http://www.opensource.org/licenses/mit-license.php (Go crazy)
 
byte firstPin = 6;
// Define the LED digit patters, from 0 - 9
// Note that these patterns are for common cathode displays
// For common anode displays, change the 1's to 0's and 0's to 1's
// 1 = LED on, 0 = LED off, in this order:
//                    Arduino pin: 6,7,8,9,10,11,12
//                                 g f a b  e  d  c
byte seven_seg_digits[11][7] = { { 0,1,1,1, 1, 1, 1 },  // = 0
                                 { 0,0,0,1, 0, 0, 1 },  // = 1
                                 { 1,0,1,1, 1, 1, 0 },  // = 2
                                 { 1,0,1,1, 0, 1, 1 },  // = 3
                                 { 1,1,0,1, 0, 0, 1 },  // = 4
                                 { 1,1,1,0, 0, 1, 1 },  // = 5
                                 { 1,1,0,0, 1, 1, 1 },  // = 6
                                 { 0,0,1,1, 0, 0, 1 },  // = 7
                                 { 1,1,1,1, 1, 1, 1 },  // = 8
                                 { 1,1,1,1, 0, 0, 1 },  // = 9
                                 { 0,0,0,0, 0, 0, 0 }   // = blank
                               };

void setup() {                
  pinMode(6, OUTPUT);   
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  writeDot(0);  // start with the "dot" off
}

void writeDot(byte dot) {
  digitalWrite(13, dot);
}
    
void sevenSegWrite(byte digit) {
  byte pin = firstPin;
  for (byte segCount = 0; segCount < 7; ++segCount) {
    digitalWrite(pin, seven_seg_digits[digit][segCount]);
    ++pin;
  }
}

void loop() {
  writeDot(0);
  for (byte count = 10; count > 0; --count) {
    sevenSegWrite(count - 1); 
    delay(1000);
  }
  sevenSegWrite(10); 
  writeDot(1);
  delay(4000);
}
