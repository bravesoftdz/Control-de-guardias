unit Utiles;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, Controls, DateUtils, SysUtils, ZDataset, LR_Class;

const
  //NombreSistema='Sistema de Control de Extrasalarios';
  NombreSistema='Sistema Automatizado de Contratación Colectiva (Guardias)';

var
  UsuarioActivo,RangoActivo,ContrActiva: string;

  procedure MostrarVentana(AClass: TFormClass);
  //procedure Enter2Tab(var Tecla: char);
  function EliminaEspacio(Cadena: string): string;
  function DiaSemana(Fecha: TDate): string;
  function MesAnio(Fecha: TDate): string;
  function AnioDe(Fecha: TDate): word;
  function FormatoFechaSQL(Fecha: TDate): string;
  procedure RegActividad(ZQr: TZQuery; Usuario,Valor,Caso: string);
  function ExtraeCedula(Cadena: string): string;
  function DiasHabilesDelMes(Anio,Mes: word): ShortInt;
  procedure MuestraReporte(frReporte: TfrReport; Reporte: string);

implementation

procedure MostrarVentana(AClass: TFormClass);
begin
  with AClass.Create(Application) do
    try ShowModal
    finally Free
    end;
end;
     {
procedure Enter2Tab(var Tecla: char);
begin
  if Tecla=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Tecla:=#0
  end
end;}

{Elimina todos los espacios en una cadena}
function EliminaEspacio(Cadena: string): string;
begin
  while Pos(' ',Cadena)>0 do Delete(Cadena,Pos(' ',Cadena),1);
  Result:=Cadena;
end;

{Devuelve el día de la semana dada una fecha}
function DiaSemana(Fecha: TDate): string;
var
  Dia: array[1..7] of string=('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES',
                              'SABADO','DOMINGO');
begin
  Result:=Dia[DayOfTheWeek(Fecha)];
end;

{Devuelve una cadena del mes y el año dada una fecha}
function MesAnio(Fecha: TDate): string;
var
  Anio,Mes,Dia: word;
  vMes: array[1..12] of string=('ENE','FEB','MAR','ABR','MAY','JUN',
                                'JUL','AGO','SEP','OCT','NOV','DIC');
begin
  DecodeDate(Fecha,Anio,Mes,Dia);
  Result:=vMes[Mes]+'-'+IntToStr(Anio);
end;

{Devuelve el año dada una fecha}
function AnioDe(Fecha: TDate): word;
var
  Anio,Mes,Dia: word;
begin
  DecodeDate(Fecha,Anio,Mes,Dia);
  Result:=Anio;
end;

{Devuelve una cadena con formato de fecha listo para guardar en BD MySQL}
function FormatoFechaSQL(Fecha: TDate): string;
begin
  Result:='str_to_date('+QuotedStr(DateToStr(Fecha))+','+QuotedStr('%d/%m/%Y')+')';
end;

{se invoca el proc. almacenado RegActividad}
procedure RegActividad(ZQr: TZQuery; Usuario,Valor,Caso: string);
begin
  ZQr.SQL.Text:='call RegActividad('+Usuario+','+Valor+','+Caso+')';
  ZQr.ExecSQL;
end;

{Extrae la cédula de una cadena dada}
function ExtraeCedula(Cadena: string): string;
var
  I: ShortInt;
  Cad: string;
begin
  I:=1;  Cad:='';
  while Copy(Cadena,I,1)<>' '  do
  begin
    Cad:=Cad+Copy(Cadena,I,1);
    I:=I+1;
  end;
  Result:=Cad;
end;

function DiasHabilesDelMes(Anio,Mes: word): ShortInt;
var
  I,NumDias: ShortInt;
begin
  NumDias:=0;
  for I:=1 to DaysInAMonth(Anio,Mes) do
    if DayOfTheWeek(EncodeDate(Anio,Mes,I))<6 then NumDias:=NumDias+1;
  Result:=NumDias;
end;

{Muestra un reporte (LazReport)}
procedure MuestraReporte(frReporte: TfrReport; Reporte: string);
begin
  if FileExists(Reporte) then
  begin
    frReporte.LoadFromFile(Reporte);
    frReporte.ShowReport;
  end
  else ShowMessage('El archivo de reporte no fue encontrado');
end;

end.
