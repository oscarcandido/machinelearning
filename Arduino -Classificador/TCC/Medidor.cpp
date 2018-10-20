#include "Medidor.h"
#include <Arduino.h>
Medidor::Medidor()
{

}

Medidor::Medidor(int _Trigger,int _Echo){
    Trigger = _Trigger; //Pino Trigger do sensor ultrassônico
    Echo    = _Echo; // Pino Echo do sensor ultrassônico
}

int Medidor::GetTrigger(){
    return Trigger; //Retorna pino Trigger
}

int Medidor::GetEcho(){
    return Echo; //Retorna pino Echo
}

void Medidor::SetTrigger(int _Trigger){ //Seta pino Trigger
    Trigger = _Trigger;
}

void Medidor::SetEcho(int _Echo){ //Seta o pino Echo
    Echo = _Echo;
}

int Medidor::GetTempo(){ //Calcula o tempo que a onda leva para atingir o obstáculo
    digitalWrite(Trigger,LOW);
    delayMicroseconds(2);
    digitalWrite(Trigger,HIGH);
    delayMicroseconds(10);
    Tempo = pulseIn(Echo,HIGH);
    return Tempo;
}

float Medidor::GetDist(){ //Calcula a distância em centímetros até o obstáculo;
    int _Tmp = GetTempo();
    Dist = (float)_Tmp/34/2;
    return Dist;
}
