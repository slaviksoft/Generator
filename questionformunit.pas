unit questionformunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, BCButton, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TFormQuestion }

  TFormQuestion = class(TForm)
    BCButtonAbort: TBCButton;
    BCButtonContinue: TBCButton;
    Label1: TLabel;
    Shape1: TShape;
    procedure BCButtonAbortClick(Sender: TObject);
    procedure BCButtonContinueClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormQuestion: TFormQuestion;

implementation

{$R *.lfm}

{ TFormQuestion }

procedure TFormQuestion.BCButtonAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

procedure TFormQuestion.BCButtonContinueClick(Sender: TObject);
begin
  ModalResult := mrIgnore;
end;

end.

