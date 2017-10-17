unit relcontrcol;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, DBGrids, ExtCtrls, LR_Class, LR_DBSet, ZDataset, Utiles, DateUtils, db;

type

  { TFRelContrCol }

  TFRelContrCol = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BImprimir: TButton;
    BSalir: TButton;
    BConsultar: TButton;
    CBMes: TComboBox;
    DS: TDatasource;
    DBGRel: TDBGrid;
    frDBDSet: TfrDBDataSet;
    frRpt: TfrReport;
    Label1: TLabel;
    Label3: TLabel;
    SEAnio: TSpinEdit;
    ZQuery: TZQuery;
    ZQrConf: TZQuery;
    procedure BConsultarKeyPress(Sender: TObject; var Key: char);
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure BConsultarClick(Sender: TObject);
    procedure CBMesKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure SEAnioKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
    procedure Enter2Tab(var Key: char);
  public
    { public declarations }
  end; 

var
  FRelContrCol: TFRelContrCol;

implementation

{$R *.lfm}

{ TFRelContrCol }

procedure TFRelContrCol.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end;
end;

procedure TFRelContrCol.FormShow(Sender: TObject);
begin
  BImprimir.Enabled:=false;
  SEAnio.Value:=AnioDe(Date);
  CBMes.ItemIndex:=MonthOfTheYear(Date)-1;
end;

procedure TFRelContrCol.SEAnioKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFRelContrCol.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFRelContrCol.BConsultarClick(Sender: TObject);
var
  Fecha: TDate;
  MesGuardia: string;
begin
  Fecha:=EncodeDate(SEAnio.Value,CBMes.ItemIndex+1,1);
  MesGuardia:=QuotedStr(MesAnio(Fecha));
  ZQuery.SQL.Text:='select p.Cedula,Concat(p.Apellidos,", ",p.Nombres) Nombre,'+
    'g.TotGuardDiur,g.TotGuardNoct,g.TotGuardDyN,g.TotHorasLab,g.TotHorasMes,'+
    'g.Excedente,g.TotGuardXPagar,g.Feriado,g.Observacion,l.MesGuardia from '+
    'personal p,guardias g, listguardias l where l.CodGuardia=g.CodGuardia and '+
    'p.Cedula=g.Cedula and l.MesGuardia='+MesGuardia+' order by Nombre asc';
  ZQuery.Open;
  BImprimir.Enabled:=true;
end;

procedure TFRelContrCol.CBMesKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFRelContrCol.FormKeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TFRelContrCol.BImprimirClick(Sender: TObject);
begin
  ZQrConf.SQL.Text:='select NomAnalista from configuracion';
  ZQrConf.Open;
  MuestraReporte(frRpt,'rprelcontrcolect.lrf');
end;

procedure TFRelContrCol.BConsultarKeyPress(Sender: TObject; var Key: char);
begin
  BConsultarClick(Self);
  Enter2Tab(Key);
end;

end.

