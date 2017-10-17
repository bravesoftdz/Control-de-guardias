unit ctrlasistvig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, EditBtn, ExtCtrls, LR_Class, LR_DBSet, ZDataset, DateUtils, Utiles;

type

  { TFCtrlAsistVig }

  TFCtrlAsistVig = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BImprimir: TButton;
    BSalir: TButton;
    BGenerar: TButton;
    DEFecha: TDateEdit;
    DBGControl: TDBGrid;
    DS: TDatasource;
    EDia: TEdit;
    ESemana: TEdit;
    frDBDataSet: TfrDBDataSet;
    frReport: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ZQuery: TZQuery;
    ZQrRep: TZQuery;
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure BGenerarClick(Sender: TObject);
    procedure DEFechaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure DEFechaExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FCtrlAsistVig: TFCtrlAsistVig;
  TxtSQLRep: string;

implementation

{$R *.lfm}

{ TFCtrlAsistVig }

procedure TFCtrlAsistVig.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCtrlAsistVig.BImprimirClick(Sender: TObject);
begin
  BImprimir.Enabled:=false;
  ZQrRep.SQL.Text:=TxtSQLRep;
  ZQrRep.Open;
  MuestraReporte(frReport,'rptasistvig.lrf');
end;

procedure TFCtrlAsistVig.BGenerarClick(Sender: TObject);
var
  MesGuardia,DiaX,Dia,Fecha,Semana: string;
begin
  BImprimir.Enabled:=true;
  MesGuardia:=QuotedStr(MesAnio(DEFecha.Date));
  DiaX:='c.Dia'+IntToStr(DayOfTheMonth(DEFecha.Date));
  Dia:=QuotedStr(EDia.Text);
  Fecha:='str_to_date('+QuotedStr(DateToStr(DEFecha.Date))+','+
    QuotedStr('%d/%m/%Y')+')';
  Semana:=QuotedStr(ESemana.Text);
  ZQuery.SQL.Text:='select p.Cedula,Concat(p.Apellidos,", ",p.Nombres) Nombre,'+
    DiaX+' Guardia, case when '+DiaX+'="D" then "6:00 AM" else "6:00 PM" end '+
    'HoraEnt,case when '+DiaX+'="D" then "6:00 PM" else "6:00 AM" end HoraSal,'+
    Dia+' Dia,'+Fecha+' Fecha,'+Semana+' Semana '+
    'from personal p,ctrolguardias c,listguardias l '+
    'where '+DiaX+'<>"" and p.Cedula=c.Cedula and l.CodGuardia=c.CodGuardia '+
    'and l.MesGuardia='+MesGuardia+' order by Nombre asc';
  TxtSQLRep:=ZQuery.SQL.Text;
  ZQuery.Open;
end;

procedure TFCtrlAsistVig.DEFechaAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
  EDia.Text:=DiaSemana(ADate);
  ESemana.Text:=IntToStr(WeekOfTheYear(ADate));
end;

procedure TFCtrlAsistVig.DEFechaExit(Sender: TObject);
begin
  EDia.Text:=DiaSemana(DEFecha.Date);
  ESemana.Text:=IntToStr(WeekOfTheYear(DEFecha.Date));
end;

procedure TFCtrlAsistVig.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

procedure TFCtrlAsistVig.FormShow(Sender: TObject);
begin
  DEFecha.Date:=Date;
  DEFecha.SetFocus;
  ZQuery.Open;
end;

end.

