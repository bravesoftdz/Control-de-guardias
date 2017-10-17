unit solpagotmpextr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, LR_Class, LR_DBSet, ZDataset, Utiles, DateUtils;

type

  { TFSolPagoTmpExtr }

  TFSolPagoTmpExtr = class(TForm)
    Bevel1: TBevel;
    BImprimir: TButton;
    BSalir: TButton;
    CBMes: TComboBox;
    frDBDSet: TfrDBDataSet;
    frRpt: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LBTrabaj: TListBox;
    SEAnio: TSpinEdit;
    ZQrTmp: TZQuery;
    ZQuery: TZQuery;
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FSolPagoTmpExtr: TFSolPagoTmpExtr;

implementation

{$R *.lfm}

{ TFSolPagoTmpExtr }

procedure TFSolPagoTmpExtr.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFSolPagoTmpExtr.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end
end;

procedure TFSolPagoTmpExtr.BImprimirClick(Sender: TObject);
var
  Cedula,MesGuardia: string;
begin
  Cedula:=QuotedStr(ExtraeCedula(LBTrabaj.Items.Strings[LBTrabaj.ItemIndex]));
  MesGuardia:=QuotedStr(MesAnio(EncodeDate(SEAnio.Value,CBMes.ItemIndex+1,1)));
  //se cargan los datos del encabezado y pie de página:
  ZQrTmp.SQL.Text:='select Concat(p.Apellidos,", ",p.Nombres) Nombre,p.Cedula,'+
    'c.DescrCargo,p.SalarioDia,l.MesGuardia,z.DescrZona,x.NomDirecGeneral,'+
    'x.NomSupVigilante,x.NomAnalista,x.NomCoordPers from personal p,cargo c,'+
    'ctrolguardias g,listguardias l,zona z,configuracion x where c.CodCargo='+
    'p.CodCargo and l.CodGuardia=g.CodGuardia and z.CodZona=p.CodZona and '+
    'p.Cedula='+Cedula+' and l.MesGuardia='+MesGuardia;
  ZQrTmp.Open;
  //se cargan los datos maestros:
  ZQuery.SQL.Text:='select d.DiaLetras,d.DiaNumeros,d.HoraExEntrada,d.HoraExSalida,'+
    'd.Observacion from detalletmpoextra d,listguardias l where l.CodGuardia='+
    'd.CodGuardia and l.MesGuardia='+MesGuardia+' and d.Cedula='+Cedula;
  ZQuery.Open;
  //se muestra el reporte:
  MuestraReporte(frRpt,'rpsolpagotmpextr.lrf');
end;

procedure TFSolPagoTmpExtr.FormShow(Sender: TObject);
begin
  SEAnio.Value:=AnioDe(Date);
  CBMes.ItemIndex:=MonthOfTheYear(Date)-1;
  //se cargan los trabajadores:
  ZQrTmp.SQL.Text:='select Concat(Cedula," - ",Apellidos,", ",Nombres) Nombre,'+
    'Cedula from personal order by Apellidos';
  ZQrTmp.Open;
  while not ZQrTmp.EOF do
  begin
    LBTrabaj.Items.Add(ZQrTmp['Nombre']);
    ZQrTmp.Next;
  end;
end;

end.

