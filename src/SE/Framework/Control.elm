module SE.Framework.Control exposing (controlStyle)

import Css exposing (Style, active, alignItems, border3, borderRadius, boxShadow, boxShadow5, center, cursor, disabled, display, em, flexStart, focus, fontSize, height, inlineFlex, justifyContent, lineHeight, none, notAllowed, num, paddingBottom, paddingLeft, paddingRight, paddingTop, position, property, px, relative, rem, rgba, solid, top, transparent, verticalAlign, zero)


controlBorderWidth =
    px 1


controlRadius =
    rem 0.25


controlHeight =
    em 2.5


controlLineHeight =
    num 1.5


controlStyle : Style
controlStyle =
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
        , focus
            [ Css.outline none
            ]
        , active
            [ Css.outline none
            ]
        , disabled
            [ Css.cursor notAllowed
            ]
        ]
