module SE.Framework.Utils exposing
    ( mobile, tabletWidth, tablet, desktopWidth, desktop, widescreenWidth, widescreen, extendedWidth, extended, fullhdWidth, fullhd
    , loader
    , onChange
    , block, centerEm, overflowTouch, unselectable
    , gap, radius, smallRadius
    )

{-| Utility functions mostly used by the framework itself.

Mostly notably is the extra breakpoint we have compared to Bulma. Bulmas "fullhd" has been renamed to "extended" and fullhd is not targeting screens with 1920 pixel resolution or above.


# Media queries

@docs mobile, tabletWidth, tablet, desktopWidth, desktop, widescreenWidth, widescreen, extendedWidth, extended, fullhdWidth, fullhd


# Animation helpers

@docs loader


# Events

@docs onChange


# Helpers

@docs block, centerEm, overflowTouch, unselectable


# Constants

@docs gap, radius, smallRadius

-}

import Css exposing (Style, absolute, block, calc, deg, em, infinite, minus, ms, pct, pseudoClass, px, relative, rem, rotate, solid, transparent)
import Css.Animations exposing (Keyframes, keyframes)
import Css.Media as Media exposing (all, maxWidth, minWidth, only, print, screen)
import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (on)
import Json.Decode as Json
import SE.Framework.Colors exposing (light)


{-| Column gap in pixels
-}
gap : Float
gap =
    64


{-| Threshold for tablets
-}
tabletWidth : Float
tabletWidth =
    769


{-| Threshold for desktops
-}
desktopWidth : Float
desktopWidth =
    960 + (2 * gap)


{-| Threshold for widescreens
-}
widescreenWidth : Float
widescreenWidth =
    1152 + (2 * gap)


{-| Threshold for extendeds
-}
extendedWidth : Float
extendedWidth =
    1344 + (2 * gap)


{-| Threshold for fullHDs
-}
fullhdWidth : Float
fullhdWidth =
    1776 + (2 * gap)


{-| Media query for mobile devices
-}
mobile : List Style -> Style
mobile =
    Media.withMedia [ only screen [ maxWidth (px (tabletWidth - 1)) ] ]


{-| Media query that maps to @media screen and (min-width: $tablet)
TODO add support for print to this since Bulma has it
-}
tablet : List Style -> Style
tablet =
    Media.withMedia [ only screen [ minWidth (px tabletWidth) ] ]


{-| Media query that maps to @media screen and (min-width: $desktop)
-}
desktop : List Style -> Style
desktop =
    Media.withMedia [ only screen [ minWidth (px desktopWidth) ] ]


{-| Media query that maps to @media screen and (min-width: $widescreen)
-}
widescreen : List Style -> Style
widescreen =
    Media.withMedia [ only screen [ minWidth (px widescreenWidth) ] ]


{-| Media query that maps to @media screen and (min-width: $extended)
-}
extended : List Style -> Style
extended =
    Media.withMedia [ only screen [ minWidth (px extendedWidth) ] ]


{-| Media query that maps to @media screen and (min-width: $fullhd)
-}
fullhd : List Style -> Style
fullhd =
    Media.withMedia [ only screen [ minWidth (px fullhdWidth) ] ]


{-| Standard radius value
-}
radius : Css.Px
radius =
    px 2


{-| Small radius value
-}
smallRadius : Css.Px
smallRadius =
    px 1


{-| Loading spinner animation
-}
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


{-| onChange event is used on select form elements
-}
onChange : (String -> msg) -> Html.Styled.Attribute msg
onChange handler =
    on "change" <| Json.map handler <| Json.at [ "target", "value" ] Json.string


{-| Block class used by .field, p etc
-}
block : Style
block =
    pseudoClass "not(:last-child)"
        [ Css.marginBottom (rem 1.5)
        ]


{-| Make an element unselectable
-}
unselectable : Style
unselectable =
    Css.batch
        [ Css.property "-webkit-touch-callout" "none"
        , Css.property "-webkit-user-select" "none"
        , Css.property "-moz-user-select" "none"
        , Css.property "-ms-user-select" "none"
        , Css.property "user-select" "none"
        ]


{-| Use momentum based scolling
see <https://developer.mozilla.org/en-US/docs/Web/CSS/-webkit-overflow-scrolling#Values>
-}
overflowTouch : Style
overflowTouch =
    Css.property "-webkit-overflow-scrolling" "touch"


{-| Center element
-}
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
