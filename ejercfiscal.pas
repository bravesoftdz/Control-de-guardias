unit ejercfiscal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ZDataset, Utiles;

type

  { TFEjercFiscal }

  TFEjercFiscal = class(TForm)
    BGenerar: TButton;
    BSalir: TButton;
    EAnio2: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LBExist: TListBox;
    SEAnio1: TSpinEdit;
    ZQuery: TZQuery;
    ZQrExist: TZQuery;
    procedure BGenerarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure SEAnio1Change(Sender: TObject);
    procedure SEAnio1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
    procedure Enter2Tab(var Key: char);
    procedure CargaEjFiscales;
  public
    { public declarations }
  end; 

var
  FEjercFiscal: TFEjercFiscal;

implementation

{$R *.lfm}

{ TFEjercFiscal }

procedure TFEjercFiscal.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);  Key:=#0
  end;
end;

procedure TFEjercFiscal.CargaEjFiscales;
begin
  LBExist.Clear;
  ZQrExist.SQL.Text:='select * from ejercfiscal';
  ZQrExist.Open;
  ZQrExist.First;
  while not ZQrExist.EOF do
  begin
    LBExist.Items.Add(ZQrExist['EjFiscal']);
    ZQrExist.Next;
  end;
end;

procedure TFEjercFiscal.FormShow(Sender: TObject);
begin
  CargaEjFiscales;
  SEAnio1.Value:=AnioDe(Date);
  EAnio2.Text:=IntToStr(SEAnio1.Value+1);
end;

procedure TFEjercFiscal.SEAnio1Change(Sender: TObject);
begin
  EAnio2.Text:=IntToStr(SEAnio1.Value+1);
end;

procedure TFEjercFiscal.SEAnio1KeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFEjercFiscal.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFEjercFiscal.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFEjercFiscal.BGenerarClick(Sender: TObject);
var
  EjFiscal,FechaElab: string;
begin
  EjFiscal:=QuotedStr(IntToStr(SEAnio1.Value)+'-'+EAnio2.Text);
  FechaElab:=FormatoFechaSQL(Date);
  ZQuery.SQL.Text:='select EjFiscal from ejercfiscal where EjFiscal='+EjFiscal;
  ZQuery.Open;
  if ZQuery.RecordCount=0 then
  begin
    ZQuery.SQL.Text:='insert into ejercfiscal (EjFiscal,FechaElab) values ('+
      EjFiscal+','+FechaElab+')';
    ZQuery.ExecSQL;
    ShowMessage('El ejercicio fiscal '+EjFiscal+' se creo satisfactoriamente');
    CargaEjFiscales;
    BSalir.SetFocus;
  end
  else
  begin
    ShowMessage('El ejercicio fiscal '+EjFiscal+' ya existe');
    SEAnio1.SetFocus;
  end;
end;

end.

