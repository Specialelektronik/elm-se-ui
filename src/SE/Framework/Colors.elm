module SE.Framework.Colors exposing (background, backgroundActive, backgroundHover, base, black, border, callToAction, callToActionActive, callToActionHover, danger, dangerActive, dangerHover, dark, darker, darkest, info, infoActive, infoHover, light, lighter, lightest, link, linkActive, linkHover, primary, primaryActive, primaryHover, success, successActive, successHover, text, warning, warningActive, warningHover, white)

import Css exposing (hsl, rgba)


white : Css.Color
white =
    Css.rgb 255 255 255


lightest : Css.Color
lightest =
    Css.rgb 248 250 252


lighter : Css.Color
lighter =
    Css.rgb 241 245 248


light : Css.Color
light =
    Css.rgb 218 225 231


base : Css.Color
base =
    Css.rgb 184 194 204


dark : Css.Color
dark =
    Css.rgb 135 149 161


darker : Css.Color
darker =
    Css.rgb 96 111 123


darkest : Css.Color
darkest =
    Css.rgb 61 72 82


black : Css.Color
black =
    Css.rgb 34 41 47


primary : Css.Color
primary =
    Css.rgb 53 157 55


primaryHover : Css.Color
primaryHover =
    Css.rgb 47 138 48


primaryActive : Css.Color
primaryActive =
    Css.rgb 40 119 42


link : Css.Color
link =
    Css.rgb 50 115 220


linkHover : Css.Color
linkHover =
    Css.rgb 36 102 209


linkActive : Css.Color
linkActive =
    Css.rgb 32 91 187


info : Css.Color
info =
    Css.rgb 32 156 238


infoHover : Css.Color
infoHover =
    Css.rgb 17 143 228


infoActive : Css.Color
infoActive =
    Css.rgb 15 129 204


success : Css.Color
success =
    primary


successHover : Css.Color
successHover =
    primaryHover


successActive : Css.Color
successActive =
    primaryActive


warning : Css.Color
warning =
    Css.rgb 255 221 87


warningHover : Css.Color
warningHover =
    Css.rgb 255 216 62


warningActive : Css.Color
warningActive =
    Css.rgb 255 211 36


callToAction : Css.Color
callToAction =
    Css.rgb 239 142 0


callToActionHover : Css.Color
callToActionHover =
    Css.rgb 226 134 0


callToActionActive : Css.Color
callToActionActive =
    Css.rgb 214 127 0


danger : Css.Color
danger =
    Css.rgb 255 56 96


dangerHover : Css.Color
dangerHover =
    Css.rgb 255 31 76


dangerActive : Css.Color
dangerActive =
    Css.rgb 255 5 55


border : Css.Color
border =
    light


background : Css.Color
background =
    lightest


backgroundHover : Css.Color
backgroundHover =
    lighter


backgroundActive : Css.Color
backgroundActive =
    light


text : Css.Color
text =
    darkest
