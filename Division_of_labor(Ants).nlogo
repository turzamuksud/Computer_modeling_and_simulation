breed [ants ant]
breed [ants2 ant2]
breed [foods food]

ants-own [
  energy 
  drag-ticks
  
]

ants2-own [
  energy 
  drag-ticks
]

patches-own[
  nest-scent?

  ]

to setup
  __clear-all-and-reset-ticks
  setup-patches
  setup-ants
  setup-ants2
  setup-foods
  do-plotting
end

to setup-patches
  ask patches
  [
    ifelse(distancexy 0 0) < 2.5
    [set nest-scent? true]
    [set nest-scent? false]
  ]
  ask patches
  [
    if(nest-scent?)
    [set pcolor red]
  ]
end

    
to setup-ants
  set-default-shape ants "ant"
  create-ants number-of-bots [
    set color white 
    set drag-ticks 0
    set heading (random-float 360)
    set energy (500 + random-float 500)
  ]
end

to setup-ants2
  set-default-shape ants2 "ant 2"
  create-ants2 number-of-bots [

    set color blue 
    set drag-ticks 0
    set heading (random-float 360)
    set energy (500 + random-float 500)
  ]
end

to setup-foods
  set-default-shape foods "food"
  ifelse(food-distribution = "scattered")[
    create-foods number-of-foods [
      setxy random-xcor random-ycor  
      set color (ifelse-value (nest-scent?) [red] [green])    
    ]  
  ]
  [
    create-foods number-of-foods[
      setxy (max-pxcor - 4)(max-pycor - 4)
      fd (random 5)
      set color (ifelse-value (nest-scent?) [red] [green])
  ]
  ]
end


to go
  ask ants [
    set energy (energy - energy-decrement)
    ifelse (energy < minimum-energy) [
      move-to-nest
    ]
    [
      ifelse (any? my-out-links) [
        move-to-target
      ]
      [
        let visible-foods ((foods in-cone vision-range vision-angle) 
          with [not nest-scent? and not any? my-in-links]) ; Make sure not already in target, and not already linked.
        ifelse (any? visible-foods) [
          transport (min-one-of visible-foods [distance myself])
        ]
        [
          wiggle
        ]
      ]
    ]
    ifelse show-energy?
    [
      set label energy
    ]
    [
      set label ""
    ]
  ]
  
  ask ants2 [
    set energy (energy - energy-decrement)
    if( ticks > 500)[
      ifelse (energy < minimum-energy) [
      move-to-nest
    ]
    [
      ifelse (any? my-out-links) [
        move-to-target
      ]
      [
        let visible-foods ((foods in-cone vision-range vision-angle) 
          with [not nest-scent? and not any? my-in-links]) ; Make sure not already in target, and not already linked.
        ifelse (any? visible-foods) [
          transport (min-one-of visible-foods [distance myself])
        ]
        [
          wiggle
        ]
      ]
    ]
    ifelse show-energy?
    [
      set label energy
    ]
    [
      set label ""
    ]
  ]
  ]  
  tick
  do-plotting
end

to move-to-nest
  ifelse (nest-scent?) [
    ask ants[set color white]
    ask ants2[set color blue]
    set energy (500 + random 501)
  ]
  [
    set color red
    if (any? my-out-links) [
      release-food
    ]
    facexy 0 0
    forward (ifelse-value (energy < 0) [loaded-step-length] [unloaded-step-length])
  ]
end

to transport [selected-food]
  
    set energy (energy - energy-decrement * 2)
  face selected-food
  forward 1
      ask ants[
    if (distance selected-food <= find-range and pcolor = black) [
        ask selected-food [
        set color gray
        set pcolor white
      ]
    ]
  ]
  
  ask ants2 [
    if (distance selected-food <= grab-range and pcolor = white) [
    create-link-to selected-food [
      tie
      ]
    
      set pcolor black

    ]
  ]
end

to move-to-target
    facexy 0 0
    forward loaded-step-length
    set drag-ticks (drag-ticks + 1)
    if ([nest-scent?] of one-of out-link-neighbors)[
      release-food
      right 180
  ]
end


to wiggle
  right ((random-float max-wiggle-angle) - (random-float max-wiggle-angle))
  ifelse (can-move? unloaded-step-length) [
    forward unloaded-step-length
  ]
  [
    set heading (random-float 360)
  ]
end

to release-food
  ask my-out-links [
    ask other-end [
      set color (ifelse-value (nest-scent?) [yellow] [gray])
    ]
    die
  ]
end

to do-plotting
  set-current-plot "Average Energy"
  plotxy ticks (mean [energy] of ants)
end
@#$#@#$#@
GRAPHICS-WINDOW
217
2
863
355
40
20
7.854
1
10
1
1
1
0
0
0
1
-40
40
-20
20
1
1
1
ticks
30.0

BUTTON
10
500
80
533
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
130
165
163
number-of-bots
number-of-bots
1
100
30
1
1
NIL
HORIZONTAL

SLIDER
10
290
165
323
minimum-energy
minimum-energy
0
500
200
5
1
NIL
HORIZONTAL

BUTTON
83
501
158
534
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
330
165
363
energy-decrement
energy-decrement
0
1
0.21
0.01
1
NIL
HORIZONTAL

SLIDER
10
90
165
123
number-of-foods
number-of-foods
1
100
75
1
1
NIL
HORIZONTAL

SLIDER
10
210
165
243
unloaded-step-length
unloaded-step-length
0
1
0.28
0.01
1
NIL
HORIZONTAL

SLIDER
10
250
165
283
loaded-step-length
loaded-step-length
0
unloaded-step-length
0.18
0.01
1
NIL
HORIZONTAL

SLIDER
10
370
165
403
vision-range
vision-range
1
10
10
0.1
1
NIL
HORIZONTAL

SLIDER
10
410
165
443
vision-angle
vision-angle
0
60
50
1
1
NIL
HORIZONTAL

SLIDER
10
450
165
483
grab-range
grab-range
0
vision-range
4.2
0.1
1
NIL
HORIZONTAL

SLIDER
10
170
165
203
max-wiggle-angle
max-wiggle-angle
0
45
45
1
1
NIL
HORIZONTAL

MONITOR
708
410
839
463
Number-agents
count turtles
3
1
13

SWITCH
278
390
409
423
show-energy?
show-energy?
1
1
-1000

PLOT
888
30
1210
292
Average Energy
NIL
NIL
0.0
100.0
0.0
150.0
true
true
"" ""
PENS
"energy" 1.0 0 -13840069 true "" ""

SLIDER
10
50
165
83
find-range
find-range
0
vision-range
1.6
.1
1
NIL
HORIZONTAL

CHOOSER
485
414
623
459
food-distribution
food-distribution
"scattered" "lump"
0

@#$#@#$#@
## WHAT IS IT?

This section could give a general understanding of what the model is trying to show or explain.

## HOW IT WORKS

This section could explain what rules the agents use to create the overall behavior of the model.

## HOW TO USE IT

This section could explain how to use the model, including a description of each of the items in the interface tab.

## THINGS TO NOTICE

This section could give some ideas of things for the user to notice while running the model.

## THINGS TO TRY

This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.

## EXTENDING THE MODEL

This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.

## NETLOGO FEATURES

This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.

## RELATED MODELS

This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.

## CREDITS AND REFERENCES

This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

ant 2
true
0
Polygon -7500403 true true 150 19 120 30 120 45 130 66 144 81 127 96 129 113 144 134 136 185 121 195 114 217 120 255 135 270 165 270 180 255 188 218 181 195 165 184 157 134 170 115 173 95 156 81 171 66 181 42 180 30
Polygon -7500403 true true 150 167 159 185 190 182 225 212 255 257 240 212 200 170 154 172
Polygon -7500403 true true 161 167 201 150 237 149 281 182 245 140 202 137 158 154
Polygon -7500403 true true 155 135 185 120 230 105 275 75 233 115 201 124 155 150
Line -7500403 true 120 36 75 45
Line -7500403 true 75 45 90 15
Line -7500403 true 180 35 225 45
Line -7500403 true 225 45 210 15
Polygon -7500403 true true 145 135 115 120 70 105 25 75 67 115 99 124 145 150
Polygon -7500403 true true 139 167 99 150 63 149 19 182 55 140 98 137 142 154
Polygon -7500403 true true 150 167 141 185 110 182 75 212 45 257 60 212 100 170 146 172

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

food
false
0
Polygon -7500403 true true 30 105 45 255 105 255 120 105
Rectangle -7500403 true true 15 90 135 105
Polygon -7500403 true true 75 90 105 15 120 15 90 90
Polygon -7500403 true true 135 225 150 240 195 255 225 255 270 240 285 225 150 225
Polygon -7500403 true true 135 180 150 165 195 150 225 150 270 165 285 180 150 180
Rectangle -7500403 true true 135 195 285 210

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Time" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="6000"/>
    <metric>mean [drag-ticks] of robots / ticks</metric>
    <enumeratedValueSet variable="number-of-bots">
      <value value="5"/>
      <value value="10"/>
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-boxes">
      <value value="5"/>
      <value value="10"/>
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="robot utilization" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="4000"/>
    <metric>count robots with [any? my-out-links] / count robots</metric>
    <steppedValueSet variable="number-of-boxes" first="5" step="5" last="20"/>
    <steppedValueSet variable="number-of-bots" first="5" step="5" last="20"/>
  </experiment>
  <experiment name="enrgy" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="4000"/>
    <metric>mean [energy] of robots</metric>
    <steppedValueSet variable="number-of-boxes" first="10" step="10" last="40"/>
    <steppedValueSet variable="number-of-bots" first="10" step="10" last="40"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
