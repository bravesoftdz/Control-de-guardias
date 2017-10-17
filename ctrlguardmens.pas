unit ctrlguardmens;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls, ExtCtrls, LR_Class, LR_DBSet, ZDataset, DateUtils, Utiles;

type

  { TFCtrlGuardMens }

  TFCtrlGuardMens = class(TForm)
    Bevel1: TBevel;
    BSalir: TButton;
    BImprimir: TButton;
    CBMes: TComboBox;
    frDBDSet: TfrDBDataSet;
    frRpt: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    SEAnio: TSpinEdit;
    ZQuery: TZQuery;
    ZQrTmp: TZQuery;
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure CBMesKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure SEAnioKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
    procedure Enter2Tab(var Key: char);
    function ListadoDiasDelMes(Anio,Mes: integer): string;
  public
    { public declarations }
  end; 

var
  FCtrlGuardMens: TFCtrlGuardMens;

implementation

{$R *.lfm}

{ TFCtrlGuardMens }

procedure TFCtrlGuardMens.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end;
end;

function TFCtrlGuardMens.ListadoDiasDelMes(Anio,Mes: integer): string;
var
  I,NumDias: ShortInt;
  Dia: array[1..7] of string=('L','M','M','J','V','S','D');
  Fecha: TDate;
  Cadena: string;
begin
  NumDias:=DaysInAMonth(Anio,Mes);
  Cadena:='';
  for I:=1 to 31 do
  begin
    if I<=NumDias then
    begin
      Fecha:=EncodeDate(Anio,Mes,I);
      if I=1 then
        Cadena:=QuotedStr(Dia[DayOfTheWeek(Fecha)])+' DS'+IntToStr(I)
      else
        Cadena:=Cadena+','+QuotedStr(Dia[DayOfTheWeek(Fecha)])+' DS'+IntToStr(I);
    end
    else Cadena:=Cadena+','+QuotedStr('X')+' DS'+IntToStr(I);
  end;
  Result:=Cadena;
end;

procedure TFCtrlGuardMens.BImprimirClick(Sender: TObject);
var
  Fecha: TDate;
  MesGuardia,Dias: string;
  I: ShortInt;
begin
  Fecha:=EncodeDate(SEAnio.Value,CBMes.ItemIndex+1,1);
  MesGuardia:=QuotedStr(MesAnio(Fecha));
  //se generan las primeras letras de los días del encabezado:
  ZQrTmp.SQL.Text:='select '+ListadoDiasDelMes(SEAnio.Value,CBMes.ItemIndex+1);
  ZQrTmp.Open;
  Dias:='';
  //se generan los nombres de los campos desde el día 1 al 31:
  for I:=1 to 31 do Dias:=Dias+',Dia'+IntToStr(I);
  //se crea la sentencia:
  ZQuery.SQL.Text:='select l.MesGuardia,@NCol:=@NCol+1 NCol,Concat(p.Apellidos,'+
    '", ",p.Nombres) Nombre'+Dias+' from (select @NCol:=0) as n,personal p,'+
    'listguardias l,ctrolguardias c where p.Cedula=c.Cedula and l.CodGuardia='+
    'c.CodGuardia and l.MesGuardia='+MesGuardia+' order by Nombre';
  ZQuery.Open;
  //se muestra el reporte:
  MuestraReporte(frRpt,'rpctrlguardmens.lrf');
end;

procedure TFCtrlGuardMens.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCtrlGuardMens.CBMesKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFCtrlGuardMens.FormShow(Sender: TObject);
begin
  SEAnio.Value:=AnioDe(Date);
  CBMes.ItemIndex:=MonthOfTheYear(Date)-1;
end;

procedure TFCtrlGuardMens.SEAnioKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

end.

