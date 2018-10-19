program Classificador;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {FrmClassifica},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmClassifica, FrmClassifica);
  Application.Run;
end.
