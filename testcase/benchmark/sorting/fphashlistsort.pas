unit FPHashListSort;

{$mode objfpc}{$H-}

interface
uses
  Classes, SysUtils, Contnrs;

type
  TSortArray   = array of PShortString;

  TCompareFunc = function(const S1, S2: ShortString): SmallInt;
{ TCompareFunc = function(const S1, S2: String): Integer;  // alternativ für CompareStr/Text }

function CompareShortStringAnsiCharSensitive(const S1, S2 : ShortString): SmallInt; //inline;
function CompareShortStringAnsiCharInsensitive(const S1, S2 : ShortString) : SmallInt; //inline;
procedure QuickSortHashList({const HL: TFPHashList; }var SA : TSortArray; Compare: TCompareFunc);

implementation

{   Results:  S1 < S2  < 0
              S1 > S2  > 0                (proved, okay)
              S1 = S2  = 0     }


{function CompareShortStringAnsiCharSensitive(const S1, S2 : ShortString): SmallInt;
var                                         // simple, but too slow
  i, len : SmallInt;
begin
  if S1[0] > S2[0] then len := Byte(S2[0]) else len := Byte(S1[0]);
  i := 1;
  while (i < len) and (S1[i] = S2[i]) do inc(i);
  result := Byte(S1[i]) - Byte(S2[i]);      // now either i=len or S1[i]<>S2[i]
  if result = 0 then result := Byte(S1[0]) - Byte(S2[0]);
end;}

{$GOTO+}

function CompareShortStringAnsiCharSensitive(const S1, S2 : ShortString): SmallInt;
var
  i, len : SmallInt;                     // SmallInt are faster than Byte
label L1;
begin
  if Length(S1) > Length(S2) then len := Length(S2) else len := Length(S1);
  i := 1;                                // Length(S1) is coded same as Byte(S1[0])
  while i <= len do
  begin
    if (S1[i] = S2[i]) then inc(i)
    else begin
      result := Byte(S1[i]) - Byte(S2[i]);
      goto L1;                           // Label is faster than Break
    end;
  end;
  result := Length(S1) - Length(S2);     // only reached if all matched and i > len
  L1:
end;

function CompareShortStringAnsiCharInsensitive(const S1, S2 : ShortString) : SmallInt;
var
  i, len, B1, B2 : Byte;           // all Byte are faster than i & len as SmallInt
label L2;
begin
  if Length(S1) > Length(S2) then len := Length(S2) else len := Length(S1);
  i := 1;                          // Length(S1) is as fast as Byte(S1[0])
  while i <= len do
  begin
    B1 := Byte(S1[i]);             // must have copies to modify, because S1/S2 are consts
    B2 := Byte(S2[i]);             // doing it here accelerates first-char-mismatch and
    if B1 = B2 then inc(i)         // different case matches
    else begin
      if B1 in [97..122] then dec(B1, 32);
      if B2 in [97..122] then dec(B2, 32);
      if B1 = B2 then inc(i)       // sensitivity match
      else begin
        result := B1 - B2;         // mismatch inside of the strings
        goto L2;                   // Label is faster than Break
      end;
    end;
  end;
  result := Length(S1) - Length(S2);   // only reached if all matched and i > len
  L2:
end;

{function CompareShortStringAnsiCharInsensitive(const S1, S2 : ShortString) : SmallInt;
var                                 // fast on the long run, but slow at early breaks
  B1, B2 : Byte;                    // okay: not better than above even on the long run
  P1, P2, P1Last : PByte;
begin
  P1 := @S1;
  P2 := @S2;
  if P1^ > P2^ then P1Last := P1 + P2^ else P1Last := P1 + P1^;
  result := 0;
  inc(P1);
  inc(P2);
  while P1 < P1Last do
  begin
    if P1^ = P2^ then begin inc(P1); inc(P2); end
    else begin
      B1 := P1^;
      B2 := P2^;
      if B1 in [97..122] then dec(B1, 32);
      if B2 in [97..122] then dec(B2, 32);
      if B1 = B2 then begin inc(P1); inc(P2); end
      else begin
        result := B1 - B2;
        break;
      end;
    end;
  end;
  if result = 0 then result := Byte(S1[0]) - Byte(S2[0]);
end;}

procedure QuickSortHashList({const HL: TFPHashList;} var SA : TSortArray; Compare: TCompareFunc);
//var
//  n : integer;

  {Sub-}
  procedure DoQuickSort(L, R: integer);
  var
    I, J, P        : Integer;
    tmp, PivotItem : PShortString;
  begin
    repeat
      I := L;
      J := R;
      P := (L + R) div 2;
      repeat
        PivotItem := SA[P];
        while Compare(PivotItem^, SA[I]^) > 0 do Inc(I);
        while Compare(PivotItem^, SA[J]^) < 0 do Dec(J);
        if I <= J then
        begin
          tmp := SA[i];
          SA[I] := SA[J];
          SA[J] := tmp;
          if P = I then
            P := J
          else if P = J then
            P := I;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        DoQuickSort(L, J);
      L := I;
    until I >= R;
  end;
  {/Subprocedure DoQuickSort}

{main QuickSortHashList}
begin
{
  if not Assigned(HL) or not Assigned (Compare) then exit;
  SetLength(SA, HL.Count);
  for n := 0 to HL.Count - 1 do SA[n] := PShortString(@HL.Strs[HL.List^[n].StrIndex]);
  if (HL.Count < 2) then exit;                  // Anordnung wg. Sonderfall Count=1
  DoQuickSort(0, HL.Count-1);
}
 if length(sa) > 1 then begin
  doquicksort(0,high(sa));
 end;
end;

end.

