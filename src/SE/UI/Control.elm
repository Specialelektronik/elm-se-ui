module SE.UI.Control exposing (controlHeight, controlStyle, Size(..))

{-| Helper functions for form elements and buttons.

@docs controlHeight, controlStyle, Size

-}

import Css exposing (Style, active, alignItems, border3, borderRadius, boxShadow, center, cursor, disabled, display, em, flexStart, focus, fontSize, height, inlineFlex, justifyContent, lineHeight, none, notAllowed, paddingBottom, paddingLeft, paddingRight, paddingTop, position, property, px, relative, solid, top, transparent, verticalAlign)
import SE.UI.Colors as Colors
import SE.UI.Utils as Utils exposing (radius, smallRadius)


{-| Form input controls and buttons use this type as an argument to their Size Modifier
-}
type Size
    = Regular
    | Small
    | Medium
    | Large


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
        [ Css.property "-moz-appearance" "none"
        , Css.property "-webkit-appearance" "none"
        , Css.property "appearance" "none"
        , alignItems center
        , border3 (Css.px 1) solid transparent
        , boxShadow none
        , display inlineFlex

        -- , height controlHeight
        , justifyContent flexStart
        , lineHeight controlLineHeight
        , Css.property "padding" "calc(0.5em - 1px) calc(0.75em - 1px)"
        , Utils.desktop
            [ Css.property "padding" "calc(0.75em - 1px)"
            ]
        , Colors.backgroundColor Colors.background
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
