#include <Arduino.h>
#include "Motor.h"

Motor::Motor()
{
    //ctor
}
Motor::Motor(unsigned int Pino)
{
    SetPinoMotor(Pino);
}
void Motor::SetPinoMotor(unsigned int val)
{
    PinoMotor = val;
    pinMode(PinoMotor,OUTPUT);

}
void Motor::Liga()
{
    analogWrite(PinoMotor,PWM);
}
void Motor::Liga(unsigned int _PWM)
{
    analogWrite(PinoMotor,_PWM);
}
void Motor::Desliga()
{
    digitalWrite(PinoMotor,LOW);
}
Motor::~Motor()
{
    //dtor
}
