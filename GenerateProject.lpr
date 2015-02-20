program GenerateProject;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, laz_synapse, MainFormUnit, BreakFormUnit, GeneratorUnit
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Generator';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormBreak, FormBreak);
  Application.Run;
end.

