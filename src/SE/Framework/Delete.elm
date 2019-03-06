module SE.Framework.Delete exposing (delete)

import Css exposing (Style, absolute, active, after, before, block, calc, currentColor, deg, focus, hover, inlineBlock, int, minus, none, pct, pointer, pseudoClass, px, relative, rem, rgba, rotate, top, translateX, translateY, transparent, zero)
import Css.Global exposing (descendants, each, selector, typeSelector)
import Css.Transitions
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Colors exposing (background, white)
import SE.Framework.Utils exposing (block, desktop, radius, tablet, unselectable)


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



--   &::before,
--   &::after
--     background-color: $white
--     content: ""
--     display: block
--     left: 50%
--     position: absolute
--     top: 50%
--     transform: translateX(-50%) translateY(-50%) rotate(45deg)
--     transform-origin: center center
--   &::before
--     height: 2px
--     width: 50%
--   &::after
--     height: 50%
--     width: 2px
--   &:hover,
--   &:focus
--     background-color: rgba($black, 0.3)
--   &:active
--     background-color: rgba($black, 0.4)
--   // Sizes
--   &.is-small
--     height: 16px
--     max-height: 16px
--     max-width: 16px
--     min-height: 16px
--     min-width: 16px
--     width: 16px
--   &.is-medium
--     height: 24px
--     max-height: 24px
--     max-width: 24px
--     min-height: 24px
--     min-width: 24px
--     width: 24px
--   &.is-large
--     height: 32px
--     max-height: 32px
--     max-width: 32px
--     min-height: 32px
--     min-width: 32px
--     width: 32px
