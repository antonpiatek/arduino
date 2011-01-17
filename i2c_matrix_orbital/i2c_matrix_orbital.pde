#include <Wire.h>
#include <stdlib.h>
#define LCD (0x2E) //0x5C lcd address converted from 8bit to 7bit

int value = 0;
int volts = 0;
char valueStr[5];

void setup() {
  Serial.begin(9600);
  Wire.begin();
  
  // Initialise display with clear command
  Wire.beginTransmission(LCD);
  Wire.send(254);
  Wire.send(88);
  Wire.endTransmission();
}


void loop() {
  if (Serial.available() > 0) {
    char c = Serial.read();
    Serial.write(c);
    Wire.beginTransmission(LCD);
    Wire.send(c);
    Wire.endTransmission();  
  }
} 

