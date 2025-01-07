PROGRAM MatrixTest;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

USES
  SysUtils, Math, Tensors;

VAR
  i, j: integer;
  V1, V2, V3: Vector;
  M1, M2, M3: Matrix;

PROCEDURE WriteVector (V: Vector);
 BEGIN
   Write ('(');
   FOR i:= 0 TO high (V) DO
     Write (' ', V [i]: 0: 3);
   WriteLn (' )');
 END;

PROCEDURE WriteMatrix (M: Matrix);
 VAR
   b, e: char;
 BEGIN
   b:= '/'; e:= '\';
   FOR i:= 0 TO high (M) DO BEGIN
     IF i = 1 THEN BEGIN
        b:= '|'; e:= '|';
     END;
     IF i = high (M) THEN BEGIN
       b:= '\'; e:= '/';
     END;
     Write (b);
     FOR j:= 0 TO high (M [i]) DO
       Write (' ', M [i, j]: 0: 3);

     WriteLn (' ', e);
   END;
 END;

BEGIN
  newVector (V1, 5); newVector (V2, 3); newVector (V3, 4);
//  V1:= newVector (5); V2:= newVector (3); V3:= newVector (4);
  WriteLn ('Vector dimensions: V1 ', dimension (V1), ', V2 ', dimension (V2), ', V3 ', dimension (V3));
  Write ('V1: '); WriteVector (V1);
  Write ('V2: '); WriteVector (V2);
  Write ('V3: '); WriteVector (V3);
  WriteLn;
//  newMatrix (M1, 2, 3); newMatrix (M2, 3, 4); newMatrix (M3, 4, 2);
  M1:= newMatrix (2, 3); M2:= newMatrix (3, 4); M3:= newMatrix (4, 2);
  WriteLn ('Matrix dimensions: M1 ', rows (M1),  ' ', columns (M1), ', M2 ', rows (M2), ' ', columns (M2), ' , M3 ', rows (m3), ' ', columns (M3));
  WriteMatrix (M1); WriteMatrix (M2); WriteMatrix (M3);
  TRY
    WriteLn ('Trace values: : M1 ', trace (M1): 0: 3, ', M2 ', trace (M2): 0: 3, ' , M3 ', trace (M3): 0: 3);
  EXCEPT
    ON E: Exception DO
      WriteLn ('Error at trace evaluation: ', E.Message);
  END;
  WriteLn;
  unitMatrix (M1, 2); unitMatrix (M2, 4); unitMatrix (M3, 3);
//  M1:= unitMatrix (2); M2:= unitMatrix (4); M3:= unitMatrix (3);
  WriteLn ('Matrix dimensions: M1 ', rows (M1),  ' ', columns (M1), ', M2 ', rows (M2), ' ', columns (M2), ' , M3 ', rows (m3), ' ', columns (M3));
  WriteMatrix (M1); WriteMatrix (M2); WriteMatrix (M3);
  WriteLn ('Trace values: : M1 ', trace (M1): 0: 3, ', M2 ', trace (M2): 0: 3, ' , M3 ', trace (M3): 0: 3);
  WriteLn;
  V1:= [1.5, 0.0, 0.0]; V2:= [0.0, 0.0, 2.7]; V3:= [0.0, 1.6, 1.2];
  WriteLn ('Vector dimensions: V1 ', dimension (V1), ', V2 ', dimension (V2), ', V3 ', dimension (V3));
  Write ('V1: '); WriteVector (V1);
  Write ('V2: '); WriteVector (V2);
  Write ('V3: '); WriteVector (V3);
  Write ('V1+ V2: '); WriteVector (V1+ V2);
  Write ('V2- V3: '); WriteVector (V2- V3);
  Write ('V1- V2+ V3: '); WriteVector (V1- V2+ V3);
  WriteLn ('Lengths: V1 ', length (V1): 0: 3, ', V2 ', length (V2): 0: 3, ', V3: ', length (V3): 0: 3);
  WriteLn ('Unit vectors:');
  Write ('unitvector (V1): '); WriteVector (unitvector (V1));
  Write ('unitvector (V2): '); WriteVector (unitvector (V2));
  Write ('unitvector (V3): '); WriteVector (unitvector (V3));
  WriteLn ('Lengths: V1 ', length (V1): 0: 3, ', V2 ', length (V2): 0: 3, ', V3: ', length (V3): 0: 3);
  WriteLn ('Angles, between V1 & V2: ', radtodeg (angle (V1, V2)): 0: 1, '°, V1 & V3: ', radtodeg (angle (V1, V3)): 0: 1, '°, V2 & V3: ', radtodeg (angle (V2, V3)): 0: 1, '°');
  WriteLn;
  M1:= [[1, 4, 5], [2, 3, 6]];
  M2:= [[1, 7, 2, 6], [2, 8, 1, 5], [3, 9, 0, 4]];
{
/ 1.000 4.000 5.000 \   / 1.000 7.000 2.000 6.000 \    / 24.000, 26.000 \
\ 2.000 3.000 6.000 / + | 2.000 8.000 1.000 5.000 | 0> | 84.000, 92.000 |
                        \ 3.000 9.000 0.000 4.000 /    |  6.000,  7.000 |
                                                       \ 46.000, 51.000 /
}
  WriteLn ('Matrix dimensions: M1 ', rows (M1),  ' ', columns (M1), ', M2 ', rows (M2), ' ', columns (M2), ' , M3 ', rows (m3), ' ', columns (M3));
  WriteMatrix (M1); WriteMatrix (M2);
  M3:= M1* M2;
  WriteLn ('M3 = M1* M2:');
  WriteMatrix (M3);
  WriteLn ('M1 transposed:');
  WriteMatrix (transposed (M1));
  WriteLn ('M2 transposed:');
  WriteMatrix (transposed (M2));
  WriteLn ('M3^T = M2^T* M1^T:');
  M3:= transposed (M2)* transposed (M1);
  WriteMatrix (M3);
  WriteLn ('M3 columns (', columns (M3), '):');
  FOR j:= 0 TO pred (columns (M3)) DO BEGIN
    Write ('M3 [', j, ']: '); WriteVector (column (M3, j));
  END;
  WriteLn;
  V3:= [1.0, 3.3, 2.1, 4.5];
  Write ('V3: '); WriteVector (V3);
  Write ('V1* M2 :  '); WriteVector (V1* M2);
  Write ('M2^T* V1 :'); WriteVector (transposed (M2)* V1);
  Write ('M2* V3 :  '); WriteVector (M2* V3);
  Write ('V3* M2^T :'); WriteVector (V3* transposed (M2));
  WriteLn ('V1* M2* V3: ', V1* M2* V3: 0: 3);
  Write ('V1* M2* M^T* V2: ', V1* M2* transposed (M2)* V2: 0: 3);
  WriteLn;
END.
