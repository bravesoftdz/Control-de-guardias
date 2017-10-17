unit contrguardias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Grids, Menus, ExtCtrls, ZDataset, DateUtils, Utiles;

type

  { TFContrGuardias }

  TFContrGuardias = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BSalir: TButton;
    BCrear: TButton;
    CBMes: TComboBox;
    CBGuardia: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PMILimpiarTodo: TMenuItem;
    PMIDiurna: TMenuItem;
    PMIMixta: TMenuItem;
    MenuItem3: TMenuItem;
    PMILimpiaLinea: TMenuItem;
    PMINocturna: TMenuItem;
    MmObs: TMemo;
    PMenu: TPopupMenu;
    SEAnio: TSpinEdit;
    SGGuardias: TStringGrid;
    ZQuery: TZQuery;
    ZQrTEx: TZQuery;
    ZQrTmp: TZQuery;
    ZQueryX: TZQuery;
    procedure BSalirClick(Sender: TObject);
    procedure BCrearClick(Sender: TObject);
    procedure CBMesChange(Sender: TObject);
    procedure CBGuardiaChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure PMILimpiarTodoClick(Sender: TObject);
    procedure PMIDiurnaClick(Sender: TObject);
    procedure PMILimpiaLineaClick(Sender: TObject);
    procedure PMIMixtaClick(Sender: TObject);
    procedure PMINocturnaClick(Sender: TObject);
    procedure SEAnioChange(Sender: TObject);
    procedure SGGuardiasClick(Sender: TObject);
  private
    { private declarations }
    procedure ValInicial;
    procedure GeneraListadoMes(Anio,Mes: integer);
    procedure LimpiaFilaCompleta(Fila: integer);
    procedure LimpiarTodo;
    procedure IntervGuardia(Opcion: integer);
    function  ActivaBoton: boolean;
    procedure ActivaPMenu(Opcion: boolean);
  public
    { public declarations }
  end; 

var
  FContrGuardias: TFContrGuardias;
  NumDias: integer;

implementation

{$R *.lfm}

{ TFContrGuardias }

procedure TFContrGuardias.ValInicial;
begin
  LimpiarTodo;
  MmObs.Clear;
  ActivaPMenu(false);
  BCrear.Enabled:=false;
  SEAnio.Value:=AnioDe(Date);
  CBMes.ItemIndex:=MonthOfTheYear(Date)-1;
  GeneraListadoMes(SEAnio.Value,MonthOfTheYear(Date));
end;

{pone la 1ra letra del día y la fecha de todo el mes en el título del stringgrid}
procedure TFContrGuardias.GeneraListadoMes(Anio,Mes: integer);
var
  I: ShortInt;
  Dia: array[1..7] of string=('L','M','M','J','V','S','D');
  Fecha: TDate;
begin
  NumDias:=DaysInAMonth(Anio,Mes);
  for I:=1 to SGGuardias.ColCount-2 do
  begin
    if I<=NumDias then
    begin
      Fecha:=EncodeDate(Anio,Mes,I);
      SGGuardias.Columns.Items[I].Title.Caption:=Dia[DayOfTheWeek(Fecha)]+
        '-'+IntToStr(I);
    end
    else SGGuardias.Columns.Items[I].Title.Caption:='---';
  end;
end;

{limpia una fila completa del stringgrid, salvo la 1ra columna}
procedure TFContrGuardias.LimpiaFilaCompleta(Fila: integer);
var
  I: ShortInt;
begin
  for I:=1 to 31 do SGGuardias.Cells[I+1,Fila]:='';
end;

{limpia todo el stringgrid, salvo la 1ra columna}
procedure TFContrGuardias.LimpiarTodo;
var
  I,J: Shortint;
begin
  for I:=0 to SGGuardias.RowCount-1 do
    for J:=1 to 31 do LimpiaFilaCompleta(I);
end;

procedure TFContrGuardias.IntervGuardia(Opcion: integer);
var
  I,Intervalo,NumCol: integer;
  Letra: char;
begin
  NumCol:=SGGuardias.SelectedColumn.Index;
  I:=NumCol;  Intervalo:=0;
  case Opcion of
    0,2: Letra:='D';
    1: Letra:='N';
  end;
  while I<=NumDias do
  begin
    Intervalo:=Intervalo+1;
    if Intervalo<5 then SGGuardias.Cells[I+1,SGGuardias.Row]:=Letra
    else
      if Intervalo>7 then
      begin
        Intervalo:=0;
        if Opcion=2 then
          if Letra='D' then Letra:='N'
                       else Letra:='D'
      end;
    I:=I+1;
  end;
  if NumCol>5 then
  begin
    I:=NumCol;  Intervalo:=9;
    if Opcion=2 then Letra:='N';
    while I>1 do
    begin
      Intervalo:=Intervalo-1;
      if Intervalo<5 then SGGuardias.Cells[I,SGGuardias.Row]:=Letra;
      if Intervalo<2 then
      begin
        Intervalo:=9;
        if Opcion=2 then
          if Letra='D' then Letra:='N'
                       else Letra:='D'
      end;
      I:=I-1;
    end;
  end;
end;

function TFContrGuardias.ActivaBoton: boolean;
var
  I,J: integer;
  Existe: boolean;
begin
  Existe:=false;
  for I:=1 to SGGuardias.RowCount do
    for J:=1 to 31 do
      if not Existe then Existe:=SGGuardias.Cells[J+1,I-1]<>'';
  Result:=Existe;
end;

procedure TFContrGuardias.ActivaPMenu(Opcion: boolean);
begin
  CBGuardia.Enabled:=Opcion;
  PMIDiurna.Enabled:=Opcion;
  PMINocturna.Enabled:=Opcion;
  PMIMixta.Enabled:=Opcion;
  PMILimpiaLinea.Enabled:=Opcion;
  PMILimpiarTodo.Enabled:=Opcion;
end;

procedure TFContrGuardias.FormShow(Sender: TObject);
var
  Fila: ShortInt;
begin
  ZQuery.Open;
  Fila:=1;
  while not ZQuery.EOF do
  begin
    SGGuardias.RowCount:=SGGuardias.RowCount+1;
    SGGuardias.Cells[1,Fila]:=ZQuery['NomCompl'];
    Fila:=Fila+1;
    ZQuery.Next;
  end;
  ValInicial;
end;

procedure TFContrGuardias.PMILimpiarTodoClick(Sender: TObject);
begin
  LimpiarTodo;
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.PMIDiurnaClick(Sender: TObject);
begin
  IntervGuardia(0);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.PMILimpiaLineaClick(Sender: TObject);
begin
  LimpiaFilaCompleta(SGGuardias.Row);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.PMIMixtaClick(Sender: TObject);
begin
  IntervGuardia(2);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.PMINocturnaClick(Sender: TObject);
begin
  IntervGuardia(1);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.SEAnioChange(Sender: TObject);
begin
  GeneraListadoMes(SEAnio.Value,CBMes.ItemIndex+1);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.SGGuardiasClick(Sender: TObject);
begin
  ActivaPMenu(SGGuardias.Col>1);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFContrGuardias.BCrearClick(Sender: TObject);
var
  D: array [1..31] of string;
  I,J,DiasHab: ShortInt;
  CodG: integer;
  Cedula,CodGuardia,MesGuardia,Observacion,Dias,Dias1,DiaLetras,DiaNumeros,
  HoraExEntrada,HoraExSalida,Observ,TotGuardDiur,TotGuardNoct,TotGuardDyN,
  TotHorasLab,TotHorasMes,Excedente,TotGuardXPagar,Feriado,Cad,Obs: string;
begin
  DecimalSeparator:='.';
  DiasHab:=DiasHabilesDelMes(SEAnio.Value,CBMes.ItemIndex+1);
  MesGuardia:=QuotedStr(Copy(CBMes.Text,1,3)+'-'+IntToStr(SEAnio.Value));
  ZQueryX.SQL.Text:='select MesGuardia from listguardias where MesGuardia='+
    MesGuardia;
  ZQueryX.Open;
  if ZQueryX.RecordCount=0 then
  begin
    Observacion:=QuotedStr(Trim(MmObs.Text));
    ZQueryX.SQL.Text:='insert into listguardias (MesGuardia,Observacion) '+
      'values ('+MesGuardia+','+Observacion+')';
    ZQueryX.ExecSQL;
    ZQueryX.SQL.Text:='select CodGuardia from listguardias where MesGuardia='+
      MesGuardia;
    ZQueryX.Open;
    CodG:=ZQueryX['CodGuardia'];
    ZQuery.First;
    for I:=1 to ZQuery.RecordCount do
    begin
      Cedula:=QuotedStr(ZQuery['Cedula']);
      CodGuardia:=IntToStr(CodG);
      Dias:='';  Dias1:='';
      for J:=1 to 31 do D[J]:=QuotedStr(SGGuardias.Cells[J+1,I]);
      //se crea la cadena 'Dia1,Dia2...Dia31' para construir la sentencia SQL:
      for J:=1 to 31 do Dias:=Dias+',Dia'+IntToStr(J);
      //se crea la cadena con los valores a guardar en la tabla:
      for J:=1 to 31 do Dias1:=Dias1+','+D[J];
      ZQueryX.SQL.Text:='insert into ctrolguardias (Cedula,CodGuardia'+Dias+') '+
        'values ('+Cedula+','+CodGuardia+Dias1+')';
      ZQueryX.ExecSQL;
      //se guardan los datos en tabla detalletmpoextra:
      Observ:=QuotedStr('Guardias x 12 horas');
      for J:=1 to 31 do
      begin
        if D[J]<>QuotedStr('') then
        begin
          DiaLetras:=QuotedStr(Copy(SGGuardias.Columns.Items[J].Title.Caption,1,1));
          DiaNumeros:=IntToStr(J);
          if D[J]=QuotedStr('D') then
          begin
            HoraExEntrada:=QuotedStr('06:00 AM');
            HoraExSalida:=QuotedStr('06:00 PM');
          end
          else
          begin
            HoraExEntrada:=QuotedStr('06:00 PM');
            HoraExSalida:=QuotedStr('06:00 AM');
          end;
          ZQrTEx.SQL.Text:='insert into detalletmpoextra (CodGuardia,Cedula,DiaLetras,'+
            'DiaNumeros,HoraExEntrada,HoraExSalida,Observacion) values ('+CodGuardia+
            ','+Cedula+','+DiaLetras+','+DiaNumeros+','+HoraExEntrada+','+
            HoraExSalida+','+Observ+')';
          ZQrTEx.ExecSQL;
        end
      end;
      //se guardan los datos en tabla guardias:
      Cad:='select count(*) Valor from detalletmpoextra where CodGuardia='+
        CodGuardia+' and Cedula='+Cedula+' and HoraExEntrada=';
      ZQrTmp.SQL.Text:=Cad+QuotedStr('06:00 AM');
      ZQrTmp.Open;
      TotGuardDiur:=IntToStr(ZQrTmp['Valor']);
      ZQrTmp.SQL.Text:=Cad+QuotedStr('06:00 PM');
      ZQrTmp.Open;
      TotGuardNoct:=IntToStr(ZQrTmp['Valor']);
      TotGuardDyN:=IntToStr(StrToInt(TotGuardDiur)+StrToInt(TotGuardNoct));
      TotHorasLab:=IntToStr(StrToInt(TotGuardDyN)*12);
      TotHorasMes:=IntToStr(DiasHab*8);
      Excedente:=IntToStr(StrToInt(TotHorasLab)-StrToInt(TotHorasMes));
      TotGuardXPagar:=FloatToStr(StrToInt(Excedente)/8);
      Feriado:='0';
      Obs:=QuotedStr('');
      ZQueryX.SQL.Text:='insert into guardias (Cedula,TotGuardDiur,TotGuardNoct,'+
        'TotGuardDyN,TotHorasLab,TotHorasMes,Excedente,TotGuardXPagar,Feriado,'+
        'Observacion,CodGuardia) values ('+Cedula+','+TotGuardDiur+
        ','+TotGuardNoct+','+TotGuardDyN+','+TotHorasLab+','+TotHorasMes+','+
        Excedente+','+TotGuardXPagar+','+Feriado+','+Obs+','+CodGuardia+')';
      ZQueryX.ExecSQL;
      ZQuery.Next;
    end;
    //se invoca el proc. almacenado RegActividad:
    RegActividad(ZQrTmp,QuotedStr(UsuarioActivo),MesGuardia,'3');
    ShowMessage('La guardia se creó satisfactoriamente');
    LimpiarTodo;
  end
  else ShowMessage('La guardia para el mes '+MesGuardia+' ya existe');
  ValInicial;
  DecimalSeparator:=',';
end;

procedure TFContrGuardias.CBMesChange(Sender: TObject);
begin
  GeneraListadoMes(SEAnio.Value,CBMes.ItemIndex+1);
  BCrear.Enabled:=ActivaBoton;
end;

procedure TFContrGuardias.CBGuardiaChange(Sender: TObject);
begin
  LimpiaFilaCompleta(SGGuardias.Row);
  IntervGuardia(CBGuardia.ItemIndex);
end;

procedure TFContrGuardias.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

end.

