unit zonas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, ComCtrls, ExtCtrls, DbCtrls, ZDataset;

type

  { TFZonas }

  TFZonas = class(TForm)
    BAgregStatus: TButton;
    BAgregZona1: TButton;
    BSalir: TButton;
    BAgregCargo: TButton;
    BAgregZona: TButton;
    DBGStatus: TDBGrid;
    DBGZonas1: TDBGrid;
    DS: TDatasource;
    DBGCargos: TDBGrid;
    DBGZonas: TDBGrid;
    ECargo: TEdit;
    EStatus: TEdit;
    EZona: TEdit;
    EZona1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PC1: TPageControl;
    TSStatus: TTabSheet;
    TSCargos: TTabSheet;
    TSZonas: TTabSheet;
    TSZonas1: TTabSheet;
    ZQuery: TZQuery;
    procedure BAgregCargoClick(Sender: TObject);
    procedure BAgregStatusClick(Sender: TObject);
    procedure BAgregZonaClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure ECargoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EStatusKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EZonaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure PC1Change(Sender: TObject);
  private
    { private declarations }
    procedure ValInicial;
  public
    { public declarations }
  end; 

var
  FZonas: TFZonas;

implementation

{$R *.lfm}

{ TFZonas }

procedure TFZonas.ValInicial;
var
  TxtSQL: string;
begin
  ECargo.Clear;
  EZona.Clear;
  BAgregCargo.Enabled:=false;
  BAgregStatus.Enabled:=false;
  BAgregZona.Enabled:=false;
  case PC1.TabIndex of
    0: begin
         ECargo.SetFocus;
         TxtSQL:='select DescrCargo from Cargo order by DescrCargo asc';
       end;
    1: begin
         EStatus.SetFocus;
         TxtSQL:='select DescrStatus from Status order by DescrStatus asc';
       end;
    2: begin
         EZona.SetFocus;
         TxtSQL:='select DescrZona from Zona order by DescrZona asc';
       end;
  end;
  ZQuery.SQL.Text:=TxtSQL;
  ZQuery.Open;
end;

procedure TFZonas.BSalirClick(Sender: TObject);
begin
  ZQuery.Active:=false;
  Close;
end;

procedure TFZonas.ECargoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  BAgregCargo.Enabled:=Trim(ECargo.Text)<>'';
end;

procedure TFZonas.EStatusKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BAgregStatus.Enabled:=Trim(EStatus.Text)<>'';
end;

procedure TFZonas.EZonaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  BAgregZona.Enabled:=Trim(EZona.Text)<>'';
end;

procedure TFZonas.FormShow(Sender: TObject);
begin
  ValInicial;
  ZQuery.Active:=true;
end;

procedure TFZonas.PC1Change(Sender: TObject);
begin
  ValInicial;
end;

procedure TFZonas.BAgregCargoClick(Sender: TObject);
begin
  ZQuery.SQL.Text:='select * from Cargo where DescrCargo='+QuotedStr(ECargo.Text);
  ZQuery.Open;
  if ZQuery.RecordCount>0 then ShowMessage('El cargo ya está registrado')
  else
  begin
    ZQuery.SQL.Text:='insert into Cargo (DescrCargo) values ('+
                     QuotedStr(ECargo.Text)+')';
    ZQuery.ExecSQL;
    ShowMessage('El cargo fue guardado exitosamente');
  end;
  ValInicial;
end;

procedure TFZonas.BAgregStatusClick(Sender: TObject);
begin
  ZQuery.SQL.Text:='select * from Status where DescrStatus='+
                   QuotedStr(EStatus.Text);
  ZQuery.Open;
  if ZQuery.RecordCount>0 then ShowMessage('La zona ya está registrada')
  else
  begin
    ZQuery.SQL.Text:='insert into Status (DescrStatus) values ('+
                     QuotedStr(EStatus.Text)+')';
    ZQuery.ExecSQL;
    ShowMessage('El status fue guardado exitosamente');
  end;
  ValInicial;
end;

procedure TFZonas.BAgregZonaClick(Sender: TObject);
begin
  ZQuery.SQL.Text:='select * from Zona where DescrZona='+QuotedStr(EZona.Text);
  ZQuery.Open;
  if ZQuery.RecordCount>0 then ShowMessage('La zona ya está registrada')
  else
  begin
    ZQuery.SQL.Text:='insert into Zona (DescrZona) values ('+
                     QuotedStr(EZona.Text)+')';
    ZQuery.ExecSQL;
    ShowMessage('La zona fue guardada exitosamente');
  end;
  ValInicial;
end;

end.

