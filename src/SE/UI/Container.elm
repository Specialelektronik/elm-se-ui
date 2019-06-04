module SE.UI.Container exposing (container, Modifier(..))

{-| Bulmas container tag
see <https://bulma.io/documentation/layout/container/>


# Definition

@docs container, Modifier

-}

import Css exposing (Style, auto, none, px, relative, zero)
import Html.Styled exposing (Attribute, Html, styled, text)
import SE.UI.Utils as Utils exposing (desktop, desktopWidth, extended, extendedWidth, fullhd, fullhdWidth, gap, widescreen, widescreenWidth)


{-| For now, only Fluid modifier is supported
-}
type Modifier
    = Fluid


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
        , fullhd
            [ Css.maxWidth (px (fullhdWidth - (2 * gap)))
            , Css.width (px (fullhdWidth - (2 * gap)))
            , modStyle
            ]
        , extended
            [ Css.maxWidth (px (extendedWidth - (2 * gap)))
            , Css.width (px (extendedWidth - (2 * gap)))
            , modStyle
            ]
        , widescreen
            [ Css.maxWidth (px (widescreenWidth - (2 * gap)))
            , Css.width (px (widescreenWidth - (2 * gap)))
            , modStyle
            ]
        , desktop
            [ Css.maxWidth (px (desktopWidth - (2 * gap)))
            , Css.width (px (desktopWidth - (2 * gap)))
            , modStyle
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
