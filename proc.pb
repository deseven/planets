; planets! procedures

; random names generation
Procedure.s makeWord(WordLength = 0,  Mode = 1)
  ; taken from http://www.purebasic.fr/english/viewtopic.php?f=12&t=48961
  ; procedure returns a randomly constructed word
  ; if WordLength = 0 (default) then length is random 3 to 10
  ; mode = 0 --- all lower case (default)
  ; mode = 1 --- first letter is upper case
  ; mode = 2 --- all upper case
  
  Protected vcFlag.i, LL$, NL$, word$
  Static cc    ; the number of available consonants
  Static sc    ; the number of special consonants
  Static vc    ; the number of available vowels
  Static sv    ; the number of special vowels
  Static sb    ; the number of special beginnings
  Static con$  ; stores all of the available consonants
  Static vow$  ; stores all of the available vowels
  Static beg$  ; stores all special beginnings consonants
  Static init = #True
  
  Macro GetData(dataBlock, counterVariable, storageString)
    Restore dataBlock
    Read.s LL$
    While LL$
      counterVariable + 1
      storageString + LL$
      Read.s LL$
    Wend
  EndMacro
  
  If init ; do this only once
          ; count and store all the consonants and vowels
    GetData(consonants, cc, con$)
    GetData(specialConsonants, sc, con$)
    cc + sc - 1
    GetData(vowels, vc, vow$)
    GetData(specialVowels, sv, vow$)
    vc + sv - 1
    GetData(specialBeginnings, sb, beg$)
    sb - 1
    init = #False
  EndIf
  
  If WordLength < 1
    WordLength = 3 + Random(3) + Random(2) + Random(2)
  EndIf
  
  If Random(10) > 2 ; make first letter a consonant
    If Not Random(10) ; use a special beginning
      word$ = RTrim(Mid(beg$, 1 + Random(sb) << 1, 2))
    Else
      word$ = RTrim(Mid(con$, 1 + Random(cc - sc) << 1, 2))
    EndIf
    vcFlag = #False
  Else ; make first letter a vowel
    word$ = RTrim(Mid(vow$, 1 + Random(vc - sv) << 1, 2))
    vcFlag = #True 
  EndIf
  
  LL$ = Right(word$,1)
  
  While Len(word$) < WordLength ; choose the remaining letters
    Repeat
      Repeat
        If vcFlag ; last was vowel so add a consonant
          NL$ = RTrim(Mid(con$, 1 + Random(cc) << 1, 2))
        Else ; last was consonant so add a vowel
          NL$ = RTrim(Mid(vow$, 1 + Random(vc) << 1, 2))
        EndIf
      Until NL$ <> LL$
    Until Len(word$) + Len(NL$) <= WordLength
    word$ + NL$ : LL$ = Right(NL$,1) : vcFlag ! 1
  Wend
  
  Select mode
    Case 0 ; default all lower case
           ; do nothing
    Case 1 ; make first letter upercase
      word$ = UCase(Left(word$,1)) + Right(word$,Len(word$)-1)
    Case 2 ; make all letters uppercase
      word$ = UCase(word$)
  EndSelect
  
  ProcedureReturn word$
  
  DataSection
    specialBeginnings: ; only used at word beginnings
    Data.s "bl","br","cl","cr","dr","fl","fr","gr","kl","kr","pl","pr","qu","sl","sm"
    Data.s "sn","sp","sw"
    Data.s ""
    
    consonants:
    Data.s "b ","b ","c ","c ","c ","c ","d ","d ","d ","d ","d ","d ","f ","f ","f "
    Data.s "g ","g ","g ","h ","h ","h ","h ","h ","h ","h ","h ","j ","j ","k ","l "
    Data.s "l ","l ","l ","l ","m ","m ","m ","n ","n ","n ","n ","n ","n ","n ","n "
    Data.s "n ","p ","p ","p ","r ","r ","r ","r ","r ","r ","r ","r ","s ","s ","s "
    Data.s "s ","s ","s ","s ","s ","s ","t ","t ","t ","t ","t ","t ","t ","t ","t "
    Data.s "t ","t ","t ","v ","w ","w ","w ","x ","x ","y ","y ","y ","z ","ch","th"
    Data.s "sh","st","sk","sp","tr","ph"
    Data.s ""
    
    specialConsonants: ; never used at begining of words
    Data.s "ng","nt","rk","nd","ck","ds","ks","rt","nk","bb","gg","ll","nn","ss"
    Data.s ""
    
    vowels:
    Data.s "a ","a ","a ","e ","e ","e ","e ","e ","i ","i ","i "
    Data.s "o ","o ","o ","u ","a ","a ","a ","e ","e ","e ","e "
    Data.s "e ","i ","i ","i ","o ","o ","o ","u "
    Data.s ""
    
    specialVowels: ; never used at beginning of words
    Data.s "oa","ea","ie","ia","ya","yo","oo","ee","y "
    Data.s ""
  EndDataSection
  
EndProcedure

; random texture generation
Procedure.i genTexture(rad.i,color.i,bcolor.i,alpha.i,beta.i,type.i = #perlin_default)
  
  Width = rad * 2
  Height = rad * 2
  
  For x = Width-1 To 0 Step -1
    For y = Height-1 To 0 Step -1
      ; here we're using PerlinNoise3D() for no actual reason as the Z coordinate is always 0 :)
      ; but we'll leave that for later
      If type = #perlin_sol
        noise.d = Unsigned(PerlinNoise3D((1 / Width) * x, (1 / Height) * y,0, 1 + Random(10)/100, 2, 6))
      Else
        noise.d = Unsigned(PerlinNoise3D((1 / Width) * x, (1 / Height) * y,0, alpha, beta, 6))
      EndIf
      
      Protected b.i = Int(255 * noise)
      If b > 255
        b = 255
      EndIf
      
      Select bcolor
        Case 0
          Plot(x, y, RGBA(b, Green(color), Blue(color), 255))
        Case 1
          Plot(x, y, RGBA(Red(color), b, Blue(color), 255))
        Case 2
          Plot(x, y, RGBA(Red(color), Green(color), b, 255))
        Default
          Plot(x, y, RGBA(Red(color), Green(color), Blue(color), 255))
      EndSelect
    Next
    
  Next
  
EndProcedure

; very simple loading bar
Procedure updateLoading(current.i,max.i)
  ClearScreen($000000)
  StartDrawing(ScreenOutput())
  piece.i = 792/max
  FrontColor($ffffff)
  DrawingMode(#PB_2DDrawing_Outlined)
  Box(DesktopW/2-400,DesktopH/2-20,800,40)
  DrawingMode(#PB_2DDrawing_Default)
  If current <> max
    Box(DesktopW/2-396,DesktopH/2-16,current*piece,32)
  Else
    Box(DesktopW/2-396,DesktopH/2-16,792,32)
  EndIf
  StopDrawing()
  FlipBuffers()
EndProcedure

; creates a background star
Procedure createStar(type.i,index.i)
  Select type
    Case #star_default
      StarCoordsX(index) = Random(DesktopW)
      StarCoordsY(index) = Random(DesktopH)
      color = Random(200)+55
      starColor(index) = RGB(color,color,color)
  EndSelect
EndProcedure

; creates the heart of our solar system
Procedure createSol(type.i)
  solName = makeWord()
  solW = (100 + Random(40))*2+2
  If solW%2
    solW + 1
  EndIf
  solRotation = Random(15,8)/100
  CreateSprite(#sol,solW,solW,#PB_Sprite_AlphaBlending)
  
  StartDrawing(SpriteOutput(#sol))
  Select type
    Case #sol_red
      solColor = RGB(255,255,0)
    Case #sol_blue
      solColor = RGB(0,0,255)
  EndSelect
  DrawingMode(#PB_2DDrawing_AllChannels)
  genTexture(solW/2,solColor,1,1,1,#perlin_sol)
  
  ; this is a hack to draw an image in circle
  FrontColor(RGB(0,0,0))
  DrawingMode(4)
  Circle(solW/2,solW/2,solW/2-10)
  DrawingMode(#PB_2DDrawing_AlphaChannel)
  FillArea(0,0,RGB(0,0,0),RGB(0,0,0))
  StopDrawing()
  
  CreateSprite(#sol_flare,DesktopH/4,DesktopH/4,#PB_Sprite_AlphaBlending)
  
  StartDrawing(SpriteOutput(#sol_flare))
  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AllChannels)
  CircularGradient(DesktopH/8,DesktopH/8,DesktopH/8)
  If type = #sol_blue
    GradientColor(0.0,RGBA(Red(solColor),Green(solColor),Blue(solColor),$88))
  Else
    GradientColor(0.0,RGBA(Red(solColor),Green(solColor),Blue(solColor),$44))
  EndIf
  GradientColor(1.0,$00000000)
  Box(0,0,DesktopH/4,DesktopH/4)
  StopDrawing()
  
  ZoomSprite(#sol_flare,DesktopH,DesktopH)
EndProcedure

; creates a planet based on type and (hopefully) finely-tuned params
Procedure createPlanet(type.i,index.i)
  ; re-init Perlin noise generator every time
  perlinInit()
  Select type
    Case #planet_earthlike
      planetType(index) = "earth-like"
      planetRadius(index) = Random(15)+5
      planetColor(index) = RGB(Random(50),Random(155)+50,Random(50)+50)
      alpha = 1
      beta = 6
      bcolor = 2
    Case #planet_water
      planetType(index) = "water planet"
      planetRadius(index) = Random(20)+7
      planetColor(index) = RGB(Random(30),Random(50),Random(100)+50)
      alpha = 1
      beta = 6
      bcolor = 2
    Case #planet_ice
      planetType(index) = "ice planet"
      planetRadius(index) = Random(20)+7
      planetColor(index) = RGB(Random(40)+140,Random(40)+140,Random(40)+140)
      alpha = 1
      beta = 6
      bcolor = 0
    Case #planet_gasgiant
      planetType(index) = "gas giant"
      planetRadius(index) = Random(20)+30
      planetColor(index) = RGB(Random(200)+10,Random(200)+10,Random(200)+10)
      alpha = 1
      beta = 1
      bcolor = 2
    Case #planet_lava
      planetType(index) = "lava planet"
      planetRadius(index) = Random(12)+6
      planetColor(index) = RGB(Random(10)+200,Random(20),Random(20))
      alpha = 1
      beta = 6
      bcolor = 1
    Case #planet_desert
      planetType(index) = "desert planet"
      planetRadius(index) = Random(10)+6
      planetColor(index) = RGB(Random(10)+240,Random(20)+200,Random(10)+120)
      alpha = 2
      beta = 6
      bcolor = Random(2,1)
    Case #planet_rock
      planetType(index) = "rock planet"
      planetRadius(index) = Random(18)+6
      planetColor(index) = RGB(Random(5),Random(10)+100,Random(10)+100)
      alpha = 2
      beta = 6
      bcolor = 0
    Case #planet_acid
      planetType(index) = "acid planet"
      planetRadius(index) = Random(10)+10
      planetColor(index) = RGB(Random(5)+100,Random(50)+50,Random(10)+10)
      alpha = 2
      beta = 6
      bcolor = Random(2,1)
  EndSelect
  
  If index
    planetCoordsX(index) = planetCoordsX(index-1) + planetRadius(index-1)*2 + planetRadius(index)*2 + Random(100)
  Else
    planetCoordsX(index) = 140 + Random(20) + planetRadius(index)*2
  EndIf
  planetName(index) = makeWord()
  planetCoordsY(index) = Random(DesktopH/2)
  planetMass(index) = Random(9999)+1
  If index
    planetVelocity(index) = planetVelocity(index-1)/1.4
  Else
    planetVelocity(index) = 0.005 + Random(6)/1000 + Random(10)/10000
  EndIf
  planetPath(index) = planetVelocity(index) * Random(10000,1)
  planetRotation(index) = Random(10000,100)/1000
  
  spriteW = planetRadius(index)*8+8
  CreateSprite(index,spriteW,spriteW,#PB_Sprite_AlphaBlending)
  
  ; this is a hack to draw an image in circle
  StartDrawing(SpriteOutput(index))
  DrawingMode(#PB_2DDrawing_AllChannels)
  genTexture(spriteW/2,planetColor(index),bcolor,alpha,beta)
  DrawingMode(#PB_2DDrawing_Default)
  FrontColor(RGB(0,0,0))
  DrawingMode(4)
  Circle(spriteW/2,spriteW/2,spriteW/2-8)
  DrawingMode(#PB_2DDrawing_AlphaChannel)
  FillArea(0,0,RGB(0,0,0),RGB(0,0,0))
  StopDrawing()

EndProcedure

; draws the sol effect
Procedure solEffect(x,y,sourceColor,targetColor) 
  If (x+y)%5=0
    ProcedureReturn targetColor
  EndIf
  xn=x-1+Random(2)
  yn=y-1+Random(2)
  If xn<0 Or xn>=OutputWidth() Or yn<0 Or yn>=OutputHeight()
    ProcedureReturn targetColor
  EndIf
  ProcedureReturn Point(xn,yn)
EndProcedure

; small procedure to help finding out whether we need to show a sprite or not
Procedure spriteVisible(x,y,w,h)
  If ((x < 0) Or (x > DesktopW)) And ((x+w < 0) Or (x+w > DesktopW)) And ((y < 0) Or (y > DesktopH)) And ((y+h < 0) Or (y+h > DesktopH))
    ProcedureReturn #False
  EndIf
  ProcedureReturn #True
EndProcedure

; tries to select an object
Procedure selectObject(x,y)
  previous = selectedObject
  selectedObject = -1
  ; we're checking if our cursor overlaps any of our objects
  For i=0 To numPlanets
    ZoomSprite(i,planetRadius(i)*2*scale,planetRadius(i)*2*scale)
    If SpriteCollision(#cursor,x,y,i,planetCoordsCX(i),planetCoordsCY(i))
      selectedObject = i
      Break
    EndIf
  Next
  If SpriteCollision(#cursor,x,y,#sol,DesktopW/2-solW/2*scale,DesktopH/2-solW/2*scale)
    selectedObject = #sol
  EndIf
  ; and then we're generating a preview sprite for the selected object to use it later
  ; todo - lower the copy-paste level
  If previous <> selectedObject
    If selectedObject = #sol
      w = solW*2
      CreateSprite(#selected,w,w,#PB_Sprite_AlphaBlending)
      StartDrawing(SpriteOutput(#selected))
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      Box(0,0,w,w,$00000000)
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AllChannels)
      CircularGradient(w/2,w/2,w/2-4)
      GradientColor(0.0,$00000000)
      GradientColor(0.9,$ffffffff)
      GradientColor(1.0,$00000000)
      Circle(w/2,w/2,w/2-4,$00000000)
      StopDrawing()
      ZoomSprite(#selected,w/2*scale,w/2*scale)
      CopySprite(selectedObject,#selected_preview,#PB_Sprite_AlphaBlending)
      ZoomSprite(#selected_preview,100,100)
    ElseIf selectedObject > -1
      w = planetRadius(selectedObject)*4+4
      CreateSprite(#selected,w,w,#PB_Sprite_AlphaBlending)
      StartDrawing(SpriteOutput(#selected))
      DrawingMode(#PB_2DDrawing_AlphaChannel)
      Box(0,0,w,w,$00000000)
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AllChannels)
      CircularGradient(w/2,w/2,w/2)
      GradientColor(0.0,$00000000)
      GradientColor(0.9,$ffffffff)
      GradientColor(1.0,$00000000)
      Circle(w/2,w/2,w/2,$00000000)
      StopDrawing()
      CopySprite(selectedObject,#selected_preview,#PB_Sprite_AlphaBlending)
      ZoomSprite(#selected_preview,100,100)
    EndIf
  EndIf
EndProcedure

; draws all background stars
Procedure drawStars()
  For i=0 To numStars
    If StarCoordsX(i) < DesktopW And StarCoordsY(i) < DesktopH And StarCoordsX(i) => 0 And StarCoordsY(i) => 0
      If Random(500) > 0
        Plot(StarCoordsX(i),StarCoordsY(i),starColor(i))
        ; random flash event
        If Random(300000) = 0
          FrontColor($aaaaaa)
          If StarCoordsX(i) < DesktopW And StarCoordsY(i)+1 < DesktopH And StarCoordsX(i) => 0 And StarCoordsY(i)+1 => 0
            Plot(StarCoordsX(i),StarCoordsY(i)+1)
          EndIf
          If StarCoordsX(i) < DesktopW And StarCoordsY(i)-1 < DesktopH And StarCoordsX(i) => 0 And StarCoordsY(i)-1 => 0
            Plot(StarCoordsX(i),StarCoordsY(i)-1)
          EndIf
          If StarCoordsX(i)+1 < DesktopW And StarCoordsY(i) < DesktopH And StarCoordsX(i)+1 => 0 And StarCoordsY(i) => 0
            Plot(StarCoordsX(i)+1,StarCoordsY(i))
          EndIf
          If StarCoordsX(i)-1 < DesktopW And StarCoordsY(i) < DesktopH And StarCoordsX(i)-1 => 0 And StarCoordsY(i) => 0
            Plot(StarCoordsX(i)-1,StarCoordsY(i))
          EndIf
        EndIf
      EndIf
    EndIf
  Next
EndProcedure

; draws a very simple and ugly orbits
Procedure drawOrbits()
  If showOrbits
    For i=0 To numPlanets
      DrawingMode(#PB_2DDrawing_Outlined)
      Circle(DesktopW/2,DesktopH/2,planetCoordsX(i)*scale,planetColor(i))
      ; here are some attempts to create a home-crafted anitaliasing for circles
      ; which have failed miserably
      ; don't try that approach
      ;DrawingMode(#PB_2DDrawing_Outlined)
      ;r = Red(planetColor(i))
      ;g = Green(planetColor(i))
      ;b = Blue(planetColor(i))
      ;For j=-3 To 3
      ;  If j = 0
      ;    Circle(DesktopW/2,DesktopH/2,planetCoordsX(i)*scale,RGB(r,g,b))
      ;  Else
      ;    sr = r-r/4*Abs(j)
      ;    If sr < 0 : sr = 0 : EndIf
      ;    sg = g-g/4*Abs(j)
      ;    If sg < 0 : sg = 0 : EndIf
      ;    sb = b-b/4*Abs(j)
      ;    If sb < 0 : sb = 0 : EndIf
      ;    Circle(DesktopW/2,DesktopH/2,planetCoordsX(i)*scale+j,RGB(sr,sg,sb))
      ;  EndIf
      ;Next
    Next
  EndIf
EndProcedure

; draws various technical information and selected object information as well
Procedure drawInfo()
  If displayInfo
    FrontColor($ffffff)
    FPSCounter + 1
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawingFont(FontID(#font_normal))
    DrawText(4,0,"display: " + Str(DesktopW) + "x" + Str(DesktopH) + "@" + Str(DesktopD) + "@" + Str(FPS))
    DrawText(4,20,"scale: " + "x" + StrF(scale,4))
    If showOrbits
      DrawText(4,40,"orbits (o): on")
    Else
      DrawText(4,40,"orbits (o): off")
    EndIf
    If ElapsedMilliseconds() - curTime >= 1000
      curTime = ElapsedMilliseconds()
      FPS = FPSCounter
      FPSCounter = 0
    EndIf
    If selectedObject = #sol
      name.s = solName
      type.s = "star"
      radius.s = "radius: " + Str(solW/2)
      velocity.s = "velocity: 0"
    ElseIf selectedObject > -1
      name.s = planetName(selectedObject) + " (" + solName + " " + Chr(97+selectedObject) + ")"
      type.s = planetType(selectedObject)
      radius.s = "radius: " + Str(planetRadius(selectedObject))
      velocity.s = "velocity: " + StrF(planetVelocity(selectedObject)*10000,2)
    EndIf
    If selectedObject > -1
      DrawingFont(FontID(#font_head))
      frameWidth = TextWidth(name) + 112
      If frameWidth < 200 : frameWidth = 200 : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(0,DesktopH-100,frameWidth,100,$333333)
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(0,DesktopH-100,frameWidth,100,$777777)
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(106,DesktopH-100,name)
      DrawingFont(FontID(#font_normal))
      DrawText(106,DesktopH-80,type)
      DrawText(106,DesktopH-40,radius)
      DrawText(106,DesktopH-20,velocity)
    EndIf
  EndIf
EndProcedure

Procedure drawPlanets()
  For i=0 To numPlanets
    ; calculating the current planet position in a circle
    planetPath(i) + planetVelocity(i)
    x.f = planetCoordsX(i)*Cos(planetPath(i))*scale
    y.f = planetCoordsX(i)*Sin(planetPath(i))*scale
    planetCoordsCX(i) = x+DesktopW/2-planetRadius(i)*scale
    planetCoordsCY(i) = y+DesktopH/2-planetRadius(i)*scale
    planetW = planetRadius(i)*scale*2
    If spriteVisible(planetCoordsCX(i),planetCoordsCY(i),planetW,planetW)
      x1.f = planetCoordsCX(i)
      y1.f = planetCoordsCY(i)
      x2.f = planetCoordsCX(i) + planetW
      y2.f = planetCoordsCY(i)
      x3.f = planetCoordsCX(i) + planetW
      y3.f = planetCoordsCY(i) + planetW
      x4.f = planetCoordsCX(i)
      y4.f = planetCoordsCY(i) + planetW
      ; we are basically put the sprite to the desired float coordinates
      TransformSprite(i,x1,y1,x2,y2,x3,y3,x4,y4)
      ; this is the only(?) reliable way to use some kind of a subpixel rendering
      ; and to get a smooth sprite movement in PB natively right now
      DisplayTransparentSprite(i,0,0)
      If selectedObject = i
        TransformSprite(#selected,x1,y1,x2,y2,x3,y3,x4,y4)
        DisplayTransparentSprite(#selected,0,0)
      EndIf
    EndIf
  Next
EndProcedure

; main initialization where we're generating everything we need
Procedure init()
  If Not InitKeyboard() Or Not InitSprite() Or Not InitMouse() : End 1 : EndIf
  OpenScreen(DesktopW,DesktopH,DesktopD,"planets!",#PB_Screen_SmartSynchronization,DesktopF)
  
  loadingPieces = 2 + numPlanets
  updateLoading(0,loadingPieces)
  
  If Not (LoadFont(#font_normal,"Arial",12,#PB_Font_Bold) And LoadFont(#font_head,"Arial",14,#PB_Font_Bold))
    DisplayInfo = #False
  Else
    DisplayInfo = #True
  EndIf
  
  SpriteQuality(#PB_Sprite_BilinearFiltering)
  
  CreateSprite(#cursor,11,11,#PB_Sprite_AlphaBlending)
  StartDrawing(SpriteOutput(#cursor))
  color = RGBA(255,255,255,255)
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,11,11,$00000000)
  For i=0 To 10 : Plot(i,5,color) : Next
  For i=0 To 10 : Plot(5,i,color) : Next
  StopDrawing()
  
  ; generating stars
  For i=0 To numStars
    createStar(#star_default,i)
  Next
  
  updateLoading(1,loadingPieces)
  
  ; generating planets
  For i=0 To numPlanets
    createPlanet(Random(7),i)
    updateLoading(2+i,loadingPieces)
  Next
  
  ; generating sol
  createSol(Random(1))
  updateLoading(loadingPieces,loadingPieces)
  
  MouseLocate(DesktopW/2,DesktopH/2)
  
EndProcedure