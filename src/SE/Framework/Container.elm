module SE.Framework.Container exposing (container, Modifier(..))

{-| Bulmas container tag
see <https://bulma.io/documentation/layout/container/>


# Definition

@docs container, Modifier

-}

import Css exposing (Style, auto, none, px, relative, zero)
import Html.Styled exposing (Attribute, Html, styled, text)
import SE.Framework.Utils exposing (desktop, desktopWidth, gap)


{-| For now, only Fluid modifier is supported
-}
type Modifier
    = Fluid


{-| A simple container to center your content horizontally
Only support the Fluid modifier, no is-widescreen or similar.
-}
container : List Modifier -> List (Html msg) -> Html msg
container modifiers =
    styled Html.Styled.div
        [ Css.margin2 zero auto
        , Css.position relative
        , desktop
            [ Css.maxWidth (px (desktopWidth - (2 * gap)))
            , Css.width (px (desktopWidth - (2 * gap)))
            , List.map modifier modifiers |> Css.batch
            ]
        ]
        []


modifier : Modifier -> Style
modifier m =
    case m of
        Fluid ->
            Css.batch
                [ Css.marginLeft (px gap)
                , Css.marginRight (px gap)
                , Css.maxWidth none
                , Css.width auto
                ]
