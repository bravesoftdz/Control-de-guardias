unit vacaciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, DbCtrls, ExtCtrls, ZDataset, Utiles, DateUtils;

type

  { TFVacaciones }

  TFVacaciones = class(TForm)
    BConsultar: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BGuardar: TButton;
    BSalir: TButton;
    BCancelar: TButton;
    CBMesVac: TComboBox;
    CBTrabaj: TComboBox;
    CBSuplente: TComboBox;
    CBEjFiscal: TComboBox;
    DS: TDatasource;
    DEFechaIniVac: TDateEdit;
    ETotDiasVac: TEdit;
    ENombre: TEdit;
    EFechaFinVac: TEdit;
    EFecIngreso: TEdit;
    FechaReint: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MmObs: TMemo;
    ZQuery: TZQuery;
    ZQrSupl: TZQuery;
    procedure BCancelarClick(Sender: TObject);
    procedure BConsultarClick(Sender: TObject);
    procedure BGuardarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure CBEjFiscalChange(Sender: TObject);
    procedure CBMesVacChange(Sender: TObject);
    procedure CBSuplenteChange(Sender: TObject);
    procedure CBTrabajChange(Sender: TObject);
    procedure DEFechaIniVacAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure DEFechaIniVacChange(Sender: TObject);
    procedure DEFechaIniVacExit(Sender: TObject);
    procedure DEFechaIniVacKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure ValInicial;
    function DiasVacaciones(FIngreso: TDate): ShortInt;
    function FechaFinVac(FInicio: TDate; DiasV: ShortInt): TDate;
    function BotonActivable: boolean;
  public
    { public declarations }
  end; 

var
  FVacaciones: TFVacaciones;
  CodEjFiscal,Cedula: string;
  FechaIngreso: TDate;
  AnioVac,MesVac: word;


implementation

{$R *.lfm}

{ TFVacaciones }

procedure TFVacaciones.ValInicial;
begin
  CodEjFiscal:='';
  Cedula:='';
  DEFechaIniVac.Date:=Date;
  CBEjFiscal.Enabled:=true;
  CBTrabaj.Enabled:=true;
  BGuardar.Enabled:=false;
  CBMesVac.Enabled:=false;
  ENombre.Clear;
  EFecIngreso.Clear;
  ETotDiasVac.Clear;
  EFechaFinVac.Clear;
  FechaReint.Clear;
  CBSuplente.Clear;
  MmObs.Clear;
  CBEjFiscal.ItemIndex:=-1;
  CBMesVac.ItemIndex:=-1;
  CBTrabaj.ItemIndex:=-1;
  CBEjFiscal.SetFocus;
end;

function TFVacaciones.DiasVacaciones(FIngreso: TDate): ShortInt;
var
  Antiguedad,DiasVac: ShortInt;
begin
  Antiguedad:=YearsBetween(FIngreso,Date);
  if Antiguedad>4 then DiasVac:=18+Antiguedad-4
                  else DiasVac:=18;
  if DiasVac>30 then DiasVac:=30;
  Result:=DiasVac;
end;

function TFVacaciones.FechaFinVac(FInicio: TDate; DiasV: ShortInt): TDate;
var
  NumDias: ShortInt;
  FInic: TDate;
begin
  NumDias:=1;
  FInic:=FInicio;
  while NumDias<=DiasV do
  begin
    if (DayOfTheWeek(FInic)<>6) and (DayOfTheWeek(FInic)<>7) then
      NumDias:=NumDias+1;
    if NumDias<=DiasV then FInic:=IncDay(FInic,1);
  end;
  Result:=FInic;
end;

function TFVacaciones.BotonActivable: boolean;
begin
  Result:=(CBMesVac.Text<>'') and ((DEFechaIniVac.Text<>'  /  /    ') or
    (DEFechaIniVac.Text<>'')) and (CBSuplente.Text<>'');
end;

procedure TFVacaciones.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFVacaciones.CBEjFiscalChange(Sender: TObject);
begin
  BConsultar.Enabled:=(CBEjFiscal.ItemIndex>-1) and (CBTrabaj.ItemIndex>-1);
  AnioVac:=StrToInt(Copy(CBEjFiscal.Text,1,4));
  DEFechaIniVac.Date:=EncodeDate(AnioVac,1,1);
end;

procedure TFVacaciones.CBMesVacChange(Sender: TObject);
begin
  BGuardar.Enabled:=BotonActivable;
  MesVac:=CBMesVac.ItemIndex+1;
  DEFechaIniVac.Date:=EncodeDate(AnioVac,MesVac,1);
end;

procedure TFVacaciones.CBSuplenteChange(Sender: TObject);
begin
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFVacaciones.CBTrabajChange(Sender: TObject);
begin
  //BGuardar.Enabled:=BotonActivable;
  BConsultar.Enabled:=(CBEjFiscal.ItemIndex>-1) and (CBTrabaj.ItemIndex>-1);
end;

procedure TFVacaciones.DEFechaIniVacAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
  EFechaFinVac.Text:=DateToStr(FechaFinVac(ADate,DiasVacaciones(FechaIngreso)));
  FechaReint.Text:=DateToStr(StrToDate(EFechaFinVac.Text)+1);
end;

procedure TFVacaciones.DEFechaIniVacChange(Sender: TObject);
begin
  EFechaFinVac.Text:=DateToStr(FechaFinVac(DEFechaIniVac.Date,DiasVacaciones(FechaIngreso)));
  FechaReint.Text:=DateToStr(StrToDate(EFechaFinVac.Text)+1);
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFVacaciones.DEFechaIniVacExit(Sender: TObject);
begin
  EFechaFinVac.Text:=DateToStr(FechaFinVac(DEFechaIniVac.Date,DiasVacaciones(FechaIngreso)));
  FechaReint.Text:=DateToStr(StrToDate(EFechaFinVac.Text)+1);
end;

procedure TFVacaciones.DEFechaIniVacKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFVacaciones.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

procedure TFVacaciones.FormShow(Sender: TObject);
begin
  ValInicial;
  //se cargan los ejercicios fiscales:
  ZQuery.SQL.Text:='select EjFiscal from ejercfiscal';
  ZQuery.Open;
  while not ZQuery.EOF do
  begin
    CBEjFiscal.Items.Add(ZQuery['EjFiscal']);
    ZQuery.Next;
  end;
  //se cargan los trabajadores:
  ZQuery.SQL.Text:='select Concat(Cedula," - ",Apellidos,", ",Nombres) '+
    'Nombre,Cedula from personal order by Apellidos';
  ZQuery.Open;
  while not ZQuery.EOF do
  begin
    CBTrabaj.Items.Add(ZQuery['Nombre']);
    ZQuery.Next;
  end;
end;

procedure TFVacaciones.BConsultarClick(Sender: TObject);
var
  EjFiscal,Nombre: string;
begin
  BConsultar.Enabled:=false;
  CBEjFiscal.Enabled:=false;
  CBTrabaj.Enabled:=false;
  CBMesVac.Enabled:=true;
  Cedula:=ExtraeCedula(CBTrabaj.Text);
  EjFiscal:=QuotedStr(CBEjFiscal.Text);
  ZQuery.SQL.Text:='select Concat(Apellidos,", ",Nombres) Nombre,FechaIngreso '+
    'from personal where Cedula='+Cedula;
  ZQuery.Open;
  if ZQuery.RecordCount>0 then
  begin
    Nombre:=ZQuery['Nombre'];
    FechaIngreso:=StrToDate(ZQuery['FechaIngreso']);
    //se determina el código de ej fiscal:
    ZQuery.SQL.Text:='select CodEjFiscal from ejercfiscal where EjFiscal='+
      EjFiscal;
    ZQuery.Open;
    CodEjFiscal:=IntToStr(ZQuery['CodEjFiscal']);
    //se busca comprobar si ya tiene vacaciones creadas para ese período:
    ZQuery.SQL.Text:='select CodEjFiscal,Cedula from vacaciones where CodEjFiscal='+
      CodEjFiscal+' and Cedula='+Cedula;
    ZQuery.Open;
    if ZQuery.RecordCount>0 then
    begin
      ShowMessage('Ya fueron programadas las vacaciones de este trabajador '+
                  'para el ejercicio fiscal '+EjFiscal);
      ValInicial;
    end
    else
    begin
      //se cargan los suplentes:
      ZQrSupl.SQL.Text:='select Concat(Cedula," - ",Apellidos,", ",Nombres) '+
        'Nombre,Cedula from personal where Cedula<>'+Cedula+' order by Apellidos';
      ZQrSupl.Open;
      while not ZQrSupl.EOF do
      begin
        CBSuplente.Items.Add(ZQrSupl['Nombre']);
        ZQrSupl.Next;
      end;
      //el resto de los campos:
      ENombre.Text:=Nombre;
      EFecIngreso.Text:=DateToStr(FechaIngreso);
      ETotDiasVac.Text:=IntToStr(DiasVacaciones(FechaIngreso));
      CBEjFiscal.ReadOnly:=true;
      CBMesVac.SetFocus;
    end;
  end
  else
  begin
    ShowMessage('La cédula no está registrada');
    ValInicial;
  end;
end;

procedure TFVacaciones.BCancelarClick(Sender: TObject);
begin
  ValInicial;
end;

procedure TFVacaciones.BGuardarClick(Sender: TObject);
var
  MesVacacion,TotDiasVac,FecIniVac,FecFinVac,FecReintegro,CedSuplente,
  Observacion: string;
begin
  MesVacacion:=QuotedStr(CBMesVac.Text);
  TotDiasVac:=ETotDiasVac.Text;
  FecIniVac:=FormatoFechaSQL(DEFechaIniVac.Date);
  FecFinVac:=FormatoFechaSQL(StrToDate(EFechaFinVac.Text));
  FecReintegro:=FormatoFechaSQL(StrToDate(FechaReint.Text));
  CedSuplente:=ExtraeCedula(CBSuplente.Text);
  Observacion:=QuotedStr(Trim(MmObs.Text));
  ZQuery.SQL.Text:='insert into vacaciones (Cedula,CodEjFiscal,MesVacacion,'+
    'TotDiasVac,FecIniVac,FecFinVac,FecReintegro,CedSuplente,Observacion) '+
    'values ('+Cedula+','+CodEjFiscal+','+MesVacacion+','+TotDiasVac+','+
    FecIniVac+','+FecFinVac+','+FecReintegro+','+CedSuplente+','+Observacion+')';
  ZQuery.ExecSQL;
  ShowMessage('Las vacaciones se guardaron exitosamente');
  ValInicial;
end;

end.

