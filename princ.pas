unit princ;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, ComCtrls, ZDataset, Utiles;

type

  { TFPrinc }

  TFPrinc = class(TForm)
    Image1: TImage;
    MenuItem1: TMenuItem;
    MIAdmUsuarios: TMenuItem;
    MICmbUsr: TMenuItem;
    MICmbContr: TMenuItem;
    MIRelContrColect: TMenuItem;
    MISolPagoTmpExtr: TMenuItem;
    MICtrlGuardMens: TMenuItem;
    MIVacaciones: TMenuItem;
    MICronoVac: TMenuItem;
    MIEjercFiscal: TMenuItem;
    MenuItem5: TMenuItem;
    MICtrlAsistVig: TMenuItem;
    MIContrGuardias: TMenuItem;
    MIListPersonal: TMenuItem;
    MIOpciones: TMenuItem;
    MIConfig: TMenuItem;
    MIAyuda: TMenuItem;
    MenuItem4: TMenuItem;
    MIReportes: TMenuItem;
    MIZonas: TMenuItem;
    MISalir: TMenuItem;
    MIAcerca: TMenuItem;
    MIPersonal: TMenuItem;
    MenuPrinc: TMainMenu;
    MIArchivo: TMenuItem;
    SBar: TStatusBar;
    ZQConf: TZQuery;
    procedure ActivarMenu(Usuario,Rango: string);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure MIAdmUsuariosClick(Sender: TObject);
    procedure MICmbContrClick(Sender: TObject);
    procedure MICmbUsrClick(Sender: TObject);
    procedure MICtrlGuardMensClick(Sender: TObject);
    procedure MIEjercFiscalClick(Sender: TObject);
    procedure MIRelContrColectClick(Sender: TObject);
    procedure MISolPagoTmpExtrClick(Sender: TObject);
    procedure MIVacacionesClick(Sender: TObject);
    procedure MICronoVacClick(Sender: TObject);
    procedure MIAcercaClick(Sender: TObject);
    procedure MICargosClick(Sender: TObject);
    procedure MIContrGuardiasClick(Sender: TObject);
    procedure MICtrlAsistVigClick(Sender: TObject);
    procedure MIListPersonalClick(Sender: TObject);
    procedure MIOpcionesClick(Sender: TObject);
    procedure MIPersonalClick(Sender: TObject);
    procedure MISalirClick(Sender: TObject);
    procedure MIZonasClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FPrinc: TFPrinc;

implementation

uses
  datamod,personal,cargos,zonas,contrguardias,vacaciones,ejercfiscal,
  listpersonal,ctrlasistvig,cronovacsimpl,ctrlguardmens,solpagotmpextr,
  relcontrcol,opcsistema,admusuarios,cambiousuario,cambiocontrasena,acerca;

var
  Salir: boolean;

{$R *.lfm}

{ TFPrinc }

procedure TFPrinc.ActivarMenu(Usuario,Rango: string);
begin
  //menú Archivo:
  MIPersonal.Enabled:=Usuario<>'';
  MIZonas.Enabled:=Usuario<>'';
  MIContrGuardias.Enabled:=(Usuario<>'') and (Rango='SUPERVISOR');
  MIVacaciones.Enabled:=Usuario<>'';
  MIEjercFiscal.Enabled:=Usuario<>'';
  //menú Reportes:
  MIListPersonal.Enabled:=Usuario<>'';
  MICtrlAsistVig.Enabled:=Usuario<>'';
  MICronoVac.Enabled:=Usuario<>'';
  MICtrlGuardMens.Enabled:=Usuario<>'';
  MISolPagoTmpExtr.Enabled:=Usuario<>'';
  MIRelContrColect.Enabled:=Usuario<>'';
  //menú Usuarios:
  {MINvoUsuario.Enabled:=(Usuario<>'') and (Rango='SUPERVISOR');
  MICambContr.Enabled:=Usuario<>'';   }
  //menú Configuración:
  MIOpciones.Enabled:=(Usuario<>'') and (Rango='SUPERVISOR');
  MIAdmUsuarios.Enabled:=(Usuario<>'') and (Rango='SUPERVISOR');
  MICmbContr.Enabled:=Usuario<>'';
  //barra de estado:
  SBar.Panels[0].Text:=' Usuario activo: '+Usuario;
  SBar.Panels[1].Text:=' Rango: '+Rango;
end;

procedure TFPrinc.MISalirClick(Sender: TObject);
begin
  Salir:=MessageDlg(' ¿Desea salir del sistema? ',
         mtConfirmation,[mbNo,mbYes],0)=mrYes;
  if Salir then
  begin
    DMod.ZCon.Connected:=false;
    Application.Terminate;
  end;
end;

procedure TFPrinc.MIZonasClick(Sender: TObject);
begin
  MostrarVentana(TFZonas);
end;

procedure TFPrinc.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  MISalirClick(Sender);  CanClose:=Salir;
end;

procedure TFPrinc.FormShow(Sender: TObject);
var
  Fecha: string;
begin
  Caption:=NombreSistema+Caption;
  //se crea el usuario por defecto:
  Fecha:=FormatoFechaSQL(Date);
  ZQConf.SQL.Text:='select IDUsuario from usuario';
  ZQConf.Open;
  if ZQConf.RecordCount=0 then
  begin
    ZQConf.SQL.Text:='insert into usuario (IDUsuario,Clave,Cedula,Nombre,'+
      'Rango,FecRegistro,Activo) values ("usuario","00000000","00000000",'+
      '"usuario por defecto","SUPERVISOR",'+Fecha+',1)';
    ZQConf.ExecSQL;
  end;
  ActivarMenu(UsuarioActivo,RangoActivo);
  //en caso de que tabla de conf esté vacía:
  ZQConf.SQL.Text:='select * from configuracion';
  ZQConf.Open;
  if ZQConf.RecordCount=0 then
  begin
    ZQConf.SQL.Text:='insert into configuracion (NomAnalista,NomCoordPers,'+
      'NomSupVigilante,NomDirecGeneral) values ("","","","")';
    ZQConf.ExecSQL;
    ShowMessage('Debe llenar los datos de configuración. Puede hacerlo '+#13+
      'en Configuración->Opciones del sistema');
  end;
end;

procedure TFPrinc.MIAdmUsuariosClick(Sender: TObject);
begin
  MostrarVentana(TFAdmUsuarios);
end;

procedure TFPrinc.MICmbContrClick(Sender: TObject);
begin
  MostrarVentana(TFCambContr);
end;

procedure TFPrinc.MICmbUsrClick(Sender: TObject);
begin
  MostrarVentana(TFCambioUsuario);
end;

procedure TFPrinc.MICtrlGuardMensClick(Sender: TObject);
begin
  MostrarVentana(TFCtrlGuardMens);
end;

procedure TFPrinc.MIEjercFiscalClick(Sender: TObject);
begin
  MostrarVentana(TFEjercFiscal);
end;

procedure TFPrinc.MIRelContrColectClick(Sender: TObject);
begin
  MostrarVentana(TFRelContrCol);
end;

procedure TFPrinc.MISolPagoTmpExtrClick(Sender: TObject);
begin
  MostrarVentana(TFSolPagoTmpExtr);
end;

procedure TFPrinc.MIVacacionesClick(Sender: TObject);
begin
  MostrarVentana(TFVacaciones);
end;

procedure TFPrinc.MICronoVacClick(Sender: TObject);
begin
  MostrarVentana(TFCronoVac);
end;

procedure TFPrinc.MIAcercaClick(Sender: TObject);
begin
  MostrarVentana(TFAcerca);
end;

procedure TFPrinc.MICargosClick(Sender: TObject);
begin
  MostrarVentana(TFCargos);
end;

procedure TFPrinc.MIContrGuardiasClick(Sender: TObject);
begin
  MostrarVentana(TFContrGuardias);
end;

procedure TFPrinc.MICtrlAsistVigClick(Sender: TObject);
begin
  MostrarVentana(TFCtrlAsistVig);
end;

procedure TFPrinc.MIListPersonalClick(Sender: TObject);
begin
  MostrarVentana(TFListPersonal);
end;

procedure TFPrinc.MIOpcionesClick(Sender: TObject);
begin
  MostrarVentana(TFOpcSistema);
end;

procedure TFPrinc.MIPersonalClick(Sender: TObject);
begin
  MostrarVentana(TFPersonal);
end;

end.

