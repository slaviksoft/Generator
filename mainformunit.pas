unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, BCPanel, BCButton, Forms, Controls, Graphics,
  Dialogs, ValEdit, ExtCtrls, Spin, StdCtrls, maskedit, BreakFormUnit, GeneratorUnit;

type

  { TMainForm }

  TMainForm = class(TForm, IGeneratorEvents)
    BCButtonSaveCodes: TBCButton;
    BCButtonSaveMD5: TBCButton;
    BCButtonGenerate: TBCButton;
    BCPanelOptions: TBCPanel;
    EditPref: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MemoCodes: TMemo;
    MemoMD5: TMemo;
    SaveDialog1: TSaveDialog;
    SpinEditRandomDigits: TSpinEdit;
    SpinEditCountingStart: TSpinEdit;
    SpinEditCountingCount: TSpinEdit;
    procedure BCButtonGenerateClick(Sender: TObject);
    procedure BCButtonSaveCodesClick(Sender: TObject);
    procedure BCButtonSaveMD5Click(Sender: TObject);
    procedure EditPrefKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
    procedure OnProgressEvent(AValue, AProgress: integer; var Stop:boolean);
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.BCButtonGenerateClick(Sender: TObject);
var
  Gen:TGenerator;
begin
  Gen := TGenerator.Create(Self);
  Gen.Codes := MemoCodes.Lines;
  Gen.MD5   := MemoMD5.Lines;
  Gen.Pref := EditPref.Text;
  Gen.CountingStart := SpinEditCountingStart.Value;
  Gen.CountingCount := SpinEditCountingCount.Value;
  Gen.RndDigits := SpinEditRandomDigits.Value;

  MemoCodes.Lines.BeginUpdate;
  MemoMD5.Lines.BeginUpdate;
  FormBreak.Show;

  Gen.Start;

  FormBreak.CloseWindow;
  MemoCodes.Lines.EndUpdate;
  MemoMD5.Lines.EndUpdate;
end;

procedure TMainForm.BCButtonSaveCodesClick(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
     MemoCodes.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TMainForm.BCButtonSaveMD5Click(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
     MemoMD5.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TMainForm.EditPrefKeyPress(Sender: TObject; var Key: char);
begin
  if Ord(Key) < Ord(' ') then exit;
  if not (Key in ['0'..'9']) then Key := #0;
end;

procedure TMainForm.OnProgressEvent(AValue, AProgress: integer; var Stop: boolean);
begin
  FormBreak.Progress := AProgress;
  FormBreak.Passed := AValue;
  Application.ProcessMessages;
  if FormBreak.Stopped then stop := true;
end;

end.

