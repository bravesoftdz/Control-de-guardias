unit cambiocontrasena;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ZDataset, Utiles;

type

  { TFCambContr }

  TFCambContr = class(TForm)
    BCambiar: TButton;
    Bevel1: TBevel;
    BSalir: TButton;
    EConfPassword: TEdit;
    EPasswActual: TEdit;
    EPassword: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LMensaje: TLabel;
    ZQuery: TZQuery;
    procedure BCambiarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure EPasswActualChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    function ActivaBoton: boolean;
  public
    { public declarations }
  end; 

var
  FCambContr: TFCambContr;

implementation

uses
  princ;

{$R *.lfm}

{ TFCambContr }

function TFCambContr.ActivaBoton: boolean;
begin
  Result:=(Length(EPasswActual.Text)>7) and (Length(EPassword.Text)>7)
           and (Length(EConfPassword.Text)>7)
end;

procedure TFCambContr.BCambiarClick(Sender: TObject);
begin
  if EPasswActual.Text=ContrActiva then
    if EPassword.Text=EConfPassword.Text then
    begin
      ZQuery.SQL.Text:='update usuario set Clave='+QuotedStr(EPassword.Text)
        +' where IDUsuario='+QuotedStr(UsuarioActivo);
      ZQuery.ExecSQL;
      ShowMessage(' La contraseña ha sido cambiada exitosamente ');
      //BSalir.SetFocus;
      UsuarioActivo:='';
      RangoActivo:='';
      ContrActiva:='';
      FPrinc.ActivarMenu(UsuarioActivo,RangoActivo);
      Close;
    end
    else
    begin
      ShowMessage(' La contraseña nueva no concuerda ');
      EConfPassword.SetFocus;
    end
  else
  begin
    ShowMessage(' Contraseña actual incorrecta ');
    EPasswActual.SetFocus;
  end;
end;

procedure TFCambContr.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCambContr.EPasswActualChange(Sender: TObject);
begin
  BCambiar.Enabled:=ActivaBoton;
end;

procedure TFCambContr.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

procedure TFCambContr.FormShow(Sender: TObject);
begin
  LMensaje.Caption:='Usuario activo: '+UsuarioActivo;
end;

end.

