unit datamod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, Controls;

type

  { TDMod }

  TDMod = class(TDataModule)
    ZCon: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  DMod: TDMod;

implementation

{$R *.lfm}

{ TDMod }

procedure TDMod.DataModuleCreate(Sender: TObject);
begin
  ZCon.Port:=3306;
  ZCon.User:='root';
  //ZCon.HostName:='192.168.1.20';
  //ZCon.HostName:='186.92.209.97';
  ZCon.HostName:='localhost';
  ZCon.Connected:=true;
end;

end.

