module SE.Framework.Control exposing (control)

import Css exposing (Style, alignItems, border3, borderRadius, boxShadow, boxShadow5, center, display, em, flexStart, fontSize, height, inlineFlex, justifyContent, lineHeight, none, num, paddingBottom, paddingLeft, paddingRight, paddingTop, position, property, px, relative, rem, rgba, solid, top, transparent, verticalAlign, zero)


controlBorderWidth =
    px 1


controlRadius =
    rem 0.25


controlHeight =
    em 2.25


controlLineHeight =
    num 1.5


control : Style
control =
    Css.batch
        [ property "-moz-appearance" "none"
        , property "-webkit-appearance" "none"
        , alignItems center
        , border3 controlBorderWidth solid transparent
        , borderRadius controlRadius
        , boxShadow none
        , display inlineFlex
        , fontSize (px 16)
        , height controlHeight
        , justifyContent flexStart
        , lineHeight controlLineHeight
        , paddingBottom (em 0.375)
        , paddingLeft (em 0.75)
        , paddingRight (em 0.75)
        , paddingTop (em 0.375)
        , position relative
        , verticalAlign top
        ]
