UNIT Vectors2D;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

INTERFACE
{ 2-dimensional vector operations

  Provides:
  0: Types
  - Floating point type for coercion with user type
  - Vector type of 2 dimensions, x and y
  1: Operators
  - Addition and Subtraction of 2-dimensional vectors
  - Scaiing - multiplication and division with scalar value
  - Scalar product
  - Comparison for equal and not-equal
  - Composition of a vector from an ARRAY OF integer
  2: Functions
  - Length of vector
  - Unit vector from arbitrary vector
  - Rotation of a vector
  - Angle between 2 vectors
}
USES Math;

TYPE
{$ifndef float}
  float = real;
{$endif}
  Vector2D = RECORD
               CASE boolean OF
                 true:  (x, y: float);
                 false: (c: ARRAY [0..1] OF float);
             END;

OPERATOR  +  (P1, P2: Vector2D): Vector2D; INLINE;
OPERATOR  -  (P1, P2: Vector2D): Vector2D; INLINE;
OPERATOR  =  (P1, P2: Vector2D): boolean;  INLINE;
OPERATOR <>  (P1, P2: Vector2D): boolean;  INLINE;
OPERATOR  *  (P1, P2: Vector2D): float;    INLINE;              // scalar product
OPERATOR  *  (scale: float; P: Vector2D): Vector2D; INLINE;     // scaling
OPERATOR  *  (P: Vector2D; scale: float): Vector2D; INLINE; OVERLOAD;
OPERATOR  /  (P: Vector2D; scale: float): Vector2D; INLINE;     // scaling
OPERATOR :=  (CONST inArray: ARRAY OF integer) P: Vector2D; INLINE;

FUNCTION length (P: Vector2D): float;
FUNCTION unitvector (P: Vector2D): Vector2D;
FUNCTION rotate (P: Vector2D; angle: float): Vector2D;
FUNCTION angle (P1, P2: Vector2D): float;


IMPLEMENTATION

// Arithhmetic operator overloading for Points should really exist:
OPERATOR + (P1, P2: Vector2D): Vector2D;
 BEGIN
   Result.x:= P1.x+ P2.x;
   Result.y:= P1.y+ P2.y;
 END;

OPERATOR - (P1, P2: Vector2D): Vector2D;
 BEGIN
   Result.x:= P1.x- P2.x;
   Result.y:= P1.y- P2.y;
 END;

OPERATOR = (P1, P2: Vector2D): boolean;
 BEGIN
   Result:= (P1.x = P2.x) AND (P1.y = P2.y);
 END;

OPERATOR <> (P1, P2: Vector2D): boolean;
 BEGIN
   Result:= (P1.x <> P2.x) OR (P1.y <> P2.y);
 END;

OPERATOR * (P1, P2: Vector2D): float;
 BEGIN
   Result:= (P1.x* P2.x)+ (P1.y* P2.y);
 END;

OPERATOR * (scale: float; P: Vector2D): Vector2D;
 BEGIN
   Result.x:= P.x* scale; Result.y:= P.y* scale;
 END;

OPERATOR * (P: Vector2D; scale: float): Vector2D;
 BEGIN
   Result.x:= P.x* scale; Result.y:= P.y* scale;
 END;

OPERATOR / (P: Vector2D; scale: float): Vector2D;
 BEGIN
   Result.x:= P.x/ scale; Result.y:= P.y/ scale;
 END;

OPERATOR := (CONST inArray: ARRAY OF integer) P: Vector2D;
 BEGIN
   P.x:= inArray [0];
   P.y:= inArray [1];
 END;


FUNCTION length (P: Vector2D): float;
 BEGIN
   length:= sqrt (P* P);
 END;

FUNCTION unitvector (P: Vector2D): Vector2D;
 BEGIN
   Result:= P/length (P);
 END;

FUNCTION rotate (P: Vector2D; angle: float): Vector2D;
 VAR
   cosine: float;
 BEGIN
   cosine:= cos (angle); angle:= sin (angle);
   Result.x:= round (P.x* cosine+ P.y* angle);
   Result.y:= round (P.y* cosine- P.x* angle);
 END;

FUNCTION angle (P1, P2: Vector2D): float;
 BEGIN
   Result:= arccos (unitvector (P1)* unitvector (P2));
 END;

END.
