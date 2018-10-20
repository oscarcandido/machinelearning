/*
CORES DOS CONECTORES SENSOR DE COR

PRETO       GND
BRANCO      OE
CINZA       OUT
VERMELHO    VCC
AZUL        S2
VERDE       S3
AMARELO     S1
LARANJA     S0
*/

#include <Arduino.h>
#include <SPI.h>
#include <SD.h>
#include "ColorSensor.h"
#include "Motor.h"


//Pinos do sensor de cor

#define S0 50
#define S1 51
#define S2 52
#define S3 53
#define Out 48
#define Freq 2
#define OE 49

//Pino motor

#define PinMotor 44

//Pino sensor presença

#define PinPresenca 3

//Variaveis globais

File Dados;//Arquivo de dados
const int chipSelect = 4;
byte Flag = 0;
//estrutura de cores

struct RGB{
    byte red;
    byte green;
    byte blue;
};

//Sensor de cor
ColorSensor Sensor(OE,S0,S1,S2,S3,Out,2);

//Motor
Motor Motor(PinMotor);

RGB ReadColor()
{
    RGB Color = {0,0,0};
    if (Sensor.GetEnable() == true)
    {
        Color.red    = Sensor.GetRed();
        Color.green  = Sensor.GetGreen();
        Color.blue   = Sensor.GetBlue();
    }
    return Color;

}
//captura dados da peça e grava no cartão SD
void GetData()
{
    Motor.Desliga();
    int Red = Sensor.GetRed();
    int Green = Sensor.GetGreen();
    int Blue = Sensor.GetBlue();
    delay(50);
    int Tini = millis();
    while ((digitalRead(PinPresenca) == HIGH)){
        Motor.Liga();
    }
    int Tfim = millis();
    int DeltaT = Tfim -Tini;
    Serial.print("[");
    Serial.print(Red);
    Serial.print(";");
    Serial.print(Green);
    Serial.print(";");
    Serial.print(Blue);
    Serial.print(";");
    Serial.print(DeltaT);
    Serial.print("]");

}
void setup()
{
	Serial.begin(9600);
	//Configura Sensor de cor

	Sensor.SetEnable(true);

    Sensor.SetOutFreq(2);
	//Configura motor

	Motor.Desliga();
    Motor.SetPWM(255);

    //Configura sensor de presença

//	attachInterrupt(digitalPinToInterrupt(PinPresenca),GetData,RISING);
    pinMode(PinPresenca,INPUT);
	//Configura cartão SD
	if (SD.begin(chipSelect)){
        Serial.println("CartãoSD pronto para uso");
    } else {
        Serial.println("Falha ao inicia cartão SD");
        return;
    };
}

void loop()
{

    while ((digitalRead(PinPresenca) == LOW)){
        Motor.Liga();
    }
    if (digitalRead(PinPresenca == HIGH)){
        GetData();
    }
}
