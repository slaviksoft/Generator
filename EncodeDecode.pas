unit EncodeDecode;

interface

uses
  SysUtils, synacrypt, synacode;

type

  T3DES = class
  private
    class function HexToAnsi(Hex: AnsiString): AnsiString;
    class function AnsiToHex(Text:AnsiString):AnsiString;
    class function PanBlock64bit(PAN:AnsiString):AnsiString;
    class function AnsiXOR(Str1, Str2: AnsiString):AnsiString;
  public
    class function Decode(CardNumber, Code3DES: AnsiString):AnsiString;
    class function GetMD5(AText:AnsiString):AnsiString;
  end;

implementation

  { T3DES }

class function T3DES.HexToAnsi(Hex: AnsiString): AnsiString;
var
  Len: Integer;
  K:   Integer;
  Num: Byte;
begin
  Result := '';
  Len := Length(Hex);
  K := 1;
  while K < len do begin
    Num := StrToInt('$'+Copy(Hex, K, 2));
    Result := Result + AnsiChar(Num);
    K := K + 2;
  end;

end;

class function T3DES.PanBlock64bit(PAN: AnsiString): AnsiString;
var
  PanLen: Integer;
begin
  PanLen := Length(PAN);
  Result := '0'+IntToHex(PanLen,1);
  Result := Result + PAN;

  while length(Result) < 16 do Result := Result + 'F';

end;

class function T3DES.AnsiToHex(Text: AnsiString): AnsiString;
var
  k: Integer;
begin
  Result := '';
  for k := 1 to Length(Text) do Result := Result + IntToHex( Ord(Text[K]), 2 );

end;

class function T3DES.AnsiXOR(Str1, Str2: AnsiString): AnsiString;
var
  i: Integer;
  B1, B2, B3: Byte;
begin
  Result := '';
  for i := 1 to Length(Str1) do begin
    B1 := Ord(Str1[i]);
    B2 := Ord(Str2[i]);
    B3 := B1 XOR B2;

    Result := Result + AnsiChar( B3 );
  end;

  i := 1;

end;

class function T3DES.Decode(CardNumber, Code3DES: AnsiString): AnsiString;
var
  KeyBlockA, KeyGlobal: AnsiString;
  CardMask, CardPan, BlockA, BlockB: AnsiString;
  BlockEncoded, BlockDecoded, MaskPin: AnsiString;
  Crypto: TSyna3Des;
  Len: Integer;

begin

  KeyBlockA := HexToAnsi('63A80CEF3450DBC13039A165C41DA988');
  KeyGlobal := HexToAnsi('8ED7664D4D1107019A07E9D948D9892D');

  CardMask := Copy(CardNumber, 7, length(CardNumber)-4-7+1);
  CardPan  := HexToAnsi( PanBlock64bit(CardMask) );

  Crypto  := TSyna3Des.Create(KeyBlockA);
  BlockA := Crypto.EncryptECB(CardPan);
  Crypto.Free;

  BlockEncoded := HexToAnsi(Code3DES);

  Crypto := TSyna3Des.Create(KeyGlobal);
  BlockDecoded := Crypto.DecryptECB(BlockEncoded);
  Crypto.Free;

  BlockB := AnsiXOR(BlockDecoded, BlockA);
  MaskPin := AnsiToHex(BlockB);

  Len := StrToInt('$'+MaskPin[2]);
  Result := Copy(MaskPin, 3, Len);

  Result := Result;

end;

class function T3DES.GetMD5(AText: AnsiString): AnsiString;
var
  Tmp: AnsiString;
begin
  Tmp := MD5(AText);
  Result := AnsiToHex( tmp );
end;


end.
