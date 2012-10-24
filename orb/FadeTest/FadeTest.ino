/*
 Fade
 
 This example shows how to fade an LED on pin 9
 using the analogWrite() function.
 
 This example code is in the public domain.
 */

int ledR = 8;           // the pin that the LED is attached to
int ledG = 9;           // the pin that the LED is attached to
int ledB = 10;           // the pin that the LED is attached to
int brightnessR = 0;    // how bright the LED is
int brightnessG = 0;    // how bright the LED is
int brightnessB = 0;    // how bright the LED is
int fadeAmountR = 5;    // how many points to fade the LED by
int fadeAmountG = 7;    // how many points to fade the LED by
int fadeAmountB = 9;    // how many points to fade the LED by

// the setup routine runs once when you press reset:
void setup()  { 
  // declare pin 9 to be an output:
  pinMode(ledR, OUTPUT);
  pinMode(ledG, OUTPUT);
  pinMode(ledB, OUTPUT);
  
  int c=0;
  while(c<3){
  analogWrite(ledR, 255);    
  analogWrite(ledG, 0);   
  analogWrite(ledB, 0);   
  delay(500);
  analogWrite(ledR, 0);    
  analogWrite(ledG, 255);    
  analogWrite(ledB, 0);    
  delay(500);
  analogWrite(ledR, 0);    
  analogWrite(ledG, 0);    
  analogWrite(ledB, 255);    
  delay(500);
  c++;
  }
} 

// the loop routine runs over and over again forever:
void loop()  { 
  analogWrite(ledR, brightnessR);    
  analogWrite(ledG, brightnessG);    
  analogWrite(ledB, brightnessB);    
    

    // change the brightness for next time through the loop:
    brightnessR = brightnessR + fadeAmountR;
    brightnessG = brightnessG + fadeAmountG;
    brightnessB = brightnessB + fadeAmountB;
  
    // reverse the direction of the fading at the ends of the fade: 
    if (brightnessR == 0 || brightnessR >= 255) {
      fadeAmountR = -fadeAmountR ; 
    }
    if (brightnessG == 0 || brightnessG >= 255) {
      fadeAmountG = -fadeAmountG ; 
    }
    if (brightnessB == 0 || brightnessB >= 255) {
      fadeAmountB = -fadeAmountB ; 
    }    
    // wait for 30 milliseconds to see the dimming effect    
    delay(100);
}

