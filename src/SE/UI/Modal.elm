module SE.UI.Modal exposing (modal, fullWidthModal)

{-| Bulmas modal component
see <https://bulma.io/documentation/components/modal/>


# Definition

@docs modal, fullWidthModal

-}

import Css exposing (Style)
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import SE.UI.Colors as Colors
import SE.UI.Delete as Delete
import SE.UI.Utils as Utils


{-| The modal does not have an active state, to close the modal, simple don't render it.
-}
modal : msg -> List (Html msg) -> Html msg
modal closeMsg c =
    styled Html.Styled.div
        modalStyles
        [ Attributes.classList [ ( "modal", True ) ] ]
        [ styled Html.Styled.div modalBackgroundStyles [ Events.onClick closeMsg ] []
        , styled Html.Styled.div modalContentStyles [] c
        , Delete.large closeStyles closeMsg
        ]


{-| Identical to `modal` except it uses the full width of the browser window so show its content.
-}
fullWidthModal : msg -> List (Html msg) -> Html msg
fullWidthModal closeMsg c =
    styled Html.Styled.div
        modalStyles
        []
        [ styled Html.Styled.div modalBackgroundStyles [ Events.onClick closeMsg ] []
        , styled Html.Styled.div fullWidthModalContentStyles [] c
        , Delete.large closeStyles closeMsg
        ]


modalStyles : List Style
modalStyles =
    [ overlay 0
    , Css.alignItems Css.center
    , Css.flexDirection Css.column
    , Css.displayFlex
    , Css.justifyContent Css.center
    , Css.overflow Css.hidden
    , Css.position Css.fixed
    , Css.zIndex (Css.int 40)
    ]


modalBackgroundStyles : List Style
modalBackgroundStyles =
    [ overlay 0
    , Css.backgroundColor (Css.rgba 0 0 0 0.7)
    ]


modalContentStyles : List Style
modalContentStyles =
    [ Css.margin2 Css.zero (Css.px 20)
    , Css.maxHeight (Css.calc (Css.vh 100) Css.minus (Css.px 160))
    , Css.overflow Css.auto
    , Css.position Css.relative
    , Css.width (Css.pct 100)
    , Utils.tablet
        [ Css.margin2 Css.zero Css.auto
        , Css.maxHeight (Css.calc (Css.vh 100) Css.minus (Css.px 40))
        , Css.width (Css.px 640)
        ]
    ]


fullWidthModalContentStyles : List Style
fullWidthModalContentStyles =
    -- [ Css.margin Css.zero
    -- , Css.overflow Css.auto
    -- , Css.position Css.absolute
    -- , Css.top Css.zero
    -- , Css.right Css.zero
    -- , Css.bottom Css.zero
    -- , Css.left Css.zero
    -- ]
    [ Css.margin Css.zero
    , Css.maxHeight (Css.calc (Css.vh 100) Css.minus (Css.px 160))
    , Css.overflow Css.auto
    , Css.position Css.relative
    , Css.width (Css.pct 100)
    , Utils.tablet
        [ Css.margin2 Css.zero Css.auto
        , Css.maxHeight (Css.calc (Css.vh 100) Css.minus (Css.px 40))

        -- , Css.width (Css.px 640)
        ]
    ]


closeStyles : List Style
closeStyles =
    [ Css.backgroundImage Css.none
    , Css.height (Css.px 40)
    , Css.position Css.fixed
    , Css.right (Css.px 20)
    , Css.top (Css.px 20)
    , Css.width (Css.px 40)
    , Colors.backgroundColor Colors.white
    , Css.hover
        [ Colors.backgroundColor (Colors.white |> Colors.hover)
        ]
    , Css.focus
        [ Colors.backgroundColor (Colors.white |> Colors.hover)
        ]
    , Css.active
        [ Colors.backgroundColor (Colors.white |> Colors.active)
        ]
    , Css.before
        [ Colors.backgroundColor Colors.black
        ]
    , Css.after
        [ Colors.backgroundColor Colors.black
        ]
    ]


overlay : Float -> Style
overlay offset =
    Css.batch
        [ Css.bottom (Css.px offset)
        , Css.left (Css.px offset)
        , Css.position Css.absolute
        , Css.right (Css.px offset)
        , Css.top (Css.px offset)
        ]



-- afterAndbefore : List Style
-- afterAndbefore =
--     [ Css.backgroundColor white
--     , Css.property "content" "\"\""
--     , Css.display Css.block
--     , Css.left (Css.pct 50)
--     , Css.position Css.absolute
--     , Css.top (Css.pct 50)
--     , Css.transforms [ translateX (Css.pct -50), translateY (Css.pct -50), rotate (deg 45) ]
--     , Css.Transitions.transition [ Css.Transitions.transformOrigin 50 ]
--     ]
