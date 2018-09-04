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


//Pinos do sensor de cor

#define S0 50
#define S1 51
#define S2 52
#define S3 53
#define Out 48
#define Freq 100
#define OE 49

//Pino motor

#define Motor 30

//Pino sensor presença
#define Presenca 20

//Variaveis globais
File Dados;//Arquivo de dados
const int chipSelect = 4;
//estrutura de cores

struct RGB{
    byte red;
    byte green;
    byte blue;
};

//Sensor de cor
ColorSensor Sensor(OE,S0,S1,S2,S3,Out,Freq);

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
void setup()
{
	Serial.begin(9600);
	Sensor.SetEnable(true);
	pinMode(Motor,OUTPUT);
	pinMode(Presenca,INPUT);
	if (SD.begin(chipSelect)){
        Serial.println("CartãoSD pronto para uso");
    } else {
        Serial.println("Falha ao inicia cartão SD");
        return;
    };
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
    Dados = SD.open("log.csv",FILE_WRITE);
    if (Dados){
        Dados.print(Red);
        Dados.print(";");
        Dados.print(Green);
        Dados.print(";");
        Dados.println(Blue);
    }
    Dados.close();
	delay(500);              // wait for a second

}
