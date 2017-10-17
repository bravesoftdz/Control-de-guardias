unit acerca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Utiles;

type

  { TFAcerca }

  TFAcerca = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BSalir: TButton;
    Image1: TImage;
    LNomSist: TLabel;
    Label2: TLabel;
    L1: TLabel;
    L2: TLabel;
    L3: TLabel;
    L4: TLabel;
    L5: TLabel;
    L6: TLabel;
    Label9: TLabel;
    Timer1: TTimer;
    procedure BSalirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FAcerca: TFAcerca;
  X: ShortInt;

implementation

{$R *.lfm}

{ TFAcerca }

procedure TFAcerca.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFAcerca.FormShow(Sender: TObject);
begin
  LNomSist.Caption:=NombreSistema;
  X:=1;
end;

procedure TFAcerca.Timer1Timer(Sender: TObject);
begin
  case X of
    1: begin
         L6.Font.Color:=clDefault;
         L1.Font.Color:=clBlue;
       end;
    2: begin
         L1.Font.Color:=clDefault;
         L2.Font.Color:=clBlue;
       end;
    3: begin
         L2.Font.Color:=clDefault;
         L3.Font.Color:=clBlue;
       end;
    4: begin
         L3.Font.Color:=clDefault;
         L4.Font.Color:=clBlue;
       end;
    5: begin
         L4.Font.Color:=clDefault;
         L5.Font.Color:=clBlue;
       end;
    6: begin
         L5.Font.Color:=clDefault;
         L6.Font.Color:=clBlue;
       end;
  end;
  if X=6 then X:=1
         else X:=X+1;
end;

end.

