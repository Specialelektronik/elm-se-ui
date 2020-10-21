module SE.UI.Container exposing (container, Modifier(..))

{-| Bulmas container tag, but max-width is set to 1680px for all devices
see <https://bulma.io/documentation/layout/container/>


# Definition

@docs container, Modifier

-}

import Css exposing (Style, auto, none, px, relative, zero)
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes as Attributes


{-| For now, only Fluid modifier is supported
-}
type Modifier
    = Fluid
    | Small


{-| A simple container to center your content horizontally
Only support the Fluid modifier, no is-widescreen or similar.
-}
container : List Modifier -> List (Html msg) -> Html msg
container modifiers =
    let
        modStyle =
            Css.batch (List.map modifier modifiers)
    in
    styled Html.Styled.div
        [ Css.margin2 zero auto
        , Css.position relative
        , Css.width (Css.pct 100)
        , Css.maxWidth (Css.calc (Css.px 1920) Css.minus (Css.rem (2 * 2.66666667)))
        , modStyle
        ]
        [ Attributes.classList [ ( "container", True ) ] ]


modifier : Modifier -> Style
modifier m =
    case m of
        Fluid ->
            Css.batch
                [ Css.maxWidth none
                , Css.width auto
                ]

        Small ->
            Css.batch
                [ -- Css.maxWidth (Css.calc (Css.px 1920) Css.minus (Css.rem (2 * 2.66666667)))
                  Css.maxWidth (Css.px 1208)
                ]
