module SE.Framework.Colors exposing (Color(..), background, base, black, border, color, danger, dangerDark, dark, darker, darkest, info, infoDark, light, lighter, lightest, link, linkDark, primary, primaryDark, success, successDark, warning, warningDark, white)

import Css exposing (hsl, rgba)


type Color
    = Primary
    | Link
    | Info
    | Success
    | Warning
    | Danger


white : Css.Color
white =
    Css.hex "#ffffff"


lightest : Css.Color
lightest =
    Css.hex "#F8FAFC"


lighter : Css.Color
lighter =
    Css.hex "#F1F5F8"


light : Css.Color
light =
    Css.rgb 218 225 231


base : Css.Color
base =
    Css.rgb 184 194 204


dark : Css.Color
dark =
    Css.hex "#8795A1"


darker : Css.Color
darker =
    Css.hex "#606F7B"


darkest : Css.Color
darkest =
    Css.rgb 61 72 82


black : Css.Color
black =
    Css.rgb 34 41 47


primary : Css.Color
primary =
    Css.rgb 53 157 55


primaryDark : Css.Color
primaryDark =
    Css.rgb 41 126 82


link : Css.Color
link =
    Css.hex "#3273dc"


linkDark : Css.Color
linkDark =
    Css.hex "#276cda"


info : Css.Color
info =
    hsl 204 0.86 0.53


infoDark : Css.Color
infoDark =
    Css.hex "#1496ed"


success : Css.Color
success =
    Css.hex "#23d160"


successDark : Css.Color
successDark =
    Css.hex "#22c65b"


warning : Css.Color
warning =
    Css.hex "#ffdd57"


warningDark : Css.Color
warningDark =
    Css.hex "#ffdb4a"


danger : Css.Color
danger =
    Css.hex "#ff3860"


dangerDark : Css.Color
dangerDark =
    Css.hex "#ff2b56"


border : Css.Color
border =
    lighter


background : Css.Color
background =
    lightest


color : Color -> Css.Color
color c =
    case c of
        Primary ->
            primary

        Link ->
            link

        Info ->
            info

        Success ->
            success

        Warning ->
            warning

        Danger ->
            danger
