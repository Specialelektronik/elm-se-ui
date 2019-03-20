module SE.Framework.Utils exposing (block, centerEm, desktop, desktopWidth, gap, loader, mobile, onChange, overflowTouch, radius, smallRadius, tablet, tabletWidth, unselectable)

import Css exposing (Style, absolute, block, calc, deg, em, infinite, minus, ms, pct, pseudoClass, px, relative, rem, rotate, solid, transparent)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Media as Media exposing (all, maxWidth, minWidth, only, print, screen)
import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (on)
import Json.Decode as Json
import SE.Framework.Colors exposing (light)


{-| Pixel value
-}
gap : Float
gap =
    64


desktopWidth : Float
desktopWidth =
    960 + (2 * gap)


tabletWidth : Float
tabletWidth =
    769



-- @media screen and (min-width: $desktop)


desktop : List Style -> Style
desktop =
    Media.withMedia [ only screen [ minWidth (px desktopWidth) ] ]


{-| TODO add support for print to this since Bulma has it
-}
tablet : List Style -> Style
tablet =
    Media.withMedia [ only screen [ minWidth (px tabletWidth) ] ]


mobile : List Style -> Style
mobile =
    Media.withMedia [ only screen [ maxWidth (px (tabletWidth - 1)) ] ]


radius : Css.Px
radius =
    px 4


smallRadius : Css.Px
smallRadius =
    px 2


loader : Style
loader =
    Css.batch
        [ Css.animationName spinAround
        , Css.animationDuration (ms 500)
        , Css.property "animation-iteration-count" "infinite"
        , Css.property "animation-timing-function" "linear"
        , Css.border3 (px 2) solid light
        , Css.borderRadius (pct 50)
        , Css.borderRightColor transparent
        , Css.borderTopColor transparent
        , Css.property "content" "\"\""
        , Css.display Css.block
        , Css.height (em 1)
        , Css.position relative
        , Css.width (em 1)
        ]


spinAround : Keyframes {}
spinAround =
    keyframes
        [ ( 0
          , [ Css.Animations.transform [ rotate (deg 0) ]
            ]
          )
        , ( 100
          , [ Css.Animations.transform [ rotate (deg 359) ]
            ]
          )
        ]


onChange : (String -> msg) -> Html.Styled.Attribute msg
onChange handler =
    on "change" <| Json.map handler <| Json.at [ "target", "value" ] Json.string


block : Style
block =
    pseudoClass "not(:last-child)"
        [ Css.marginBottom (rem 1.5)
        ]


unselectable : Style
unselectable =
    Css.batch
        [ Css.property "-webkit-touch-callout" "none"
        , Css.property "-webkit-user-select" "none"
        , Css.property "-moz-user-select" "none"
        , Css.property "-ms-user-select" "none"
        , Css.property "user-select" "none"
        ]


overflowTouch : Style
overflowTouch =
    Css.property "-webkit-overflow-scrolling" "touch"


centerEm : Float -> Float -> Style
centerEm width height =
    Css.batch
        [ Css.position absolute
        , Css.left (calc (pct 50) minus (em (width / 2)))
        , Css.top
            (if height /= 0 then
                calc (pct 50) minus (em (height / 2))

             else
                calc (pct 50) minus (em (width / 2))
            )
        ]
