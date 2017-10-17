program Sistema;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazreport, zcomponent, princ, personal, Utiles, zonas, opcsistema,
  acerca, datamod, listpersonal, contrguardias, ctrlasistvig, cronovacsimpl,
  vacaciones, ejercfiscal, ctrlguardmens, solpagotmpextr, relcontrcol,
  cambiousuario, admusuarios, cambiocontrasena
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFPrinc, FPrinc);
  Application.CreateForm(TDMod, DMod);
  Application.Run;
end.

