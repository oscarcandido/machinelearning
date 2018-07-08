/***************************************************************************************
 *       CLASSE PARA USO DO SENSOR TCS230                                              *
 *       OSCAR FELICIO CANDIDO LONGUINHO - 2018                                        *
 ***************************************************************************************/
/*
    TERMINAIS

    S0,S1 - Entrada de Seleção da escala da frequência de saída
    S2,S3 - Entrada de seleção do tipo de foto diodo
    Out   - Saída da Frequência

    OPÇÕES SELECIONÁVEIS

    ----------------------------------------------
    |   S0  |   S1  |   ESCLA DA FREQ. DE SAÍDA  |
    ----------------------------------------------
    |   L   |   L   |   Power down               |
    |   L   |   H   |   2%                       |
    |   H   |   L   |   20%                      |
    |   H   |   H   |   100%                     |
    ----------------------------------------------


    ----------------------------------------------
    |   S2  |   S3  |   TIPO DO FOTO DIODO       |
    ----------------------------------------------
    |   L   |   L   |   Vermelho                 |
    |   L   |   H   |   Azul                     |
    |   H   |   L   |   Sem Filtro               |
    |   H   |   H   |   Verde                    |
    ----------------------------------------------


*/
#ifndef COLORSENSOR_H
#define COLORSENSOR_H


class ColorSensor
{
    public:

        /*** CONSTRUTORES ***/

        ColorSensor();
        ColorSensor(unsigned int S0,unsigned int S1,unsigned int S2,unsigned int S3,unsigned int Out);
        ColorSensor(unsigned int S0,unsigned int S1,unsigned int S2,unsigned int S3,unsigned int Out,unsigned int Freq);

        /*** DESTRUTORES ***/

        virtual ~ColorSensor();

        /*** MÉTODOS ***/

        void SetOutFreq(unsigned int val);// Configura escala de frequência de saída
        unsigned int GetpinS0() { return pinS0; }//Retorna pino configurado como S0
        void SetpinS0(unsigned int val);//Configura pino S0
        unsigned int GetpinS1() { return pinS1; }//Retorna pino configurado como S1
        void SetpinS1(unsigned int val);//Configura pino S1
        unsigned int GetpinS2() { return pinS2; }//Retorna pino configurado como S2
        void SetpinS2(unsigned int val);//Configura pino S2
        unsigned int GetpinS3() { return pinS3; }//Retorna pino configurado como S3
        void SetpinS3(unsigned int val);//Configura pino S3
        unsigned int GetpinOut() { return pinOut; }//Retorna pino configurado como Saída
        void SetpinOut(unsigned int val);//Configura pino de saída
        unsigned int GetRed();//Retorna leitura com filtro vermelho configurado
        unsigned int GetGreen();//Retorna leitura com filtro verde configurado
        unsigned int GetBlue();// retorna leitura com filtro azul configurado
    protected:
    private:
        unsigned int pinS0;//Armazena número do pino S0
        unsigned int pinS1;//Armazena número do pino S1
        unsigned int pinS2;//Armazena número do pino S2
        unsigned int pinS3;//Armazena número do pino S3
        unsigned int pinOut;//Armazena número do pino de Saída
        unsigned int Red;//Armazena leitura com filtro vermelho ativado
        unsigned int Green;//Armazena leitura com filtro Verde ativado
        unsigned int Blue;//Armazena leitura com filtro Azul ativado
};

#endif // COLORSENSOR_H
