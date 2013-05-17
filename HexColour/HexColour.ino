/*
 HexColour
 
 Write hex value to RGB leds
 http://anton.mit-license.org 
*/

// Pin configuration
int ledR = 3;
int ledG = 5;
int ledB = 6;

void setup() { 
  Serial.begin(57600);
  pinMode(ledR, OUTPUT);
  pinMode(ledG, OUTPUT);
  pinMode(ledB, OUTPUT);
} 

void loop() { 
  if(Serial.available() > 2){
    int read = 0;
    char inputBuffer[3];
    read = Serial.readBytes(inputBuffer, 3);
    if( read == 3 ){
      analogWrite(ledR,inputBuffer[0]);
      analogWrite(ledG,inputBuffer[1]);
      analogWrite(ledB,inputBuffer[2]);
    }
    //clear rest of buffer
    while(Serial.available()){
      Serial.read();
    }
  }

}

