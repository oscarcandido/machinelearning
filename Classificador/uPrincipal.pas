unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,IniFiles,Math,
  Vcl.ExtCtrls,jpeg, AdPacket, OoMisc, AdPort;

type
  TFrmClassifica = class(TForm)
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    gpbDados: TGroupBox;
    GroupBox1: TGroupBox;
    lblNumCamadas: TLabel;
    GroupBox2: TGroupBox;
    LblNeucamadas: TLabel;
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Image1: TImage;
    Panel6: TPanel;
    Panel7: TPanel;
    ApdComPort1: TApdComPort;
    ApdDataPacket1: TApdDataPacket;
    ComboBox1: TComboBox;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    procedure ImportaRede(Arquivo:TiniFile);
    function Classifica(Amostra:tarray<real>):Integer;
    function StrArrayToFloatArray(AArray:Tarray<string>):Tarray<Real>;
    function MultiplicaArray(Array1:Tarray<real>;Array2:Tarray<real>):Real;
    function LogSig(x:Real):Real;
    function Normaliza(Dados:Tarray<real>;Media:Real;Desvio:Real):Tarray<real>;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ApdDataPacket1StringPacket(Sender: TObject; Data: AnsiString);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmClassifica: TFrmClassifica;
  Rede :String;                   //Configura��o da rede :Neur�nios por cada
  Camadas:Tarray<string>;         //cada item cotem o numero de neur�nios em cada camada
  NumCamadas:Integer;             //N�mero de Camadas
  NivelAtivacao : real;           //Nivel d eajuste da sa�da, acima do valor � considerado ativado
  Pesos: array of Tarray<string>; //Pesos sin�ptcos dos neur�nios
  Classe : Integer;               //Classa identificada pela rede
  MediaDados :Real;               //M�dia dos dados utilizados no treinamento da rede
  DesvioPadrao: Real;             //Desvio padr�o dos dados utilizados no treinamento da rede
implementation

{$R *.dfm}

procedure TFrmClassifica.ApdDataPacket1StringPacket(Sender: TObject;
  Data: AnsiString);
var
  AmostraStr:Tarray<string>;
  DataStr :String;
  Amostra : Tarray<real>;
begin
  DataStr := Data;
  DataStr := DataStr.Replace('[','');
  DataStr := DataStr.Replace(']','');
  DataStr := '1;' + DataStr;
  AmostraStr := DataStr.Split([';']);
  Amostra := StrArrayToFloatArray(AmostraStr);
  Amostra := Normaliza(Amostra,MediaDados,DesvioPadrao);
  Classe  := Classifica(Amostra);
end;

procedure TFrmClassifica.BitBtn1Click(Sender: TObject);
begin
  ApdComPort1.ComNumber := ComboBox1.ItemIndex;
  ApdComPort1.Open := True;
end;

procedure TFrmClassifica.BitBtn2Click(Sender: TObject);
begin
//  Classe := Classifica(Edit1.Text);
  try
    Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'Classe'+inttostr(Classe)+'.jpg');
  except

  end;
end;
{************************************************************************
*                                                                       *
*  Fun��o Classifica                                                    *
*  Executa o Forward da rede                                            *
*  Amostra: Vetor com os dados da amostra a ser classificada            *
*  Retorno: Valor inteiro correspondente ao neur�nio ativado na sa�da   *
*                                                                       *
************************************************************************}
function TFrmClassifica.Classifica(Amostra: Tarray<Real>):Integer;
var
  I: Integer;
  PesoStr : Tarray<string>;
  PesoFlt : Tarray<real>;
  J: Integer;
  OutPuts : array of Tarray<real>;
  k: Integer;
begin
  SetLength(OutPuts,NumCamadas);
  for I := 0 to pred(NumCamadas) do
  begin
    SetLength(OutPuts[I],StrToInt(Camadas[I])+1);
    OutPuts[I][0] := 1;
    for J := 1 to StrToInt(Camadas[I]) do
    begin
      PesoStr := Pesos[I][J-1].Split([';']);
      PesoFlt := StrArrayToFloatArray(PesoStr);
      if I = 0 then
        OutPuts[I][J] := LogSig(MultiplicaArray(Amostra,PesoFlt))
      else
        OutPuts[I][J] := LogSig(MultiplicaArray(OutPuts[I-1],PesoFlt))
    end;
  end;
  OutPuts[I-1][0] := 0;
  for k := 1 to pred(Length(OutPuts[I-1])) do
  begin
    if Outputs[I-1][K] > NivelAtivacao then
       Result := k;
  end;

end;

procedure TFrmClassifica.FormCreate(Sender: TObject);
var
  Arquivo:TiniFile;
begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Rede.ini') then
  begin
     Arquivo := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Rede.ini');
     ImportaRede(Arquivo);
  end;

end;

{************************************************************************
*                                                                       *
*  Procedure Importa Rede                                               *
*  Importa os dados da rede a partir de um arquivo .ini                 *
*  Arquivo: Arquivo .ini contendo os par�metros da rede                 *
*                                                                       *
************************************************************************}
procedure TFrmClassifica.ImportaRede(Arquivo:TiniFile);
var
  PesoCamada:String;
  I: Integer;
begin
  Rede          := Arquivo.ReadString('REDE','Camadas','');
  MediaDados    := StrToFloat(Arquivo.ReadString('DADOS_TREINAMENTO','Media','0'));
  DesvioPadrao  := StrToFloat(Arquivo.ReadString('DADOS_TREINAMENTO','Desvio','1'));
  Camadas       := Rede.Split([',']);
  NivelAtivacao := StrToFloat(Arquivo.ReadString('REDE','NivelAtivacao',''));
  NumCamadas    := Length(Camadas);
  lblNumCamadas.Caption := IntToStr(NumCamadas);
  LblNeucamadas.Caption := Rede;
  SetLength(Pesos,NumCamadas);
  for I := 0 to Pred(NumCamadas) do
  begin
    PesoCamada  := Arquivo.ReadString('CAMADA'+ IntToStr(I+1),'Pesos','');
    Pesos[I]    := PesoCamada.Split(['|']);
  end;
end;
{************************************************************************
*                                                                       *
*  Fun��o LogSig                                                        *
*  Aplica a fun��o log�stica                                            *
*  x: Valor em que a fun��o ser� aplicada                               *
*  Retorno: Fun��o log�stica aplicada em x                              *
*                                                                       *
************************************************************************}
function TFrmClassifica.LogSig(x: Real): Real;
begin
  Result := 1 /(1+ exp(-x));
end;
{************************************************************************
*                                                                       *
*  Fun��o MultiplicaArray                                               *
*  Executa a multiplica��o de dois vetores                              *
*  Array1: Primeiro vetor da multiplica��o                              *
*  Array2: Segundo vetor da multiplica��o                               *
*  Retorno: Resultado da multiplica��o entre os dois vetore             *
*                                                                       *
************************************************************************}

function TFrmClassifica.MultiplicaArray(Array1, Array2: Tarray<real>): Real;
var
  Sum :Real;
  I: Integer;
begin
  Sum := 0;
  if Length(Array1) = Length(Array2) then
  begin
    for I := 0 to pred(Length(Array1)) do
    begin
      Sum := Sum + (Array1[I] * Array2[I]);
    end;
    Result := Sum;
  end
  else
  begin
    raise Exception.Create('Vetores incompat�veis');
  end;
end;
{************************************************************************
*                                                                       *
*  Fun��o Normaliza                                                     *
*  Normaliza os valores de um vetor de acordo com a m�dia               *
*  e desvio padr�o dos dados de treinamento da rede                     *
*  Dados: Vetor a ser normalizado                                       *
*  Retorno: Vetor de Float                                              *
*                                                                       *
************************************************************************}

function TFrmClassifica.Normaliza(Dados: Tarray<real>; Media,
  Desvio: Real): Tarray<real>;
var
  i: Integer;
begin
  if Desvio = 0 then
  begin
    raise Exception.Create('Desvio padr�o inv�lido');
    exit;
  end;
  for i := 0 to pred(Length(Dados)) do
  begin
    Dados[i] := Abs((Dados[i] - Media)/Desvio);
  end;
  Result := Dados;
end;

procedure TFrmClassifica.SpeedButton1Click(Sender: TObject);
var
  Arquivo:TIniFile;
begin
  if OpenDialog1.Execute then
  begin
    Arquivo := TIniFile.Create(OpenDialog1.FileName);
    ImportaRede(Arquivo);
  end;
end;
{************************************************************************
*                                                                       *
*  Fun��o StrArrayToFloatArray                                          *
*  Converte um vetor de Strings em um Vetor de Float                    *
*  AArray: Vetor a ser convertido                                       *
*  Retorno: Vetor de Float                                              *
*                                                                       *
************************************************************************}

function TFrmClassifica.StrArrayToFloatArray(AArray: Tarray<string>): Tarray<Real>;
var
  ArrayFloat : Tarray<Real>;
  I: Integer;
begin
  SetLength(ArrayFloat,Length(AArray));
  for I := 0 to pred(Length(AArray)) do
  begin
    ArrayFloat[I] := StrToFloat(AArray[I]);
  end;

  Result := ArrayFloat;
end;

end.
