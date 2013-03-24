/*
 Based on http://arduino.cc/en/Tutorial/Fading 

 The circuit:
 * Red   LED attached from digital pin 9  to ground.
 * Blue  LED attached from digital pin 10 to ground.
 * Green LED attached from digital pin 11 to ground.
 
 This example code is in the public domain.
 */
#define R  9
#define G  10
#define B  11

//set delay
int d = 100;
//set rate of change per colour
int Rmod = 4;
int Gmod = 5;
int Bmod = 3;
//set starting colour  
int r=0;
int g=0;
int b=0;


void setup()  { 
  //analog pins need no setup?  
  
  //flash each colour in order, just for wiring checks
  int i=800;
  
  //red
  analogWrite(R, 255);
  analogWrite(G, 0);
  analogWrite(B, 0);   
  delay(i);
  
  //green
  analogWrite(R, 0);
  analogWrite(G, 255);
  analogWrite(B, 0);
  delay(i);

  //blue
  analogWrite(R, 0);
  analogWrite(G, 0);
  analogWrite(B, 255);
  delay(i);
    
  //yellow
  analogWrite(R, 255);
  analogWrite(G, 255);
  analogWrite(B, 0);
  delay(i);
  
  //magenta
  analogWrite(R, 255);
  analogWrite(G, 0);
  analogWrite(B, 255);
  delay(i);
  
  //cyan
  analogWrite(R, 0);
  analogWrite(G, 255);
  analogWrite(B, 255);
  delay(i);
  
  //white
  analogWrite(R, 255);
  analogWrite(G, 255);
  analogWrite(B, 255);
  delay(i);
  
  //off
  analogWrite(R, 0);
  analogWrite(G, 0);
  analogWrite(B, 0);
} 


void loop()  {
  //change colour
  r+=Rmod;
  g+=Gmod;
  b+=Bmod;
   //limit to max or min
  if( r>255 ){ r=255;}
  if( r<0   ){ r=0;}
  if( g>255 ){ g=255;}
  if( g<0   ){ g=0;}
  if( b>255 ){ b=255;}
  if( b<0   ){ b=0;}
  //set leds 
  analogWrite(R, r);           
  analogWrite(G, g);           
  analogWrite(B, b);           
  //reverse direction if hit max/min
  if( r==255 || r==0 ){ Rmod = - Rmod; }
  if( g==255 || g==0 ){ Gmod = - Gmod; }
  if( b==255 || b==0 ){ Bmod = - Bmod; }
  //sleep
  delay(d);    

}
