; perlin noise
; taken from http://www.forums.purebasic.com/english/viewtopic.php?f=12&t=41553

#B  = $100
#BM = $ff
#N  = $1000
#NP = 12   ;  2^N
#NM = $fff

Structure InnerDoubleArray
  d.d[0]
EndStructure

Macro Unsigned(value)
  ((value) + 1) / 2
EndMacro
Macro s_curve(t)
  ( t * t * ( 3 - 2 * t ) )
EndMacro
Macro lerp(t, a, b) 
  ( a + t * (b - a) )
EndMacro
Macro setup(i,b0,b1,r0,r1)
  t  = vec(i) + #N
  b0 = Int(t) & #BM
  b1 = (b0 + 1) & #BM
  r0 = t - Int(t)
  r1 = r0 - 1.
EndMacro
Macro at2(rx,ry) 
  ( rx * *q\d[0] + ry * *q\d[1] )
EndMacro
Macro at3(rx,ry,rz) 
  ( rx * *q\d[0] + ry * *q\d[1] + rz * *q\d[2] )
EndMacro

Declare   perlinInit()
Declare.d noise1(arg.d)
Declare.d noise2(Array vec.d(1))
Declare.d noise3(Array vec.d(1))
Declare   normalize2(d.i)
Declare   normalize3(d.i)

Declare.d PerlinNoise1D(x.d, alpha.d, beta.d, n.i);
Declare.d PerlinNoise2D(x.d, y.d, alpha.d, beta.d, n.i);
Declare.d PerlinNoise3D(x.d, y.d, z.d, alpha.d, beta.d, n.i);

Global Dim  p.i(#B + #B + 1)
Global Dim g1.d(#B + #B + 1)
Global Dim g2.d(#B + #B + 1, 1)
Global Dim g3.d(#B + #B + 1, 2)
Global start.i = 1

Procedure.d noise1(arg.d)
  Protected bx0.i, bx1.i
  Protected rx0.d, rx1.d, sx.d, t.d, u.d, v.d
  Dim vec.d(1)
  
  vec(0) = arg
  If start
    start = 0
    perlinInit()
  EndIf
  
  setup(0,bx0,bx1,rx0,rx1)
  
  sx = s_curve(rx0)
  u = rx0 * g1( p( bx0 ) )
  v = rx1 * g1( p( bx1 ) )
  
  ProcedureReturn lerp(sx, u, v)
EndProcedure

Procedure.d noise2(Array vec.d(1))
  Protected bx0.i, bx1.i, by0.i, by1.i, b00.i, b10.i, b01.i, b11.i
  Protected rx0.d, rx1.d, ry0.d, ry1.d, *q.InnerDoubleArray, sx.d, sy.d, a.d, b.d, t.d, u.d, v.d
  Protected i.i, j.i
  
  If start
    start = 0
    perlinInit()
  EndIf
  
  setup(0, bx0,bx1, rx0,rx1)
  setup(1, by0,by1, ry0,ry1)
  
  i = p( bx0 )
  j = p( bx1 )
  
  b00 = p( i + by0 )
  b10 = p( j + by0 )
  b01 = p( i + by1 )
  b11 = p( j + by1 )
  
  sx = s_curve(rx0)
  sy = s_curve(ry0)
  
  *q = @g2( b00, 0 ) : u = at2(rx0,ry0)
  *q = @g2( b10, 0 ) : v = at2(rx1,ry0)
  a  = lerp(sx, u, v)
  
  *q = @g2( b01, 0 ) : u = at2(rx0,ry1)
  *q = @g2( b11, 0 ) : v = at2(rx1,ry1)
  b = lerp(sx, u, v)
  
  Protected rv.d = lerp(sy, a, b)
  ProcedureReturn rv
EndProcedure

Procedure.d noise3(Array vec.d(1))
  Protected bx0.i, bx1.i, by0.i, by1.i, bz0.i, bz1.i, b00.i, b10.i, b01.i, b11.i
  Protected rx0.d, rx1.d, ry0.d, ry1.d, rz0.d, rz1.d, *q.InnerDoubleArray, sy.d, sz.d, a.d, b.d, c.d, d.d, t.d, u.d, v.d
  Protected i.i, j.i
  
  If (start)
    start = 0
    perlinInit()
  EndIf
  
  setup(0, bx0,bx1, rx0,rx1);
  setup(1, by0,by1, ry0,ry1);
  setup(2, bz0,bz1, rz0,rz1);
  
  i = p( bx0 )
  j = p( bx1 )
  
  b00 = p( i + by0 )
  b10 = p( j + by0 )
  b01 = p( i + by1 )
  b11 = p( j + by1 )
  
  t  = s_curve(rx0)
  sy = s_curve(ry0)
  sz = s_curve(rz0)
  
  *q = @g3( b00 + bz0, 0 ) : u = at3(rx0,ry0,rz0)
  *q = @g3( b10 + bz0, 0 ) : v = at3(rx1,ry0,rz0)
  a = lerp(t, u, v)
  
  *q = @g3( b01 + bz0, 0 ) : u = at3(rx0,ry1,rz0);
  *q = @g3( b11 + bz0, 0 ) : v = at3(rx1,ry1,rz0);
  b = lerp(t, u, v)                              ;
  
  c = lerp(sy, a, b);
  
  *q = @g3( b00 + bz1, 0 ) : u = at3(rx0,ry0,rz1);
  *q = @g3( b10 + bz1, 0 ) : v = at3(rx1,ry0,rz1);
  a = lerp(t, u, v)                              ;
  
  *q = @g3( b01 + bz1, 0 ) : u = at3(rx0,ry1,rz1);
  *q = @g3( b11 + bz1, 0 ) : v = at3(rx1,ry1,rz1);
  b = lerp(t, u, v)                              ;
  
  d = lerp(sy, a, b);
  
  ProcedureReturn lerp(sz, c, d);
EndProcedure

Procedure normalize2(*v.InnerDoubleArray)
  Protected s.d = Sqr(*v\d[0] * *v\d[0] + *v\d[1] * *v\d[1])
  
  *v\d[0] = *v\d[0] / s
  *v\d[1] = *v\d[1] / s
EndProcedure

Procedure normalize3(*v.InnerDoubleArray)
  Protected s.d = Sqr(*v\d[0] * *v\d[0] + *v\d[1] * *v\d[1] + *v\d[2] * *v\d[2])
  
  *v\d[0] = *v\d[0] / s
  *v\d[1] = *v\d[1] / s
  *v\d[2] = *v\d[2] / s
EndProcedure

Procedure perlinInit()
  Protected i.i, j.i, k.i, tmp.i
  Protected *t.InnerDoubleArray
  
  i = 0
  While i < #B
    p(i)  = i
    tmp = ((Random(2147483647) % (#B + #B)) - #B)
    g1(i) = tmp / #B
    
    
    For j = 0 To 1
      tmp = ((Random(2147483647) % (#B + #B)) - #B)
      g2(i, j) = tmp / #B
    Next
    normalize2(@g2(i, 0))
    
    For j = 0 To 2
      tmp = ((Random(2147483647) % (#B + #B)) - #B)
      g3(i, j) = tmp / #B
    Next
    normalize3(@g3(i, 0))
    
    i + 1
  Wend  
  
  i - 1
  While i > 0
    i - 1
    
    k = p(i)
    j = Random(2147483647) % #B
    p(i) = p(j)
    p(j) = k;
  Wend
  
  i = 0
  While i < #B + 2
    p(#B + i) = p(i)
    g1(#B + i) = g1(i)
    
    For j = 0 To 1
      g2(#B + i, j) = g2(i, j)
    Next
    For j = 0 To 2
      g3(#B + i, j) = g3(i, j)
    Next
    
    i + 1
  Wend
EndProcedure

Procedure.d PerlinNoise1D(x.d, alpha.d, beta.d, interations.i)
  Protected i.i
  Protected val.d = 0, sum.d = 0
  Protected p.d = 1, scale.d = 1
  
  p = x
  For i = 1 To interations
    val = noise1(p)
    sum + val / scale
    scale * alpha
    p * beta
  Next
  
  ProcedureReturn(sum)
EndProcedure

Procedure.d PerlinNoise2D(x.d ,y.d, alpha.d, beta.d, interations.i)
  Protected i.i
  Protected val.d = 0, sum.d = 0
  Protected scale.d = 1
  Dim args.d(1)
  
  args(0) = x
  args(1) = y
  For i = 1 To interations
    val = noise2(args())
    sum + val / scale
    scale * alpha
    args(0) * beta
    args(1) * beta
  Next
  
  ProcedureReturn(sum)
EndProcedure

Procedure.d PerlinNoise3D(x.d, y.d, z.d, alpha.d, beta.d, interations.i)
  Protected i.i
  Protected val.d = 0, sum.d = 0
  Protected scale.d = 1
  Dim args.d(2)
  
  args(0) = x
  args(1) = y
  args(2) = z
  For i = 1 To interations
    val = noise3(args())
    sum = sum + (val / scale)
    scale * alpha
    args(0) * beta
    args(1) * beta
    args(2) * beta
  Next
  
  ProcedureReturn(sum)
EndProcedure

; End Of Noise Functions

; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 1
; Folding = ---
; EnableXP