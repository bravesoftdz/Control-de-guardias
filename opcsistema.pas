unit opcsistema;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ZDataset;

type

  { TFOpcSistema }

  TFOpcSistema = class(TForm)
    Bevel1: TBevel;
    BGuardar: TButton;
    BSalir: TButton;
    ENomAnalista: TEdit;
    ENomCooPers: TEdit;
    ENomSupVig: TEdit;
    ENomDirGen: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    ZQuery: TZQuery;
    procedure BGuardarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure ENomAnalistaExit(Sender: TObject);
    procedure ENomCooPersExit(Sender: TObject);
    procedure ENomDirGenExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FOpcSistema: TFOpcSistema;
  HayRegistro: boolean;

implementation

{$R *.lfm}

{ TFOpcSistema }

procedure TFOpcSistema.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFOpcSistema.ENomAnalistaExit(Sender: TObject);
begin
  ENomAnalista.Text:=Trim(ENomAnalista.Text);
end;

procedure TFOpcSistema.ENomCooPersExit(Sender: TObject);
begin
  ENomCooPers.Text:=Trim(ENomCooPers.Text);
end;

procedure TFOpcSistema.ENomDirGenExit(Sender: TObject);
begin
  ENomDirGen.Text:=Trim(ENomDirGen.Text);
end;

procedure TFOpcSistema.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

procedure TFOpcSistema.FormShow(Sender: TObject);
begin
  ZQuery.SQL.Text:='select * from configuracion';
  ZQuery.Open;
  HayRegistro:=ZQuery.RecordCount>0;
  if HayRegistro then
  begin
    ENomAnalista.Text:=ZQuery['NomAnalista'];
    ENomCooPers.Text:=ZQuery['NomCoordPers'];
    ENomSupVig.Text:=ZQuery['NomSupVigilante'];
    ENomDirGen.Text:=ZQuery['NomDirecGeneral'];
  end;
  ENomAnalista.SetFocus;
end;

procedure TFOpcSistema.BGuardarClick(Sender: TObject);
var
  TxtSQL: string;
begin
  if HayRegistro then
    TxtSQL:='update configuracion set '+
      'NomAnalista='+QuotedStr(ENomAnalista.Text)+','+
      'NomCoordPers='+QuotedStr(ENomCooPers.Text)+','+
      'NomSupVigilante='+QuotedStr(ENomSupVig.Text)+','+
      'NomDirecGeneral='+QuotedStr(ENomDirGen.Text)
  else
    TxtSQL:='insert into configuracion (NomAnalista,NomCoordPers,'+
      'NomSupVigilante,NomDirecGeneral,TitRepVacacion,TitRepSupVac,DepAdmin) '+
      'values ('+QuotedStr(ENomAnalista.Text)+','+QuotedStr(ENomCooPers.Text)+
      ','+QuotedStr(ENomSupVig.Text)+','+QuotedStr(ENomDirGen.Text);
  ZQuery.SQL.Text:=TxtSQL;
  ZQuery.ExecSQL;
  ShowMessage('Los cambios fueron guardados.');
end;

end.

