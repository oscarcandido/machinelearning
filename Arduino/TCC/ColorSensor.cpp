#include <Arduino.h>
#include "ColorSensor.h"


/*** CONSTRUTORES ***/

ColorSensor::ColorSensor()
{

}
ColorSensor::ColorSensor(unsigned int S0,unsigned int S1,unsigned int S2,unsigned int S3,unsigned int Out)
{
    SetpinS0(S0);
    SetpinS1(S1);
    SetpinS2(S2);
    SetpinS3(S3);
    SetpinOut(Out);
}
ColorSensor::ColorSensor(unsigned int S0,unsigned int S1,unsigned int S2,unsigned int S3,unsigned int Out,unsigned int Freq)
{
    SetpinS0(S0);
    SetpinS1(S1);
    SetpinS2(S2);
    SetpinS3(S3);
    SetpinOut(Out);
    SetOutFreq(Freq);

}

ColorSensor::ColorSensor(unsigned int OE,unsigned int S0,unsigned int S1,unsigned int S2,unsigned int S3,unsigned int Out,unsigned int Freq)
{
    SetPinOE(OE);
    SetpinS0(S0);
    SetpinS1(S1);
    SetpinS2(S2);
    SetpinS3(S3);
    SetpinOut(Out);
    SetOutFreq(Freq);
}

/*** DESTRUTOR ***/

ColorSensor::~ColorSensor()
{
    //dtor
}
/*** MÉTODOS ***/

void ColorSensor::SetEnable(bool val)
{
    if (val)
    {
        digitalWrite(pinOE,LOW);
    }
    else
    {
        digitalWrite(pinOE,HIGH);
    }
}
bool ColorSensor::GetEnable()
{
    if (digitalRead(pinOE)== LOW)
    {
        return true;
    }
    else
    {
        return false;
    }
}
void ColorSensor::SetPinOE(unsigned int val)//Configura pino OE
{
    pinOE = val;
    pinMode(pinOE,OUTPUT);
}
void ColorSensor::SetpinS0(unsigned int val)//Configura pino S0
{
    pinS0 = val;
    pinMode(pinS0,OUTPUT);
}
void ColorSensor::SetpinS1(unsigned int val)//Configura pino S1
{
    pinS1 = val;
    pinMode(pinS1,OUTPUT);
}
void ColorSensor::SetpinS2(unsigned int val)//Configura pino S2
{
    pinS2 = val;
    pinMode(pinS2,OUTPUT);
}
void ColorSensor::SetpinS3(unsigned int val)//Configura pino S3
{
    pinS3 = val;
    pinMode(pinS3,OUTPUT);
}
void ColorSensor::SetpinOut(unsigned int val)//Configura pino de Saída
{
    pinOut = val;
    pinMode(pinOut,INPUT);
}
void ColorSensor::SetOutFreq(unsigned int val)// Configura escala de frequência de saída
{
    digitalWrite(pinS0,LOW);
    digitalWrite(pinS1,LOW);
    switch(val)
    {
        case 2:
            digitalWrite(pinS0,LOW);
            digitalWrite(pinS1,HIGH);
            break;
        case 20:
            digitalWrite(pinS0,HIGH);
            digitalWrite(pinS1,LOW);
            break;
        case 100:
            digitalWrite(pinS0,HIGH);
            digitalWrite(pinS1,HIGH);
            break;
    }
}

/********************************************
*       LEITURA DA COR VERMELHA             *
*********************************************/

unsigned int ColorSensor::GetRed(){
   digitalWrite(pinS2,LOW);
   digitalWrite(pinS3,LOW);
   Red = pulseIn(pinOut,LOW);
return Red;
}

/********************************************
*       LEITURA DA COR VERDE                *
*********************************************/

unsigned int ColorSensor::GetGreen(){
   digitalWrite(pinS2,HIGH);
   digitalWrite(pinS3,HIGH);
   Green = pulseIn(pinOut,LOW);
return Green;
}

/********************************************
*       LEITURA DA COR AZUL                 *
*********************************************/

unsigned int ColorSensor::GetBlue(){
   digitalWrite(pinS2,LOW);
   digitalWrite(pinS3,HIGH);
   Blue = pulseIn(pinOut,LOW);
return Blue;
}



