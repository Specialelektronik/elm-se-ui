module SE.Framework.Utils exposing (desktop, desktopWidth, gap, loader, onChange, radius, tablet, tabletWidth)

import Css exposing (Style, block, deg, em, infinite, ms, pct, px, relative, rotate, solid, transparent)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Media as Media exposing (all, minWidth, only, print, screen)
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


radius : Css.Px
radius =
    px 4


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
        , Css.display block
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
