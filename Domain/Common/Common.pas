unit Common;

interface

uses
  SysUtils, Vcl.Mask, Vcl.StdCtrls, System.RegularExpressions;

function FloatToStr2(Valor: Double): string;
function StrToFloat2(MaskEdit: TMaskEdit): Double;
function ValidarInteiro(MaskEdit: TMaskEdit): Boolean;

implementation

function FloatToStr2(Valor: Double): string;
begin
  Result := FormatFloat('##,###,##0.00', Valor);
end;

function StrToFloat2(MaskEdit: TMaskEdit): Double;
var
  ValorStr: string;
begin
  ValorStr := StringReplace(MaskEdit.Text, ',', '.', [rfReplaceAll]);
  ValorStr := StringReplace(ValorStr, '.', '', [rfReplaceAll]);
  Result := (Abs(StrToFloatDef(ValorStr, 0))/100);
end;

function ValidarInteiro(MaskEdit: TMaskEdit): Boolean;
begin
  Result := TRegEx.IsMatch(MaskEdit.Text, '^[0-9]+$')
end;

end.
