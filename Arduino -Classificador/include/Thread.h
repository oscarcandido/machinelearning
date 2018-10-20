/***************************************************************************************
 *       CLASSE PARA CRIAÇÃO DE THREADS                                                *
 *       OSCAR FELICIO CANDIDO LONGUINHO                                               *
 ***************************************************************************************/


#ifndef THREAD_H
#define THREAD_H


class Thread
{
    public:
        Thread();
        Thread(unsigned int _Time);
        Thread(unsigned int _Time,bool _Enable);
        unsigned int GetTime();
        void SetTime(unsigned int _Time);
        bool GetEnable();
        void SetEnable(bool _Enable);
        bool Run();
    protected:

    private:
        unsigned int Time;
        bool Enable;
        long int LastRun;
};

#endif // THREAD_H
