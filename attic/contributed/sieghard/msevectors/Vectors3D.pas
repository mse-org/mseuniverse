UNIT Vectors3D;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

INTERFACE
{ 2-dimensional vector operations

  Provides:
  0: Types
  - Floating point type for coercion with user type
  - Vector type of 3 dimensions, x, y and z
  1: Operators
  - Addition and Subtraction of 3-dimensional vectors
  - Scaiing - multiplication with scalar value
  - Scalar product
  - Comparison for equal and not-equal
  - Composition of a vector from an ARRAY OF integer
  2: Functions
  - Length of vector
  - Unit vector from arbitrary vector
  - Rotation of a vector about coordinate system axis
  - Angle between 2 vectors
  - Vector product of 2 vectors (cross product)
}
USES Math;

TYPE
{$ifndef float}
  float = real;
{$endif}
  component = (x, y, z);

  Vector3D = RECORD
               CASE boolean OF
                 true:  (x, y, z: float);
                 false: (c: ARRAY [0..2] OF float);
             END;

OPERATOR  +  (P1, P2: Vector3D): Vector3D; INLINE;
OPERATOR  -  (P1, P2: Vector3D): Vector3D; INLINE;
OPERATOR  =  (P1, P2: Vector3D): boolean;  INLINE;
OPERATOR <>  (P1, P2: Vector3D): boolean;  INLINE;
OPERATOR  *  (P1, P2: Vector3D): float;    INLINE;              // scalar product
OPERATOR  *  (scale: float; P: Vector3D): Vector3D; INLINE;     // scaling
OPERATOR  *  (P: Vector3D; scale: float): Vector3D; INLINE; OVERLOAD;
OPERATOR  /  (P: Vector3D; scale: float): Vector3D; INLINE;     // scaling
OPERATOR :=  (CONST inArray: ARRAY OF integer) P: Vector3D; INLINE;

FUNCTION length (P: Vector3D): float;
FUNCTION unitvector (P: Vector3D): Vector3D;
FUNCTION rotate_X (P: Vector3D; angle: float): Vector3D;        // rotate about x-axis
FUNCTION rotate_Y (P: Vector3D; angle: float): Vector3D;        // rotate about y-axis
FUNCTION rotate_Z (P: Vector3D; angle: float): Vector3D;        // rotate about z-axis
FUNCTION rotate (P: Vector3D; angle: float; axis: component): Vector3D; // rotate about axis
FUNCTION angle (P1, P2: Vector3D): float;
FUNCTION cross3D (P1, P2: Vector3D): Vector3D;                 // cross product


IMPLEMENTATION

// Arithhmetic operator overloading for Points should really exist:
OPERATOR + (P1, P2: Vector3D): Vector3D;
 BEGIN
   Result.x:= P1.x+ P2.x;
   Result.y:= P1.y+ P2.y;
   Result.z:= P1.z+ P2.z;
 END;

OPERATOR - (P1, P2: Vector3D): Vector3D;
 BEGIN
   Result.x:= P1.x- P2.x;
   Result.y:= P1.y- P2.y;
   Result.z:= P1.z- P2.z;
 END;

OPERATOR = (P1, P2: Vector3D): boolean;
 BEGIN
   Result:= (P1.x = P2.x) AND (P1.y = P2.y) AND (P1.z = P2.z);
 END;

OPERATOR <> (P1, P2: Vector3D): boolean;
 BEGIN
   Result:= (P1.x <> P2.x) OR (P1.y <> P2.y) OR (P1.z <> P2.z);
 END;

OPERATOR * (P1, P2: Vector3D): float;
 BEGIN
   Result:= (P1.x* P2.x)+ (P1.y* P2.y)+ (P1.y* P2.z);
 END;

OPERATOR * (scale: float; P: Vector3D): Vector3D;
 BEGIN
   Result.x:= P.x* scale; Result.y:= P.y* scale; Result.z:= P.z* scale;
 END;

OPERATOR * (P: Vector3D; scale: float): Vector3D;
 BEGIN
   Result.x:= P.x* scale; Result.y:= P.y* scale; Result.z:= P.z* scale;
 END;

OPERATOR / (P: Vector3D; scale: float): Vector3D;
 BEGIN
   Result.x:= P.x/ scale; Result.y:= P.y/ scale; Result.z:= P.z/ scale;
 END;

OPERATOR := (CONST inArray: ARRAY OF integer) P: Vector3D;
 BEGIN
   P.x:= inArray [0];
   P.y:= inArray [1];
   P.z:= inArray [2];
 END;


FUNCTION length (P: Vector3D): float;
 BEGIN
   length:= sqrt (P* P);
 END;

FUNCTION unitvector (P: Vector3D): Vector3D;
 BEGIN
   Result:= P/length (P);
 END;

FUNCTION rotate_X (P: Vector3D; angle: float): Vector3D;
 BEGIN
   Result:= rotate (P, angle, x);
 END;

FUNCTION rotate_Y (P: Vector3D; angle: float): Vector3D;
 BEGIN
   Result:= rotate (P, angle, y);
 END;

FUNCTION rotate_Z (P: Vector3D; angle: float): Vector3D;
 BEGIN
   Result:= rotate (P, angle, z);
 END;

FUNCTION rotate (P: Vector3D; angle: float; axis: component): Vector3D;
 VAR
   cosine: float;
 BEGIN
   cosine:= cos (angle); angle:= sin (angle);
   CASE axis OF
     x: BEGIN
         Result.y:= round (P.y* cosine+ P.z* angle);
         Result.z:= round (P.z* cosine- P.y* angle);
        END;
     y:BEGIN
         Result.x:= round (P.x* cosine+ P.z* angle);
         Result.z:= round (P.z* cosine- P.x* angle);
        END;
     z:BEGIN
         Result.x:= round (P.x* cosine+ P.y* angle);
         Result.y:= round (P.y* cosine- P.x* angle);
        END;
   END
 END;

FUNCTION angle (P1, P2: Vector3D): float;
 BEGIN
   Result:= arccos (unitvector (P1)* unitvector (P2));
 END;

FUNCTION cross3D (P1, P2: Vector3D): Vector3D;
 BEGIN
   Result.x:= P1.y* P2.z- P1.z* P2.y;
   Result.y:= P1.z* P2.x- P1.x* P2.z;
   Result.z:= P1.x* P2.y- P1.y* P2.x;
 END;

END.
