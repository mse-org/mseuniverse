UNIT Tensors;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

INTERFACE
{ General tensor operations - vectors and matrices

  Provides:
  0: Types
  - Floating point type for coercion with user type
  - Vector type of arbitrary dimension
  - Matrix (tensor) type of arbitrary dimensions in rectangular array
  1: Operators
  - Addition and Subtraction of vectors and matrices
  - Scaiing - multiplication and division with a scalar value
  - Scalar product
  - Matrix multiplication with compatibility checking
    - Matrix * Matrix
    - Martix + Vector and Vector * Matrix
  2: Functions
  - Length of vector
  - Unit vector from arbitrary vector
  - angle between vectors of equal dimension
  - unit matrix
  - matrix transposition
  - trace of square matrix
  - plus some convenience functions and procedures
    - vector and matrix construction
    - dimension of a vector
    - number of rows and columns of a matrix
    - row and column vector of a matrix
}
USES SysUtils, Math;

TYPE
{$ifndef float}
  float = real;
{$endif}
  Vector = ARRAY OF float;              // arbitrary dimension
  Matrix = ARRAY OF ARRAY OF float;     // 2 arbitrary dimensions - 1st index: row, 2nd index: column

// Vector operations
OPERATOR + (P1, P2: Vector): Vector;
OPERATOR - (P1, P2: Vector): Vector;
OPERATOR * (P1, P2: Vector): float;                         // scalar product
OPERATOR * (scale: float; P: Vector): Vector;               // scaling
OPERATOR * (P: Vector; scale: float): Vector; OVERLOAD;
OPERATOR / (P: Vector; scale: float): Vector;               // scaling

FUNCTION  newVector (dim: integer): Vector;                 // Construct vector of dimension "dim"
PROCEDURE newVector (OUT P: Vector; dim: integer);          // Construct vector of dimension "dim"

FUNCTION dimension (P: Vector): integer;                    // Return vector dimension, i.e. number of elements

FUNCTION length (P: Vector): float;
FUNCTION unitvector (P: Vector): Vector;
FUNCTION angle (P1, P2: Vector): float;

// Matrix operations
OPERATOR + (M1, M2: Matrix): Matrix;
OPERATOR - (M1, M2: Matrix): Matrix;
OPERATOR * (M1, M2: Matrix): Matrix;
OPERATOR * (scale: float; M: Matrix): Matrix;               // scaling
OPERATOR * (M: Matrix; scale: float): Matrix; OVERLOAD;
OPERATOR / (M: Matrix; scale: float): Matrix;               // scaling

FUNCTION  newMatrix (nrows, ncols: integer): Matrix;        // Construct matrix with of size "rows" x "cols"
FUNCTION  unitMatrix (dim: integer): Matrix;                // Construct square matrix with main diagonal elements set to 1
PROCEDURE newMatrix (OUT M: Matrix; nrows, ncols: integer); // Construct matrix with of size "rows" x "cols"
PROCEDURE unitMatrix (OUT M: Matrix; dim: integer);         // Construct square matrix with main diagonal elements set to 1

FUNCTION rows (M: Matrix): integer;    INLINE;
FUNCTION columns (M: Matrix): integer; INLINE;

FUNCTION row (M: Matrix; r: integer): Vector; INLINE;       // Return row vector
FUNCTION column (M: Matrix; col: integer): Vector;          // Return column vector
FUNCTION transposed (M: Matrix): Matrix;
FUNCTION trace (M: Matrix): float;                          // Matrix trace: sum of main diagonal elements. Square matrices only!
// FUNCTION determinant (M: Matrix): float;

// Mixed matrix / vector operations
OPERATOR * (P: Vector; M: Matrix): Vector;
OPERATOR * (M: Matrix; P: Vector): Vector;

IMPLEMENTATION


CONST
  VectorComplianceError = 'Vectors not same size!';
  MatrixSizeError =       'Matrices not same size!';
  MatrixNotSquareError =  'Matrix not square!';
  MatrixComplianceError = 'Matrices not compliant!';
  MixedComplianceError =  'Vector not compliant w/ matrix!';

// Vector operations

PROCEDURE checkVectors (P1, P2: Vector);
 BEGIN
   IF high (P1) <> high (P2) THEN
   // Incomatible dimensions, raise compliance exception
     Raise Exception.Create (VectorComplianceError) AT
         get_caller_addr (get_frame), get_caller_frame (get_frame);
 END;


OPERATOR + (P1, P2: Vector): Vector;
 VAR
   i: integer;
 BEGIN
   checkVectors (P1, P2);
   Result:= newVector (dimension (P1));
   FOR i:= 0 TO high (P1) DO
     Result [i]:= P1 [i]+ P2 [i];
 END;

OPERATOR - (P1, P2: Vector): Vector;
 VAR
   i: integer;
 BEGIN
   checkVectors (P1, P2);
   Result:= newVector (dimension (P1));
   FOR i:= 0 TO high (P1) DO
     Result [i]:= P1 [i]- P2 [i];
 END;

OPERATOR * (P1, P2: Vector): float;
 VAR
   i: integer;
 BEGIN
   checkVectors (P1, P2);
   Result:= 0.0;
   FOR i:= 0 TO high (P1) DO
     Result:= Result+ (P1 [i]* P2 [i]);
 END;

OPERATOR * (scale: float; P: Vector): Vector;
 VAR
   i: integer;
 BEGIN
   Result:= newVector (dimension (P));
   FOR i:= 0 TO high (P) DO
     Result [i]:= P [i]* scale;
 END;

OPERATOR * (P: Vector; scale: float): Vector;
 VAR
   i: integer;
 BEGIN
   Result:= newVector (dimension (P));
   FOR i:= 0 TO high (P) DO
     Result [i]:= P [i]* scale;
 END;

OPERATOR / (P: Vector; scale: float): Vector;
 VAR
   i: integer;
 BEGIN
   Result:= newVector (dimension (P));
   FOR i:= 0 TO high (P) DO
     Result [i]:= P [i]/scale;
 END;


FUNCTION newVector (dim: integer): Vector;
 BEGIN
   SetLength (newVector, dim);
 END;

PROCEDURE newVector (OUT P: Vector; dim: integer);
 BEGIN
   SetLength (P, dim);
 END;


FUNCTION dimension (P: Vector): integer;
 BEGIN
   dimension:= System.Length (P);
 END;

FUNCTION length (P: Vector): float;
 BEGIN
   length:= sqrt (P* P);
 END;

FUNCTION unitvector (P: Vector): Vector;
 BEGIN
   unitvector:= Copy (P, 0, dimension (P))/length (P);
 END;

FUNCTION angle (P1, P2: Vector): float;
 BEGIN
   checkVectors (P1, P2);
   angle:= arccos (unitvector (P1)* unitvector (P2));
 END;


// Matrix operations

FUNCTION rows (M: Matrix): integer; INLINE;
 BEGIN
   rows:= System.Length (M);
 END;

FUNCTION columns (M: Matrix): integer; INLINE;
 BEGIN
   columns:= System.Length (M [0]);
 END;


PROCEDURE checkMatrices (M1, M2: Matrix);
 BEGIN
   IF (rows (M1) <> rows (M2)) OR (columns (M1) <> columns (M2)) THEN
   // Incomatible dimensions, raise compliance exception
     Raise Exception.Create (MatrixSizeError) AT
         get_caller_addr (get_frame), get_caller_frame (get_frame);
 END;

PROCEDURE checkMatrixCompliance (M1, M2: Matrix);
 BEGIN
   IF columns (M1) <> rows (M2) THEN
   // Incomatible dimensions, raise compliance exception
     Raise Exception.Create (MatrixComplianceError) AT
         get_caller_addr (get_frame), get_caller_frame (get_frame);
 END;

PROCEDURE checkSquareMatrix (M: Matrix);
 BEGIN
   IF rows (M) <> columns (M) THEN
   // Matrix not square, raise compliance exception
     Raise Exception.Create (MatrixNotSquareError) AT
         get_caller_addr (get_frame), get_caller_frame (get_frame);
 END;


FUNCTION row (M: Matrix; r: integer): Vector; INLINE;
 BEGIN
   row:= M [r];
 END;

FUNCTION column (M: Matrix; col: integer): Vector;
 VAR
   i: integer;
 BEGIN
   SetLength (column, rows (M));
   FOR i:= 0 TO high (M) DO
     column [i]:= M [i, col];
 END;


OPERATOR + (M1, M2: Matrix): Matrix;
 VAR
   i: integer;
 BEGIN
   checkMatrices (M1, M2);
   FOR i:= 0 TO high (M1) DO
     M1 [i]:= M1 [i]+ M2 [i];
   Result:= M1;
 END;

OPERATOR - (M1, M2: Matrix): Matrix;
 VAR
   i: integer;
 BEGIN
   checkMatrices (M1, M2);
   FOR i:= 0 TO high (M1) DO
     M1 [i]:= M1 [i]- M2 [i];
   Result:= M1;
 END;

OPERATOR * (scale: float; M: Matrix): Matrix;
 VAR
   i: integer;
 BEGIN
   FOR i:= 0 TO high (M) DO
     M [i]:= M [i]* scale;
  Result:= M;
 END;

OPERATOR * (M: Matrix; scale: float): Matrix;
 VAR
   i: integer;
 BEGIN
   FOR i:= 0 TO high (M) DO
     M [i]:= M [i]* scale;
  Result:= M;
 END;

OPERATOR / (M: Matrix; scale: float): Matrix;
 VAR
   i: integer;
 BEGIN
   FOR i:= 0 TO high (M) DO
     M [i]:= M [i]/scale;
  Result:= M;
 END;

OPERATOR * (M1, M2: Matrix): Matrix;
 VAR
   i, j: integer;
 BEGIN
   checkMatrixCompliance (M1, M2);
   SetLength (Result, columns (M2), rows (M1));
   FOR i:= 0 TO high (M1) DO
     FOR j:= 0 TO high (M2 [0]) DO
       Result [j, i]:= row (M1, i)* column (M2, j);
 END;


FUNCTION newMatrix (nrows, ncols: integer): Matrix;
 BEGIN
   SetLength (newMatrix, nrows, ncols);
 END;

FUNCTION unitMatrix (dim: integer): Matrix;
 VAR
   i: integer;
 BEGIN
   SetLength (unitMatrix, dim, dim);
   FOR i:= 0 TO high (unitMatrix) DO
     unitMatrix [i, i]:= 1.0;
 END;

PROCEDURE newMatrix (OUT M: Matrix; nrows, ncols: integer);
 BEGIN
   SetLength (M, nrows, ncols);
 END;

PROCEDURE unitMatrix (OUT M: Matrix; dim: integer);
 VAR
   i: integer;
 BEGIN
   SetLength (M, dim, dim);
   FOR i:= 0 TO high (M) DO
     M [i, i]:= 1.0;
 END;


FUNCTION transposed (M: Matrix): Matrix;
 VAR
   i: integer;
 BEGIN
   SetLength (transposed, columns (M));
   FOR i:= 0 TO high (transposed) DO
     transposed [i]:= column (M, i);
 END;

FUNCTION trace (M: Matrix): float;
 VAR
   i: integer;
 BEGIN
   checkSquareMatrix (M);
   trace:= 0;
   FOR i:= 0 TO high (M) DO
     trace:= trace+ M [i, i];
 END;
(*
FUNCTION determinant (M: Matrix): float;
 VAR
   i, j: integer;
 BEGIN
   checkSquareMatrix (M);
   Result:= 0;
   FOR i:= 0 TO rows (M) DO
     FOR j:= 0 TO columns (M) DO
       Result:= Result+ ...;
 END;
*)

// Mixed matrix / vector operations

PROCEDURE checkMixedCompliance (P: Vector; sM: integer);
 BEGIN
   IF dimension (P) <> sM THEN
   // Incomatible dimensions, raise compliance exception
     Raise Exception.Create (MixedComplianceError) AT
         get_caller_addr (get_frame), get_caller_frame (get_frame);
 END;


OPERATOR * (P: Vector; M: Matrix): Vector;
 VAR
   i: integer;
 BEGIN
   checkMixedCompliance (P, rows (M));
   SetLength (Result, columns (M));
   FOR i:= 0 TO high (M [0]) DO
     Result [i]:= P* column (M, i);
 END;

OPERATOR * (M: Matrix; P: Vector): Vector;
 VAR
   i: integer;
 BEGIN
   checkMixedCompliance (P, columns (M));
   SetLength (Result, rows (M));
   FOR i:= 0 TO high (M) DO
     Result [i]:= row (M, i)* P;
 END;

END.
