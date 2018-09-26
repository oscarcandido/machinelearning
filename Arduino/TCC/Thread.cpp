#include "Thread.h"
#include <Arduino.h>

Thread::Thread(){
    LastRun = 0;

}
Thread::Thread(unsigned int _Time){
    Time  = _Time;
    Enable = true;
    LastRun = 0;
}
Thread::Thread(unsigned int _Time,bool _Enable){
    Time  = _Time;
    Enable = _Enable;
    LastRun = 0;

}
unsigned int Thread::GetTime(){
    return Time;
}
void Thread::SetTime(unsigned int _Time){
    Time = _Time;
}
bool Thread::GetEnable(){
    return Enable;
}
void Thread::SetEnable(bool _Enable){
    Enable = _Enable;
}
bool Thread::Run(){
    if((millis()- LastRun >= Time) && (Enable)){
        LastRun = millis();
        return true;
    }
    else{
        return false;
    }
}
