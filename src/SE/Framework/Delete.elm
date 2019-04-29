module SE.Framework.Delete exposing (delete)

{-| Bulmas delete tag
see <https://bulma.io/documentation/elements/delete/>

#Definition

@docs delete

-}

import Css exposing (Style, absolute, active, after, before, block, currentColor, deg, focus, hover, inlineBlock, int, minus, none, pct, pointer, pseudoClass, px, relative, rem, rgba, rotate, top, translateX, translateY, transparent, zero)
import Css.Global exposing (descendants, each, selector, typeSelector)
import Css.Transitions
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Colors exposing (background, white)
import SE.Framework.Utils exposing (block, desktop, radius, tablet, unselectable)


{-| A simple circle with a cross, no support for sizes.
You can supply custom styles with the first argument.
-}
delete : List Style -> msg -> Html msg
delete styles msg =
    styled Html.Styled.button
        (deleteStyles ++ styles)
        [ onClick msg ]
        []


deleteStyles : List Style
deleteStyles =
    [ unselectable
    , Css.property "-moz-appearance" "none"
    , Css.property "-webkit-appearance" "none"
    , Css.backgroundColor (rgba 34 41 47 0.2)
    , Css.border Css.initial
    , Css.borderRadius (pct 50)
    , Css.cursor pointer
    , Css.property "pointer-events" "auto"
    , Css.display inlineBlock
    , Css.flexGrow zero
    , Css.flexShrink zero
    , Css.fontSize (px 0)
    , Css.height (px 20)
    , Css.maxHeight (px 20)
    , Css.maxWidth (px 20)
    , Css.minHeight (px 20)
    , Css.minWidth (px 20)
    , Css.outline none
    , Css.position relative
    , Css.verticalAlign top
    , Css.width (px 20)
    , after
        (afterAndbefore
            ++ [ Css.height (pct 50)
               , Css.width (px 2)
               ]
        )
    , before
        (afterAndbefore
            ++ [ Css.height (px 2)
               , Css.width (pct 50)
               ]
        )
    , hover [ Css.backgroundColor (rgba 34 41 47 0.3) ]
    , focus [ Css.backgroundColor (rgba 34 41 47 0.3) ]
    , active [ Css.backgroundColor (rgba 34 41 47 0.4) ]
    ]


afterAndbefore : List Style
afterAndbefore =
    [ Css.backgroundColor white
    , Css.property "content" "\"\""
    , Css.display Css.block
    , Css.left (pct 50)
    , Css.position absolute
    , Css.top (pct 50)
    , Css.transforms [ translateX (pct -50), translateY (pct -50), rotate (deg 45) ]
    , Css.Transitions.transition [ Css.Transitions.transformOrigin 50 ]
    ]
