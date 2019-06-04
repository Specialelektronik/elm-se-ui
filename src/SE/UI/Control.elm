module SE.UI.Control exposing (controlHeight, controlStyle, Size(..))

{-| Helper functions for form elements and buttons.

@docs controlHeight, controlStyle, Size

-}

import Css exposing (Style, active, alignItems, border3, borderRadius, boxShadow, boxShadow5, center, cursor, disabled, display, em, flexStart, focus, fontSize, height, inlineFlex, justifyContent, lineHeight, none, notAllowed, num, paddingBottom, paddingLeft, paddingRight, paddingTop, position, property, px, relative, rem, rgba, solid, top, transparent, verticalAlign, zero)
import SE.UI.Utils exposing (radius, smallRadius)


{-| Form input controls and buttons use this type as an argument to their Size Modifier
-}
type Size
    = Regular
    | Small
    | Medium
    | Large


controlBorderWidth : Css.Px
controlBorderWidth =
    px 1


{-| Height used for controls like buttons and text inputs.
-}
controlHeight : Css.Em
controlHeight =
    em 2.5


controlLineHeight : Css.Em
controlLineHeight =
    em 1.5


{-| "Normalized" style for controls like buttons and input text fields.
-}
controlStyle : Size -> Style
controlStyle size =
    Css.batch
        [ property "-moz-appearance" "none"
        , property "-webkit-appearance" "none"
        , alignItems center
        , border3 controlBorderWidth solid transparent
        , boxShadow none
        , display inlineFlex
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
        , modifier size
        ]


modifier : Size -> Style
modifier size =
    Css.batch
        (case size of
            Regular ->
                [ Css.fontSize (px 16)
                , Css.borderRadius radius
                ]

            Small ->
                [ Css.fontSize (px 12)
                , Css.borderRadius smallRadius
                ]

            Medium ->
                [ Css.fontSize (px 20)
                , Css.borderRadius radius
                ]

            Large ->
                [ Css.fontSize (px 24)
                , Css.borderRadius radius
                ]
        )
