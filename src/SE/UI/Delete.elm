module SE.UI.Delete exposing (small, regular, medium, large)

{-| Bulmas delete tag
see <https://bulma.io/documentation/elements/delete/>


# Definition

@docs small, regular, medium, large

-}

import Css exposing (Style, absolute, active, after, before, block, deg, focus, hover, inlineBlock, none, pct, pointer, px, relative, rgba, rotate, top, translateX, translateY, zero)
import Css.Transitions
import Html.Styled exposing (Html, styled)
import Html.Styled.Events exposing (onClick)
import SE.UI.Colors as Colors
import SE.UI.Utils as Utils


type Size
    = Small
    | Regular
    | Medium
    | Large


sizeToPx : Size -> Css.Px
sizeToPx size =
    Css.px
        (case size of
            Small ->
                16

            Regular ->
                20

            Medium ->
                28

            Large ->
                40
        )


{-| Small delete button (16px)
-}
small : List Style -> msg -> Html msg
small =
    helper Small


{-| Regular delete button (20px)
-}
regular : List Style -> msg -> Html msg
regular =
    helper Regular


{-| Medium delete button (28px)
-}
medium : List Style -> msg -> Html msg
medium =
    helper Medium


{-| Large delete button (40px)
-}
large : List Style -> msg -> Html msg
large =
    helper Large


{-| A simple circle with a cross.
You can supply custom styles with the first argument.
-}
helper : Size -> List Style -> msg -> Html msg
helper size styles msg =
    styled Html.Styled.button
        (deleteStyles size ++ styles)
        [ onClick msg ]
        [ Utils.visuallyHidden Html.Styled.span [] [ Html.Styled.text "Stäng" ] ]


deleteStyles : Size -> List Style
deleteStyles size =
    let
        pxSize =
            sizeToPx size
    in
    [ Utils.unselectable
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
    , Css.height pxSize
    , Css.maxHeight pxSize
    , Css.maxWidth pxSize
    , Css.minHeight pxSize
    , Css.minWidth pxSize
    , Css.outline none
    , Css.position relative
    , Css.verticalAlign top
    , Css.width pxSize
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
    [ Colors.backgroundColor Colors.white
    , Css.property "content" "\"\""
    , Css.display Css.block
    , Css.left (pct 50)
    , Css.position absolute
    , Css.top (pct 50)
    , Css.transforms [ translateX (pct -50), translateY (pct -50), rotate (deg 45) ]
    , Css.Transitions.transition [ Css.Transitions.transformOrigin 50 ]
    ]
