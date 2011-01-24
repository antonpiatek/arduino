#include <Wire.h>
#include <stdlib.h>
#include <OneWire.h>
#include <DallasTemperature.h>

//0x5C lcd address converted from 8bit to 7bit
#define LCD (0x2E) 

// Data wire is plugged into pin 2 on the Arduino (can be any digital I/O pin)
#define ONE_WIRE_BUS 2

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);


void setup() {
  // setup LCD
  Wire.begin();

  //give display a second to startup before doing initial setup for it
  delay(1000);
  Wire.beginTransmission(LCD);
  //clear display
  Wire.send(254);
  Wire.send(88);
  //turn off cursor
  Wire.send(254);
  Wire.send(84);
  Wire.endTransmission();

  // setup 1-wire temp sensors
  sensors.begin();
}


void loop() {
  //printTemp_simple();
  printTemp_large();
  delay(500);
} 


// Print simple
void printTemp_simple() {
  sensors.requestTemperatures(); // Send the command to get temperatures

  // Need to convert temperature data to chars for LCD screen
  // %f for sprintf is not linked to save space, so cast to int and then convert to char
  char ascii[2];
  int reading = (int) sensors.getTempCByIndex(0);
  sprintf(ascii,"%2d", reading );

  Wire.beginTransmission(LCD);
  Wire.send( "temp: " );
  Wire.send( ascii );
  Wire.endTransmission();  
}



// Print temperature in large digits
// N.B. does not < 0 properly (no negative indicator)
void printTemp_large() {
  sensors.requestTemperatures(); // Send the command to get temperatures

  int temp = (int) sensors.getTempCByIndex(0);

  Wire.beginTransmission(LCD);

  // set negative sign as required
  moveCursorTo(5,2);
  if( temp < 0 )
  {
    Wire.send("_");
  }
  else
  {
    Wire.send(" ");
  }

  enableBigDigits();
  bigDigit(7, (temp / 10));
  bigDigit(11, (temp % 10));
  moveCursorTo(14,0);
  Wire.send(0xDF); // deg symbol (ish)
  Wire.send("C");
  Wire.endTransmission();  
}



// Write a big Big digit (call enableBigDigits() first)
// params: column, digit
void bigDigit(int col, int digit){
  Wire.send(254);
  Wire.send(35);
  Wire.send(col);
  Wire.send(digit);
}



// initialize large digits
void enableBigDigits(){
  Wire.send(254);
  Wire.send(110);
}



// Move cursor to position
// params: column, row
void moveCursorTo(int col, int row){
  Wire.send(254);
  Wire.send(71);
  Wire.send(col);
  Wire.send(row);
} 


