unit cargos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, ExtCtrls;

type

  { TFCargos }

  TFCargos = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Label1: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FCargos: TFCargos;

implementation

{$R *.lfm}

end.

