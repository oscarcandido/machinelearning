

#include <Arduino.h>
#include <SD.h>
#include "ColorSensor.h"


//Pinos do sensor de cor

#define S0 4
#define S1 5
#define S2 6
#define S3 7
#define Out 8
#define Freq 20
//Sensor de cor
ColorSensor Sensor(S0,S1,S2,S3,Out,Freq);

void setup()
{
	Serial.begin(9600);
}

void loop()
{
	Serial.print("Vermelho = ");
    int Red = Sensor.GetRed();
    Serial.print(Red);
	Serial.print("\t");
	Serial.print("Verde = ");
    int Green = Sensor.GetGreen();
    Serial.print(Green);
	Serial.print("\t");
	Serial.print("Azul = ");
    int Blue = Sensor.GetBlue();
    Serial.println(Blue);

	delay(500);              // wait for a second

}
