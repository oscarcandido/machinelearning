#ifndef MOTOR_H
#define MOTOR_H


class Motor
{
    public:
        Motor();
        Motor(unsigned int Pino);
        virtual ~Motor();
        unsigned int GetPinoMotor() { return PinoMotor; }
        void SetPinoMotor(unsigned int val);
        unsigned int GetPWM() { return PWM; }
        void SetPWM(unsigned int val) { PWM = val; }
        void Liga();
        void Liga(unsigned int _PWM);
        void Desliga();
    protected:
    private:
        unsigned int PinoMotor;
        unsigned int PWM;
};

#endif // MOTOR_H
