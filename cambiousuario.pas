unit cambiousuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ZDataset, Utiles;

type

  { TFCambioUsuario }

  TFCambioUsuario = class(TForm)
    BAceptar: TButton;
    Bevel1: TBevel;
    BSalir: TButton;
    CBSalir: TCheckBox;
    EUsuario: TEdit;
    EContrasena: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LUsrActivo: TLabel;
    ZQuery: TZQuery;
    procedure BAceptarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure CBSalirChange(Sender: TObject);
    procedure EContrasenaKeyPress(Sender: TObject; var Key: char);
    procedure EContrasenaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EUsuarioKeyPress(Sender: TObject; var Key: char);
    procedure EUsuarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure ValInicial;
    procedure Enter2Tab(var Key: char);
    procedure ActivaBoton;
  public
    { public declarations }
  end; 

var
  FCambioUsuario: TFCambioUsuario;

implementation

uses
  princ;

{$R *.lfm}

{ TFCambioUsuario }

procedure TFCambioUsuario.ValInicial;
begin
  EUsuario.Clear;
  EContrasena.Clear;
  EContrasena.Enabled:=false;
  ActivaBoton;
  EUsuario.SetFocus;
end;

procedure TFCambioUsuario.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end;
end;

procedure TFCambioUsuario.ActivaBoton;
begin
  BAceptar.Enabled:=(EUsuario.Text<>'') and (EContrasena.Text<>'')
    and (Length(EContrasena.Text)>7);
end;

procedure TFCambioUsuario.BAceptarClick(Sender: TObject);
begin
  if CBSalir.Checked then
  begin
    UsuarioActivo:='';
    RangoActivo:='';
    ContrActiva:='';
    ShowMessage('El usuario '+EUsuario.Text+' ha cerrado la sesión.');
    Close;
  end
  else
  begin
    ZQuery.SQL.Text:='select IDUsuario,Clave,Rango,Activo from usuario '+
      'where IDUsuario='+QuotedStr(EUsuario.Text)+' and Clave='+
      QuotedStr(EContrasena.Text);
    ZQuery.Open;
    if ZQuery.RecordCount>0 then
    begin
      if ZQuery['Activo']>0 then
      begin
        UsuarioActivo:=EUsuario.Text;
        RangoActivo:=ZQuery['Rango'];
        ContrActiva:=ZQuery['Clave'];
        //se actualiza el usuario actual en la tabla configuración:
        ZQuery.SQL.Text:='update configuracion set UsuarioActivo='+
          QuotedStr(UsuarioActivo);
        ZQuery.ExecSQL;
        ShowMessage('El usuario '+EUsuario.Text+' ha entrado en sesión.');
        Close;
      end
      else
      begin
        ShowMessage('La cuenta '+EUsuario.Text+' está deshabilitada.');
        ValInicial;
      end
    end
    else
    begin
      ShowMessage('El usuario y/o contraseña es (son) incorrecto(s). Intente de nuevo');
      ValInicial;
    end;
  end;
  FPrinc.ActivarMenu(UsuarioActivo,RangoActivo);
end;

procedure TFCambioUsuario.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCambioUsuario.CBSalirChange(Sender: TObject);
begin
  BAceptar.Enabled:=CBSalir.Checked;
end;

procedure TFCambioUsuario.EContrasenaKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFCambioUsuario.EContrasenaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ActivaBoton;
end;

procedure TFCambioUsuario.EUsuarioKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFCambioUsuario.EUsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EUsuario.Text:=EliminaEspacio(EUsuario.Text);
  EContrasena.Enabled:=Length(EUsuario.Text)>5;
  ActivaBoton;
end;

procedure TFCambioUsuario.FormShow(Sender: TObject);
begin
  if UsuarioActivo<>'' then LUsrActivo.Caption:='Usuario activo: '+UsuarioActivo
  else LUsrActivo.Caption:='No hay ningún usuario activo';
  CBSalir.Enabled:=UsuarioActivo<>'';
  ValInicial;
end;

end.

