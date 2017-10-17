unit cronovacsimpl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, DBGrids, ExtCtrls, LR_Class, LR_DBSet, ZDataset, Utiles;

type

  { TFCronoVac }

  TFCronoVac = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BSalir: TButton;
    BConsultar: TButton;
    BImprimir: TButton;
    CBEjFiscal: TComboBox;
    CBMesVac: TComboBox;
    ChBTodos: TCheckBox;
    DS: TDatasource;
    DBGCronoVac: TDBGrid;
    frDBDSet: TfrDBDataSet;
    frReporte: TfrReport;
    Label3: TLabel;
    Label4: TLabel;
    RGReporte: TRadioGroup;
    ZQuery: TZQuery;
    ZQrConfig: TZQuery;
    procedure BConsultarClick(Sender: TObject);
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure CBEjFiscalChange(Sender: TObject);
    procedure ChBTodosChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure ValInicial;
  public
    { public declarations }
  end; 

var
  FCronoVac: TFCronoVac;

implementation

{$R *.lfm}

{ TFCronoVac }

procedure TFCronoVac.ValInicial;
begin
  CBEjFiscal.ItemIndex:=-1;
  CBMesVac.ItemIndex:=-1;
end;

procedure TFCronoVac.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCronoVac.BConsultarClick(Sender: TObject);
var
  EjFiscal,MesVacacion,Todos: string;
begin
  EjFiscal:=QuotedStr(CBEjFiscal.Text);
  MesVacacion:=QuotedStr(CBMesVac.Text);
  if not ChBTodos.Checked then Todos:=' and v.MesVacacion='+MesVacacion
                          else Todos:='';
  ZQuery.SQL.Text:='select Concat(Apellidos,", ",Nombres) Nombre,p.Cedula,'+
    'c.DescrCargo,p.FechaIngreso,v.MesVacacion,v.FecIniVac,v.FecFinVac,'+
    'v.FecReintegro,v.TotDiasVac,v.Observacion,e.EjFiscal from personal p,vacaciones v,'+
    'cargo c,ejercfiscal e where e.CodEjFiscal=v.CodEjFiscal and p.Cedula='+
    'v.Cedula and c.CodCargo=p.CodCargo and e.EjFiscal='+EjFiscal+Todos+
    ' order by FecIniVac asc';
  ZQuery.Open;
end;

procedure TFCronoVac.BImprimirClick(Sender: TObject);
var
  sReporte: string;
begin
  if RGReporte.ItemIndex=0 then sReporte:='rpcronovacgen.lrf'
                           else sReporte:='rpcronovacsimpl.lrf';
  ZQrConfig.SQL.Text:='select * from configuracion';
  ZQrConfig.Open;
  if ZQuery.RecordCount>0 then MuestraReporte(frReporte,sReporte);
end;

procedure TFCronoVac.CBEjFiscalChange(Sender: TObject);
begin
  BConsultar.Enabled:=(CBEjFiscal.ItemIndex>-1) and
    ((CBMesVac.ItemIndex>-1) or ChBTodos.Checked);
end;

procedure TFCronoVac.ChBTodosChange(Sender: TObject);
begin
  CBMesVac.Enabled:=not ChBTodos.Checked;

  BImprimir.Enabled:=ChBTodos.Checked;
  BConsultar.Enabled:=(CBEjFiscal.ItemIndex>-1) and
    ((CBMesVac.ItemIndex>-1) or ChBTodos.Checked);
end;

procedure TFCronoVac.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

procedure TFCronoVac.FormShow(Sender: TObject);
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
  ZQuery.Close;
end;

end.

