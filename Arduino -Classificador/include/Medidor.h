/***************************************************************************************
 *       CLASSE PARA USO DO SENSOR ULTRASS�NICO  HC-SR04 COMO MEDIDOR DE DIST�NCIA     *
 *       OSCAR FELICIO CANDIDO LONGUINHO                                               *
 ***************************************************************************************/
#ifndef MEDIDOR_H
#define MEDIDOR_H

class Medidor
{
    public:
        Medidor();
        Medidor(int _Trigger,int _Echo);
        int GetTrigger();
        int GetEcho();
        void SetTrigger(int _Ttrigger);
        void SetEcho(int _Echo);
        int GetTempo();
        float GetDist();
    protected:
    private:
        int Trigger;
        int Echo;
        int Tempo;
        float Dist;

};

#endif // MEDIDOR_H
