unit listpersonal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ComCtrls, ExtCtrls, LR_Class, LR_DBSet, ZDataset, Utiles;

type

  { TFListPersonal }

  TFListPersonal = class(TForm)
    Bevel1: TBevel;
    BImprimir: TButton;
    BSalir: TButton;
    DS: TDatasource;
    DBGPersonal: TDBGrid;
    frDBDSet: TfrDBDataSet;
    frRep: TfrReport;
    SBar: TStatusBar;
    ZQuery: TZQuery;
    ZQrConf: TZQuery;
    ZQueryCedula: TStringField;
    ZQueryDescrCargo: TStringField;
    ZQueryDescrStatus: TStringField;
    ZQueryDescrZona: TStringField;
    ZQueryFechaIngreso: TDateField;
    ZQueryNomCompl: TStringField;
    ZQueryPersFijo: TStringField;
    ZQuerySalarioDia: TFloatField;
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FListPersonal: TFListPersonal;

implementation

{$R *.lfm}

{ TFListPersonal }

procedure TFListPersonal.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFListPersonal.BImprimirClick(Sender: TObject);
begin
  ZQrConf.SQL.Text:='select NomAnalista from configuracion';
  ZQrConf.Open;
  MuestraReporte(frRep,'rplistpersonal.lrf');
end;

procedure TFListPersonal.FormShow(Sender: TObject);
begin
  ZQuery.Open;
  SBar.Panels[0].Text:=' Total de trabajadores: '+IntToStr(Zquery.RecordCount);
end;



end.

