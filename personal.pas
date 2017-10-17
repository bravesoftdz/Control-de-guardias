unit personal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  MaskEdit, EditBtn, ExtCtrls, ZDataset, ZStoredProcedure, Utiles;

type

  { TFPersonal }

  TFPersonal = class(TForm)
    BConsultar: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BSalir: TButton;
    BGuardar: TButton;
    CBStatus: TComboBox;
    ChBEsFijo: TCheckBox;
    CBCargo: TComboBox;
    CBZona: TComboBox;
    DEFecIngreso: TDateEdit;
    EApellidos: TEdit;
    ENombres: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MECedula: TMaskEdit;
    MESalDiario: TMaskEdit;
    ZQuery: TZQuery;
    ZQCargo: TZQuery;
    ZQZona: TZQuery;
    ZQStatus: TZQuery;
    procedure BConsultarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure BGuardarClick(Sender: TObject);
    procedure DEFecIngresoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EApellidosKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ENombresKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure MECedulaExit(Sender: TObject);
    procedure MESalDiarioExit(Sender: TObject);
    procedure MESalDiarioKeyPress(Sender: TObject; var Key: char);
    procedure MESalDiarioKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
    procedure ValInicial;
    procedure ActivaControles(Opcion,Opcion2: boolean);
    procedure MostrarDatos;
    function  BotonActivable: boolean;
    function  CodigoCargo(Cargo: string): integer;
    function  CodigoZona(Zona: string): integer;
  public
    { public declarations }
  end; 

var
  FPersonal: TFPersonal;

implementation

{uses
  datamod;}

{$R *.lfm}

{ TFPersonal }

procedure TFPersonal.ValInicial;
begin
  MECedula.Clear;
  EApellidos.Clear;
  ENombres.Clear;
  DEFecIngreso.Clear;
  CBCargo.ItemIndex:=-1;
  CBStatus.ItemIndex:=-1;
  CBZona.ItemIndex:=-1;
  MESalDiario.Clear;
  ChBEsFijo.Checked:=false;
  BGuardar.Enabled:=false;
  BGuardar.Caption:='Guardar datos';
  MECedula.SetFocus;
end;

procedure TFPersonal.ActivaControles(Opcion,Opcion2: boolean);
begin
  EApellidos.ReadOnly:=Opcion;
  ENombres.ReadOnly:=Opcion;
  DEFecIngreso.ReadOnly:=Opcion;
  CBCargo.Enabled:=not Opcion2;
  CBStatus.Enabled:=not Opcion2;
  CBZona.Enabled:=not Opcion2;
  MESalDiario.ReadOnly:=Opcion2;
  MECedula.Enabled:=Opcion2;
  //ChBEsFijo.Enabled:=Opcion;
  BConsultar.Enabled:=Opcion;
  if not Opcion then BSalir.Caption:='Cancelar'
                else BSalir.Caption:='Salir';
end;

procedure TFPersonal.MostrarDatos;
begin
  ZQuery.SQL.Text:='select pr.Cedula,pr.Apellidos,pr.Nombres,pr.FechaIngreso,'+
    'cg.DescrCargo,pr.PersFijo,zn.DescrZona,SalarioDia,st.DescrStatus '+
    'from personal pr,cargo cg,zona zn,status st where pr.CodCargo='+
    'cg.CodCargo and pr.CodZona=zn.CodZona and pr.CodStatus=st.CodStatus and '+
    'pr.Cedula='+QuotedStr(MECedula.Text);
  ZQuery.Open;
  EApellidos.Text:=ZQuery['Apellidos'];
  ENombres.Text:=ZQuery['Nombres'];
  DEFecIngreso.Date:=ZQuery['FechaIngreso'];
  CBCargo.Text:=ZQuery['DescrCargo'];
  CBStatus.Text:=ZQuery['DescrStatus'];
  CBZona.Text:=ZQuery['DescrZona'];
  MESalDiario.Text:=FloatToStr(ZQuery['SalarioDia']);
  ChBEsFijo.Checked:=ZQuery['PersFijo']='SI';
  BGuardar.Caption:='Modificar datos';
end;

function TFPersonal.BotonActivable: boolean;
begin
  Result:=(MECedula.Text<>'') and (EApellidos.Text<>'') and
    (ENombres.Text<>'') and (DEFecIngreso.Text<>'  /  /    ') and
    (CBCargo.Text<>'') and (CBStatus.Text<>'') and (CBZona.Text<>'') and
    (EliminaEspacio(MESalDiario.Text)<>',');
end;

function TFPersonal.CodigoCargo(Cargo: string): integer;
begin
  if ZQCargo.Locate('DescrCargo',Cargo,[]) then
    CodigoCargo:=ZQCargo['CodCargo']
  else CodigoCargo:=0;
end;

function TFPersonal.CodigoZona(Zona: string): integer;
begin
  if ZQZona.Locate('DescrZona',Zona,[]) then
    CodigoZona:=ZQZona['CodZona']
  else CodigoZona:=0;
end;

procedure TFPersonal.BSalirClick(Sender: TObject);
begin
  if BSalir.Caption='Salir' then Close
  else
  begin
    ActivaControles(true,true);
    ValInicial;
  end;
end;

procedure TFPersonal.BConsultarClick(Sender: TObject);
begin
  if MECedula.Text='' then
  begin
    ShowMessage('Debe indicar un número de cédula/RIF válido');
    MECedula.SetFocus;
  end
  else
  begin
    ZQuery.SQL.Text:='select Cedula from personal where Cedula='+
      QuotedStr(MECedula.Text);
    ZQuery.Open;
    if ZQuery.RecordCount>0 then
    begin
      ShowMessage('La cédula ya está registrada');
      MostrarDatos;
      ActivaControles(true,false);
      CBCargo.SetFocus;
    end
    else
    begin
      ActivaControles(false,false);
      EApellidos.SetFocus;
    end;
  end;
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFPersonal.BGuardarClick(Sender: TObject);
var
  Cedula,Apellidos,Nombres,FIngr,Cargo,Fijo,Zona,SalDiario,Estatus: string;
  Opc: integer;
begin
  //se determina el código del cargo:
  Cargo:=QuotedStr(CBCargo.Text);
  ZQuery.SQL.Text:='select CodCargo from Cargo where DescrCargo='+Cargo;
  ZQuery.Open;
  Cargo:=IntToStr(ZQuery['CodCargo']);
  //se determina el código del status:
  Estatus:=QuotedStr(CBStatus.Text);
  ZQuery.SQL.Text:='select CodStatus from Status where DescrStatus='+Estatus;
  ZQuery.Open;
  Estatus:=IntToStr(ZQuery['CodStatus']);
  //se determina el código de la zona:
  Zona:=QuotedStr(CBZona.Text);
  ZQuery.SQL.Text:='select CodZona from Zona where DescrZona='+Zona;
  ZQuery.Open;
  Zona:=IntToStr(ZQuery['CodZona']);
  //se carga el resto de las variables:
  Cedula:=QuotedStr(Trim(MECedula.Text));
  Apellidos:=QuotedStr(Trim(EApellidos.Text));
  Nombres:=QuotedStr(Trim(ENombres.Text));
  FIngr:='str_to_date('+QuotedStr(DateToStr(DEFecIngreso.Date))+','+
    QuotedStr('%d/%m/%Y')+')';
  if ChBEsFijo.Checked then Fijo:=QuotedStr('SI')
                       else Fijo:=QuotedStr('NO');
  SalDiario:=StringReplace(Trim(MESalDiario.Text)+'00',',','.',[rfReplaceAll,
             rfIgnoreCase]);
  //se guarda en la tabla 'personal' los datos del trabajador:
  if BGuardar.Caption='Guardar datos' then  //si es nuevo:
  begin
    ZQuery.SQL.Text:='insert into personal(Cedula,Apellidos,Nombres,FechaIngreso,'+
      'CodCargo,PersFijo,CodZona,SalarioDia,CodStatus) values('+Cedula+','+
      Apellidos+','+Nombres+','+FIngr+','+Cargo+','+Fijo+','+Zona+','+SalDiario+
      ','+Estatus+')';
    Opc:=1;
  end
  else  //si es una modificación:
  begin
    ZQuery.SQL.Text:='update personal set CodCargo='+Cargo+',CodStatus='+
      Estatus+',CodZona='+Zona+',SalarioDia='+SalDiario+',PersFijo='+Fijo+
      ' where Cedula='+Cedula;
    Opc:=2;
  end;
  ZQuery.ExecSQL;
  ShowMessage('Los datos fueron guardados exitosamente');
  //se invoca el proc. almacenado RegActividad:
  RegActividad(ZQuery,QuotedStr(UsuarioActivo),Cedula,IntToStr(Opc));
  ActivaControles(true,true);
  ValInicial;
end;

procedure TFPersonal.DEFecIngresoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFPersonal.EApellidosKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFPersonal.ENombresKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BGuardar.Enabled:=BotonActivable;
end;

procedure TFPersonal.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;
     {
procedure TFPersonal.Enter2Tab(var Tecla: char);
begin
  if Tecla=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Tecla:=#0
  end
end;
      }
procedure TFPersonal.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BotonActivable;
end;

procedure TFPersonal.FormShow(Sender: TObject);
begin
  ActivaControles(true,true);
  //se cargan los cargos en el combobox:
  ZQCargo.SQL.Text:='select * from Cargo order by DescrCargo asc';
  ZQCargo.Open;
  ZQCargo.First;
  while not ZQCargo.EOF do
  begin
    CBCargo.Items.Add(ZQCargo['DescrCargo']);
    ZQCargo.Next;
  end;
  //se cargan los status en el combobox:
  ZQStatus.SQL.Text:='select * from Status order by DescrStatus asc';
  ZQStatus.Open;
  ZQStatus.First;
  while not ZQStatus.EOF do
  begin
    CBStatus.Items.Add(ZQStatus['DescrStatus']);
    ZQStatus.Next;
  end;
  //se cargan las zonas en el combobox:
  ZQZona.SQL.Text:='select * from Zona order by DescrZona asc';
  ZQZona.Open;
  ZQZona.First;
  while not ZQZona.EOF do
  begin
    CBZona.Items.Add(ZQZona['DescrZona']);
    ZQZona.Next;
  end;
end;

procedure TFPersonal.MECedulaExit(Sender: TObject);
begin
  MECedula.Text:=EliminaEspacio(MECedula.Text);
end;

procedure TFPersonal.MESalDiarioExit(Sender: TObject);
begin
  MESalDiario.Text:=EliminaEspacio(MESalDiario.Text);
end;

procedure TFPersonal.MESalDiarioKeyPress(Sender: TObject; var Key: char);
begin
  if Key=',' then MESalDiario.Text:=EliminaEspacio(MESalDiario.Text);
end;

procedure TFPersonal.MESalDiarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BGuardar.Enabled:=BotonActivable;
end;

end.

