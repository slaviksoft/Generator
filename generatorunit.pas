unit GeneratorUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, EncodeDecode;

const
   GeneratorID = '{48308AB8-07D0-4A17-B049-71422DD8B73F}';

type

  IGeneratorEvents = interface
    [GeneratorID]
    procedure OnProgressEvent(AValue, AProgress: integer; var Stop:boolean);
  end;

  { TGenerator }

  TGenerator = class

  private
    FCountingCount: LongInt;
    FCountingStart: LongInt;
    FPref: string;
    FRndDigits: Integer;
    FStopped:Boolean;
    FCodes: TStrings;
    FMD5: TStrings;
    FOwner:TObject;
    FInterfaceImplemented:Boolean;
    procedure SetCodes(AValue: TStrings);
    procedure SetCountingCount(AValue: LongInt);
    procedure SetCountingStart(AValue: LongInt);
    procedure SetMD5(AValue: TStrings);
    procedure SetPref(AValue: string);
    procedure SetRndDigits(AValue: Integer);

    procedure Generate(APref:string; AStart, ACount: LongInt; ARndDigits:integer);
    function GetRandomString(ADigits:integer):string;
  public
    procedure Start;
    procedure Stop;
    property Codes:TStrings read FCodes write SetCodes;
    property MD5:TStrings read FMD5 write SetMD5;

    property Pref:string read FPref write SetPref;
    property CountingStart:LongInt read FCountingStart write SetCountingStart;
    property CountingCount:LongInt read FCountingCount write SetCountingCount;
    property RndDigits: Integer read FRndDigits write SetRndDigits;

    constructor Create(Owner:TObject);
  end;

implementation

{ TGenerator }

procedure TGenerator.SetCodes(AValue: TStrings);
begin
  if FCodes=AValue then Exit;
  FCodes:=AValue;
end;

procedure TGenerator.SetCountingCount(AValue: LongInt);
begin
  if FCountingCount=AValue then Exit;
  FCountingCount:=AValue;
end;

procedure TGenerator.SetCountingStart(AValue: LongInt);
begin
  if FCountingStart=AValue then Exit;
  FCountingStart:=AValue;
end;

procedure TGenerator.SetMD5(AValue: TStrings);
begin
  if FMD5=AValue then Exit;
  FMD5:=AValue;
end;

function TGenerator.GetRandomString(ADigits: integer): string;
var
  i: Integer;
begin
  Result := '';
  for i:=1 to ADigits do begin
    Result := Result + inttostr(Random(10));
  end;
end;

procedure TGenerator.Start;
begin
  Generate(FPref, FCountingStart, FCountingCount, FRndDigits);
end;

procedure TGenerator.SetPref(AValue: string);
begin
  FPref:=trim(AValue);
end;

procedure TGenerator.SetRndDigits(AValue: Integer);
begin
  if FRndDigits=AValue then Exit;
  FRndDigits:=AValue;
end;

procedure TGenerator.Generate(APref: string; AStart, ACount: LongInt; ARndDigits: integer);
var
  i: LongInt;
  MaxDigits: String;
  CurCode: string;
  FrmStr: String;
  ProgressDelta: Integer;
begin
  FStopped:=false;

  if not Assigned(FCodes) then Raise Exception.Create('Property Codes is nil');
  if not Assigned(FMD5) then Raise Exception.Create('Property MD5 is nil');

  FCodes.Clear;
  FMD5.Clear;

  APref := Trim(APref);

  MaxDigits := IntToStr(AStart + ACount);
  FrmStr    := '%.'+IntToStr(Length(MaxDigits))+'d';
  ProgressDelta := 1000;

  for i:=AStart to AStart + ACount do begin

    CurCode := APref + Format(FrmStr, [i]) + GetRandomString(ARndDigits);

    Codes.Add(CurCode);
    MD5.Add( T3DES.GetMD5(CurCode) );

    if (i mod ProgressDelta = 0) then
       if FInterfaceImplemented then (FOwner AS IGeneratorEvents).OnProgressEvent(i, (i - AStart)*100 div (ACount), FStopped);

    if FStopped then Break;

  end;

end;

procedure TGenerator.Stop;
begin
  FStopped:=true;
end;

constructor TGenerator.Create(Owner: TObject);
begin
  inherited Create;
  FOwner := Owner;
  FInterfaceImplemented := FOwner.GetInterfaceEntryByStr(GeneratorID)<>NIL
end;

end.

