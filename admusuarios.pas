unit admusuarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, MaskEdit, ComCtrls, DbCtrls, ZDataset, Utiles;

type

  { TFAdmUsuarios }

  TFAdmUsuarios = class(TForm)
    BConsDisp: TButton;
    BCrear: TButton;
    BAplicar: TButton;
    BSalir: TButton;
    BCancelar: TButton;
    ChBDesact: TCheckBox;
    CBRango: TComboBox;
    DBEdit1: TDBEdit;
    ERango: TDBEdit;
    ECedula: TDBEdit;
    ENombre: TDBEdit;
    DS: TDatasource;
    DBGUsuarios: TDBGrid;
    EUsuario: TEdit;
    EContr1: TEdit;
    EContr2: TEdit;
    ENombreNvo: TEdit;
    EActivo: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    LFecha: TLabel;
    LConfContr: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MECedulaNvo: TMaskEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ZQuery: TZQuery;
    ZQryList: TZQuery;
    procedure BAplicarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure BConsDispClick(Sender: TObject);
    procedure BCrearClick(Sender: TObject);
    procedure BCrearKeyPress(Sender: TObject; var Key: char);
    procedure BSalirClick(Sender: TObject);
    procedure CBRangoChange(Sender: TObject);
    procedure CBRangoKeyPress(Sender: TObject; var Key: char);
    procedure ChBDesactChange(Sender: TObject);
    procedure ChBDesactKeyPress(Sender: TObject; var Key: char);
    procedure DBEdit1KeyPress(Sender: TObject; var Key: char);
    procedure DBGUsuariosCellClick(Column: TColumn);
    procedure DBGUsuariosKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EActivoKeyPress(Sender: TObject; var Key: char);
    procedure ECedulaKeyPress(Sender: TObject; var Key: char);
    procedure EContr1KeyPress(Sender: TObject; var Key: char);
    procedure EContr1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EContr2KeyPress(Sender: TObject; var Key: char);
    procedure EContr2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ENombreKeyPress(Sender: TObject; var Key: char);
    procedure ENombreNvoChange(Sender: TObject);
    procedure ENombreNvoExit(Sender: TObject);
    procedure ENombreNvoKeyPress(Sender: TObject; var Key: char);
    procedure ENombreNvoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ERangoKeyPress(Sender: TObject; var Key: char);
    procedure EUsuarioExit(Sender: TObject);
    procedure EUsuarioKeyPress(Sender: TObject; var Key: char);
    procedure EUsuarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure MECedulaNvoChange(Sender: TObject);
    procedure MECedulaNvoExit(Sender: TObject);
    procedure MECedulaNvoKeyPress(Sender: TObject; var Key: char);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
  private
    { private declarations }
    procedure Enter2Tab(var Key: char);
    procedure ValInicial;
    procedure ActivaBoton;
    procedure EsActivo;
  public
    { public declarations }
  end; 

var
  FAdmUsuarios: TFAdmUsuarios;
  Disponible: boolean;

implementation

{$R *.lfm}

{ TFAdmUsuarios }

procedure TFAdmUsuarios.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end;
end;

procedure TFAdmUsuarios.ValInicial;
begin
  Disponible:=false;
  LConfContr.Caption:='';
  EUsuario.Clear;
  EUsuario.Font.Style:=[];
  EUsuario.Font.Color:=clDefault;
  EUsuario.SetFocus;
  EUsuario.ReadOnly:=false;
  EContr1.Clear;
  EContr2.Clear;
  EContr1.Enabled:=false;
  EContr2.Enabled:=false;
  ENombreNvo.Clear;
  MECedulaNvo.Clear;
  CBRango.ItemIndex:=-1;
  ENombreNvo.Enabled:=false;
  MECedulaNvo.Enabled:=false;
  CBRango.Enabled:=false;
  BConsDisp.Enabled:=false;
  ActivaBoton;
end;

procedure TFAdmUsuarios.ActivaBoton;
begin
  BCrear.Enabled:=(ENombreNvo.Text<>'') and (MECedulaNvo.Text<>'')
    and (CBRango.ItemIndex>-1) and (EContr1.Text=EContr2.Text)
    and (Length(EContr1.Text)>7) and (Length(EContr2.Text)>7)
    and Disponible;
end;

procedure TFAdmUsuarios.EsActivo;
begin
  if ZQryList['Activo']=1 then EActivo.Text:='SI'
                          else EActivo.Text:='NO';
end;

procedure TFAdmUsuarios.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFAdmUsuarios.CBRangoChange(Sender: TObject);
begin
  ActivaBoton;
end;

procedure TFAdmUsuarios.CBRangoKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.ChBDesactChange(Sender: TObject);
begin
  BAplicar.Enabled:=ChBDesact.Checked;
end;

procedure TFAdmUsuarios.ChBDesactKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.DBEdit1KeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.DBGUsuariosCellClick(Column: TColumn);
begin
  EsActivo;
end;

procedure TFAdmUsuarios.DBGUsuariosKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EsActivo;
end;

procedure TFAdmUsuarios.EActivoKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.ECedulaKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFAdmUsuarios.EContr1KeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.EContr1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EContr1.Text:=EliminaEspacio(EContr1.Text);
  EContr2.Enabled:=Length(EContr1.Text)>7;
  ActivaBoton;
end;

procedure TFAdmUsuarios.EContr2KeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.EContr2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if EContr2.Text=EContr1.Text then
  begin
    LConfContr.Caption:='Las contraseñas son válidas';
    LConfContr.Font.Color:=clGreen;
    ENombreNvo.Enabled:=true;
    MECedulaNvo.Enabled:=true;
    CBRango.Enabled:=true;
  end
  else
  begin
    LConfContr.Caption:='Las contraseñas no coinciden';
    LConfContr.Font.Color:=clRed;
    ENombreNvo.Enabled:=false;
    MECedulaNvo.Enabled:=false;
    CBRango.Enabled:=false;
  end;
  ActivaBoton;
end;

procedure TFAdmUsuarios.ENombreKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFAdmUsuarios.ENombreNvoChange(Sender: TObject);
begin
  ActivaBoton;
end;

procedure TFAdmUsuarios.ENombreNvoExit(Sender: TObject);
begin
  ENombreNvo.Text:=Trim(ENombreNvo.Text);
end;

procedure TFAdmUsuarios.ENombreNvoKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.ENombreNvoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TFAdmUsuarios.ERangoKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.EUsuarioExit(Sender: TObject);
begin
  //EUsuario.Text:=EliminaEspacio(EUsuario.Text);
end;

procedure TFAdmUsuarios.EUsuarioKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.EUsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EUsuario.Text:=EliminaEspacio(EUsuario.Text);
  BConsDisp.Enabled:=Length(EUsuario.Text)>5;
end;

procedure TFAdmUsuarios.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFAdmUsuarios.FormShow(Sender: TObject);
begin
  //LFecha.Caption:='Fecha de registro: '+DateToStr(Date);
  //ValInicial;
end;

procedure TFAdmUsuarios.MECedulaNvoChange(Sender: TObject);
begin
  ActivaBoton;
end;

procedure TFAdmUsuarios.MECedulaNvoExit(Sender: TObject);
begin
  MECedulaNvo.Text:=EliminaEspacio(MECedulaNvo.Text);
end;

procedure TFAdmUsuarios.MECedulaNvoKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.TabSheet1Show(Sender: TObject);
begin
  LFecha.Caption:='Fecha de registro: '+DateToStr(Date);
  ValInicial;
end;

procedure TFAdmUsuarios.TabSheet2Show(Sender: TObject);
begin
  ZQryList.Open;
  DBGUsuarios.SetFocus;
  EsActivo;
end;

procedure TFAdmUsuarios.BConsDispClick(Sender: TObject);
begin
  ZQuery.SQL.Text:='select IDUsuario from usuario where IDUsuario='+
    QuotedStr(EUsuario.Text);
  ZQuery.Open;
  if ZQuery.RecordCount>0 then
  begin
    ShowMessage('El nombre de usuario ya existe. Intente otro.');
    EUsuario.SetFocus;
  end
  else
  begin
    ShowMessage('El nombre de usuario está disponible.');
    Disponible:=true;
    EUsuario.Font.Style:=[fsBold];
    EUsuario.Font.Color:=clGreen;
    EUsuario.ReadOnly:=true;
    EContr1.Enabled:=true;
    EContr1.SetFocus;
  end;
end;

procedure TFAdmUsuarios.BCancelarClick(Sender: TObject);
begin
  ValInicial;
end;

procedure TFAdmUsuarios.BAplicarClick(Sender: TObject);
var
  Usuario: string;
begin
  Usuario:=ZQryList['IDUsuario'];
  ZQryList.SQL.Text:='update usuario set Activo=0 where IDUsuario='+
    QuotedStr(Usuario);
  ZQryList.ExecSQL;
  ZQryList.SQL.Text:='select * from usuario';
  ZQryList.Open;
  ChBDesact.Checked:=false;
  DBGUsuarios.SetFocus;
  ShowMessage('La cuenta del usuario "'+Usuario+'" fue deshabilitada.');
end;

procedure TFAdmUsuarios.BCrearClick(Sender: TObject);
var
  IDUsuario,Clave,Cedula,Nombre,Rango,FecRegistro: string;
begin
  IDUsuario:=QuotedStr(EUsuario.Text);
  Clave:=QuotedStr(EContr1.Text);
  Cedula:=QuotedStr(MECedulaNvo.Text);
  Nombre:=QuotedStr(ENombreNvo.Text);
  Rango:=QuotedStr(CBRango.Text);
  FecRegistro:=FormatoFechaSQL(Date);
  FormatoFechaSQL(Date);
  ZQuery.SQL.Text:='insert into usuario (IDUsuario,Clave,Cedula,Nombre,'+
    'Rango,FecRegistro,Activo) values('+IDUsuario+','+Clave+','+Cedula+','+
    Nombre+','+Rango+','+FecRegistro+',1)';
  ZQuery.ExecSQL;
  ZQryList.SQL.Text:='select * from usuario';
  ZQryList.Open;
  ShowMessage('El usuario fue creado exitosamente.');
  ValInicial;
end;

procedure TFAdmUsuarios.BCrearKeyPress(Sender: TObject; var Key: char);
begin
  BCrearClick(Self);
  Enter2Tab(Key);
end;

end.
