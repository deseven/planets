; planets!

IncludeFile "const.pb"

; globals
ExamineDesktops()
Global DesktopW = DesktopWidth(0)
Global DesktopH = DesktopHeight(0)
Global DesktopD = DesktopDepth(0)
Global DesktopF = DesktopFrequency(0)

Global itera.i = 1
Global scale.d = 1.0
Global angle.d = 0
Global mX,mY

Global selectedObject.i = -1
Global displayInfo.b,FPSCounter.l,FPS.l,curTime.i

Global numPlanets = Val(ProgramParameter())-1
If numPlanets < 0 Or numPlanets > 19
  numPlanets = 14
EndIf
Global Dim planetCoordsX(numPlanets)
Global Dim planetCoordsY(numPlanets)
Global Dim planetCoordsCX.f(numPlanets)
Global Dim planetCoordsCY.f(numPlanets)
Global Dim planetRadius(numPlanets)
Global Dim planetMass(numPlanets)
Global Dim planetColor(numPlanets)
Global Dim planetVelocity.f(numPlanets)
Global Dim planetPath.f(numPlanets)
Global Dim planetRotation.f(numPlanets)
Global Dim planetName.s(numPlanets)
Global Dim planetType.s(numPlanets)

Global solW.i,solColor.i,solName.s

Global numStars = DesktopW/5
Global Dim starCoordsX(numStars)
Global Dim starCoordsY(numStars)
Global Dim starColor(numStars)

IncludeFile "perlin.pb"
IncludeFile "proc.pb"

; === here we go! ===
init()

Repeat
  mX = MouseX()
  mY = MouseY()

  ClearScreen($000000)
  
  ExamineKeyboard()
  ExamineMouse()
  
  ; periodic tasks (every 2nd frame)
  If periodicTasks
    StartDrawing(SpriteOutput(#sol))
    DrawingMode(#PB_2DDrawing_CustomFilter)
    CustomFilterCallback(@solEffect())
    Circle(solW/2,solW/2,solW/2)
    StopDrawing()
    RotateSprite(#sol,0.1,#PB_Relative)
    periodicTasks = #False
  Else
    periodicTasks = #True
  EndIf
  
  If MouseWheel() <> 0
    scale + MouseWheel()/100
    If scale < 0.3 : scale = 0.3 : EndIf
    If scale > 2.5 : scale = 2.5 : EndIf
    ZoomSprite(#sol,solW*scale,solW*scale)
    ZoomSprite(#sol_flare,DesktopH*scale,DesktopH*scale)
    If selectedObject = #sol
      ZoomSprite(#selected,solW*scale,solW*scale)
    ElseIf selectedObject > -1
      ZoomSprite(#selected,PlanetRadius(selectedObject)*2*scale,PlanetRadius(selectedObject)*2*scale)
    EndIf
  EndIf
  
  If MouseButton(#PB_MouseButton_Left)
    mousePressed = #True
  ElseIf mousePressed
      mousePressed = #False
      selectObject(mX-5,mY-5)
  EndIf
  
  StartDrawing(ScreenOutput())
  drawStars()
  drawOrbitTrails()
  drawInfo()
  StopDrawing()
  
  DisplayTransparentSprite(#sol_flare,DesktopW/2-DesktopH/2*scale,DesktopH/2-DesktopH/2*scale)
  DisplayTransparentSprite(#sol,DesktopW/2-solW/2*scale,DesktopH/2-solW/2*scale)
  
  drawPlanets()
  
  If selectedObject = #sol
    DisplayTransparentSprite(#selected,DesktopW/2-solW/2*scale,DesktopH/2-solW/2*scale)
  EndIf
  
  If selectedObject > -1
    DisplayTransparentSprite(#selected_preview,0,DesktopH-100)
  EndIf
  
  DisplayTransparentSprite(#cursor,mX-5,mY-5)
  
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 20
; FirstLine = 3
; EnableXP