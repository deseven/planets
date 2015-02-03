; planets! constants

#name = "planets!"

#cursor = 10000
#selected = 10001
#selected_preview = 10002

#min_scale = 0.2
#max_scale = 3.0

#max_planets = 20
#max_moons = 10

#nebula = 5000

Enumeration fonts
  #font_normal
  #font_head
EndEnumeration

Enumeration starTypes
  #star_default
EndEnumeration

Enumeration planetTypes
  #planet_earthlike
  #planet_water
  #planet_ice
  #planet_gasgiant
  #planet_lava
  #planet_desert
  #planet_rock
  #planet_acid
  #planet_asteroidbelt
EndEnumeration

Enumeration solTypes
  #sol_red
  #sol_blue
EndEnumeration

Enumeration sol 1000
  #sol
  #sol_flare
EndEnumeration

Enumeration perlinType
  #perlin_default
  #perlin_sol
  #perlin_nebula
EndEnumeration

Structure moon
  coordX.l
  coordY.l
  coordCX.l
  coordCY.l
  radius.w
  mass.f
  color.l
  velocity.f
  path.f
  rotation.f
  name.s
  type.s
EndStructure

Structure planet
  x.l
  y.l
  cx.f
  cy.f
  radius.w
  mass.f
  color.l
  velocity.f
  path.f
  rotation.f
  type.b
  name.s
  descr.s
  Array moons.moon(#max_moons-1)
EndStructure

Structure star
  x.l
  y.l
  color.l
EndStructure

Structure sol
  size.l
  color.l
  name.s
  rotation.f
EndStructure
