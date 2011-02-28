#include <Wire.h>
#include <stdlib.h>
#include <OneWire.h>
#include <DallasTemperature.h>

//0x5C lcd address converted from 8bit to 7bit
#define LCD (0x2E)

#define _DEBUG 1

// Data wire is plugged into pin 2 on the Arduino (can be any digital I/O pin)
#define ONE_WIRE_BUS 2

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);

int numberOfTemperatureSensors;

const int knownSensorCount = 3;
char* knownSensorAddresses[] = { "28CE85BB020000C1","28E6EFBA020000F5","28EF7FBB0200005B" };
char* knownSensorNames[] = { "Bedroom ","LivingRm","Outside "};

int actualToExpected[ knownSensorCount ];

int lastTemp = 0;

boolean resetDisplay = false;

void setup() {
  // setup LCD
  Wire.begin();

  //give display a second to startup before doing initial setup for it
  delay(1000);
  Wire.beginTransmission(LCD);
  //clear display
  clearLCD();
  //turn off cursor
  Wire.send(254);
  Wire.send(84);
  Wire.endTransmission();

  // setup 1-wire temp sensors
  sensors.begin();

  // start serial port
  Serial.begin(9600);

  delay(500); //wait a bit

  checkKnownSensors();
  Serial.println("initialised...");
}


void loop() {
  if( resetDisplay) 
  {
    Wire.beginTransmission(LCD);
    clearLCD();
    Wire.endTransmission();
  }
  //printTemp_simple();
  
  sensors.requestTemperatures(); // Send the command to get temperatures
  for( int i=0; i<numberOfTemperatureSensors; i++)
  { 
    DeviceAddress device;
    if(sensors.getAddress(device, i))
    {  
      float temp = sensors.getTempCByIndex(i);
      
      Wire.beginTransmission(LCD);    
      //reset display when we move to single digit screen
      if( (temp < 10 && lastTemp >= 10) ||
          (temp > -10 && lastTemp < -10 ) )
      {
        clearLCD();
      }
      
      moveCursorTo(0,0);
      if( actualToExpected[i] != -1 )
      {        
        char* name =  knownSensorNames[ actualToExpected[i] ] ;
        //TODO: pad out string
        Wire.send( name );
        Serial.print( name );
        Serial.print(": ");
      }
      else
      {
        Wire.send( "unknown" );
        Serial.print("unkown: ");
      }
      Wire.endTransmission();
      
   
      if( temp < -60 )
      {
        Wire.beginTransmission(LCD);
        Wire.send( "invalid reading: " );
        Wire.endTransmission();  
        resetDisplay = true;
      }
      else
      {
        resetDisplay = false;
        printTemp_large(temp);
        Serial.println(temp);
      }
      delay(2000);
    }
  }
}

/*
// Print simple
void printTemp_simple() 
{
  sensors.requestTemperatures(); // Send the command to get temperatures

  // Need to convert temperature data to chars for LCD screen
  // %f for sprintf is not linked to save space, so cast to int and then convert to char
  char ascii[3]; //2 val temp, plus null termination
  int reading = (int) sensors.getTempCByIndex(0);
  sprintf(ascii,"%2d", reading );

  Wire.beginTransmission(LCD);
  Wire.send( "temp: " );
  Wire.send( ascii );
  Wire.endTransmission();
}
*/


// Print temperature in large digits
void printTemp_large(float floatTemp) 
{
  int temp = (int) floatTemp;
  int d = (int) abs( (floatTemp - temp)*10 );
  char decimalPlace[2]; //1 val temp, plus null termination
//  sprintf(decimalPlace,"%1d", abs(d) ); //use itoa instead
  itoa(d,decimalPlace,10);

  Wire.beginTransmission(LCD);

  int negativePos = 9;
  int digitOne = (temp / 10);
  int digitTwo = (temp % 10);
  
  if( floatTemp < 0 )
  {
    digitOne = 0 - digitOne;
    digitTwo = 0 - digitTwo;
    negativePos = 12;
  }


  enableBigDigits();  
  if( temp <= -10 || temp >= 10 )
  {
    bigDigit(11, digitOne);    
  }
  bigDigit(15, digitTwo);

  moveCursorTo(18,0);
  Wire.send(0xDF); // deg symbol (ish)
  Wire.send("C");

  // set negative sign as required  
  moveCursorTo(negativePos,6);
  if( floatTemp < 0 )
  {
    Wire.send("_");
  }
  else
  {
    Wire.send(" ");
  }
  
  //send decimal value
  moveCursorTo(18,4);
  Wire.send(".");
  Wire.send(decimalPlace);

  Wire.endTransmission();
  
  lastTemp = temp;
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


// clear LCD display
void clearLCD()
{
  Wire.send(254);
  Wire.send(88);
}


// function to convert a device address
char* convertAddress(DeviceAddress deviceAddress)
{
  char r[17];
  for (uint8_t i = 0; i < 8; i++)
  {
    char t[3]; //2 charts + \0 to terminate :-o
    sprintf(t , "%2.2X", deviceAddress[i] );//TODO use 
    r[i*2] = t[0];
    r[i*2 + 1] = t[1];
    #ifdef _DEBUG
      Serial.print(t);
      Serial.print(" ");
    #endif
  }
  r[16] = '\0'; // don't forget trailing null
  #ifdef _DEBUG
    Serial.print(" = '");
    Serial.print( r );
    Serial.println("'");
  #endif
  return r;
}


void checkKnownSensors()
{
  // Grab a count of devices on the wire
  numberOfTemperatureSensors = sensors.getDeviceCount();
  sensors.requestTemperatures(); // Send the command to get temperatures

  if( numberOfTemperatureSensors != knownSensorCount )
  {
    Serial.print("ERROR: I expected to find ");
    Serial.print( knownSensorCount );
    Serial.print(" sensors, but actually found ");
    Serial.println( numberOfTemperatureSensors );
    Wire.beginTransmission(LCD);
    Wire.send("ERROR: expected ");
    char a[2]; //1 val temp, plus null termination
    itoa(knownSensorCount,a,10);
    Wire.send( a );
    Wire.send("\nbut found ");b
    itoa(numberOfTemperatureSensors,a,10);
    Wire.send( a );
    Wire.send("\n");
    Wire.endTransmission();
    delay(3000);
    Wire.beginTransmission(LCD);
    //clear display
    clearLCD();
    Wire.endTransmission();
  }
  else
  {
    //print details of 1-wire sensors to serial
    Serial.print(numberOfTemperatureSensors);
    Serial.println(" temp sensors found");
  }
  Serial.println();

  // Loop through each device, print out address
  for(int i=0; i<numberOfTemperatureSensors; i++)
  {
    DeviceAddress tempDeviceAddress; // We'll use this variable to store a found device address
    // Search the wire for address
    if(sensors.getAddress(tempDeviceAddress, i))
    {
      boolean found = false;
      char* converted = convertAddress(tempDeviceAddress);
      String convString = String(converted);
      
      for(int j=0; j<knownSensorCount; j++)
      {
        if( strcmp(knownSensorAddresses[j], converted) ==0 )
        {
          actualToExpected[i]=j; // set actual to expected
          Serial.println("found sensor with address "+String( knownSensorAddresses[j] )
            +" which should be "+String(knownSensorNames[j]));
          found = true;
          break;
        }
      }
      if(! found )
      {
        actualToExpected[i]= -1; //set unknown match
        Serial.print("Found unknown device ");
        Serial.print(i, DEC);
        Serial.print(" with address " + convString + " reading temperature ");
        Serial.println( sensors.getTempC(tempDeviceAddress) );
       }
    }
    else //else ghost device - check power,cables, etc
    {
      Serial.print("Error reading device ");
      Serial.print(i, DEC);
      Serial.println(", check power and cables");
    }
  }
}
