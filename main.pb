; planets!

IncludeFile "const.pb"

; globals and defaults
ExamineDesktops()
Global DesktopW = DesktopWidth(0)
Global DesktopH = DesktopHeight(0)
Global DesktopD = DesktopDepth(0)
Global DesktopF = DesktopFrequency(0)

Global scale.d = 1.0
Global angle.d = 0
Global mX,mY

Global showOrbits = #False
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

Global solW.i,solColor.i,solName.s,solRotation.f

Global numStars = DesktopW/5
Global Dim starCoordsX(numStars)
Global Dim starCoordsY(numStars)
Global Dim starColor(numStars)

IncludeFile "perlin.pb"
IncludeFile "proc.pb"

; === here we go! ===
init()

Repeat

  ClearScreen($000000)
  
  ExamineKeyboard()
  ExamineMouse()
  
  mX = MouseX()
  mY = MouseY()
  
  ; reapply our sun effect
  StartDrawing(SpriteOutput(#sol))
  DrawingMode(#PB_2DDrawing_CustomFilter)
  CustomFilterCallback(@solEffect())
  Circle(solW/2,solW/2,solW/2)
  StopDrawing()
  ; and rotate it
  RotateSprite(#sol,solRotation,#PB_Relative)
  
  If KeyboardReleased(#PB_Key_O)
    If showOrbits : showOrbits = #False : Else : showOrbits = #True : EndIf
  EndIf
  
  ; additional keys for zoom-in/zoom-out
  If KeyboardPushed(#PB_Key_Minus)
    scale - 0.03
    scaleUpdated = #True
  ElseIf KeyboardPushed(#PB_Key_Equals)
    scaleUpdated = #True
    scale + 0.03
  EndIf
  
  ; handle zoom-in/zoom-out
  If MouseWheel() <> 0 Or scaleUpdated
    scaleUpdated = #False
    scale + MouseWheel()/100
    If scale < #min_scale : scale = #min_scale : EndIf
    If scale > #max_scale : scale = #max_scale : EndIf
    ; we need to zoom sol sprites and a selection sprites
    ; we'll deal with planets later
    ZoomSprite(#sol,solW*scale,solW*scale)
    ZoomSprite(#sol_flare,DesktopH*scale,DesktopH*scale)
    If selectedObject = #sol
      ZoomSprite(#selected,solW*scale,solW*scale)
    ElseIf selectedObject > -1
      ZoomSprite(#selected,planetRadius(selectedObject)*2*scale,planetRadius(selectedObject)*2*scale)
    EndIf
  EndIf
  
  ; a little trick to catch the LMB only when it's released
  ; because we don't want to select an object 60+ times per second
  If MouseButton(#PB_MouseButton_Left)
    mousePressed = #True
  ElseIf mousePressed
      mousePressed = #False
      selectObject(mX-5,mY-5)
  EndIf
  
  ; all 2d drawing combined here
  ; as it's important to use only one drawing per frame
  StartDrawing(ScreenOutput())
  drawStars()
  drawOrbits()
  drawInfo()
  StopDrawing()
  
  ; our solar flare and sol itself
  DisplayTransparentSprite(#sol_flare,DesktopW/2-DesktopH/2*scale,DesktopH/2-DesktopH/2*scale)
  DisplayTransparentSprite(#sol,DesktopW/2-solW/2*scale,DesktopH/2-solW/2*scale)
  
  ; now we can draw our planets
  drawPlanets()
  
  ; and selection sprite
  If selectedObject = #sol
    DisplayTransparentSprite(#selected,DesktopW/2-solW/2*scale,DesktopH/2-solW/2*scale)
  EndIf
  If selectedObject > -1
    DisplayTransparentSprite(#selected_preview,0,DesktopH-100)
  EndIf
  
  ; our cursor goes on top of everything
  DisplayTransparentSprite(#cursor,mX-5,mY-5)
  
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)