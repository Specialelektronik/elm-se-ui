module SE.UI.Modal exposing (modal)

{-| Bulmas modal component
see <https://bulma.io/documentation/components/modal/>


# Definition

@docs modal

-}

import Css exposing (Style, absolute, auto, calc, center, column, fixed, hidden, int, minus, none, pct, px, relative, rgba, vh, zero)
import Html.Styled exposing (Html, styled)
import Html.Styled.Events exposing (onClick)
import SE.UI.Delete exposing (delete)
import SE.UI.Utils exposing (tablet)


{-| The modal does not have an active state, to close the modal, simple don't render it.
-}
modal : msg -> List (Html msg) -> Html msg
modal closeMsg c =
    styled Html.Styled.div
        modalStyles
        []
        [ styled Html.Styled.div modalBackgroundStyles [ onClick closeMsg ] []
        , styled Html.Styled.div modalContentStyles [] c
        , delete closeStyles closeMsg
        ]


modalStyles : List Style
modalStyles =
    [ overlay 0
    , Css.alignItems center
    , Css.flexDirection column
    , Css.displayFlex
    , Css.justifyContent center
    , Css.overflow hidden
    , Css.position fixed
    , Css.zIndex (int 40)
    ]


modalBackgroundStyles : List Style
modalBackgroundStyles =
    [ overlay 0
    , Css.backgroundColor (rgba 0 0 0 0.86)
    ]


modalContentStyles : List Style
modalContentStyles =
    [ Css.margin2 zero (px 20)
    , Css.maxHeight (calc (vh 100) minus (px 160))
    , Css.overflow auto
    , Css.position relative
    , Css.width (pct 100)
    , tablet
        [ Css.margin2 zero auto
        , Css.maxHeight (calc (vh 100) minus (px 40))
        , Css.width (px 640)
        ]
    ]


closeStyles : List Style
closeStyles =
    [ Css.backgroundImage none
    , Css.height (px 40)
    , Css.position fixed
    , Css.right (px 20)
    , Css.top (px 20)
    , Css.width (px 40)
    ]


overlay : Float -> Style
overlay offset =
    Css.batch
        [ Css.bottom (px offset)
        , Css.left (px offset)
        , Css.position absolute
        , Css.right (px offset)
        , Css.top (px offset)
        ]



-- afterAndbefore : List Style
-- afterAndbefore =
--     [ Css.backgroundColor white
--     , Css.property "content" "\"\""
--     , Css.display Css.block
--     , Css.left (pct 50)
--     , Css.position absolute
--     , Css.top (pct 50)
--     , Css.transforms [ translateX (pct -50), translateY (pct -50), rotate (deg 45) ]
--     , Css.Transitions.transition [ Css.Transitions.transformOrigin 50 ]
--     ]
