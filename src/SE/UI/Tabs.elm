module SE.UI.Tabs exposing
    ( tabs
    , link, Modifier(..)
    )

{-| DEPRECATED! Use SE.UI.Tabs.V2 instead.

Bulmas Tags component
see <https://bulma.io/documentation/components/tabs/>


# Container

@docs tabs


# Links

@docs link, Modifier

-}

import Css exposing (Style, auto, center, em, flexStart, hidden, hover, int, noWrap, px, rem, solid, spaceBetween, stretch, top, zero)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes
import SE.UI.Colors as Colors
import SE.UI.Utils exposing (block, overflowTouch, unselectable)


type Link msg
    = Link IsActive String (List (Html msg))


type alias IsActive =
    Bool


{-| Only medium sized tabs are supported.
-}
type Modifier
    = Medium



-- TABS


{-| Currently, only the Medium size modifier is supported, no boxed, fullwidth or anything else.
-}
tabs : List Modifier -> List (Link msg) -> Html msg
tabs mods links =
    styled Html.Styled.nav
        [ navStyle, navModifiers mods ]
        []
        [ styled Html.Styled.ul ulStyles [] (List.map linkToHtml links)
        ]


navStyle : Style
navStyle =
    Css.batch
        [ block
        , unselectable
        , overflowTouch
        , Css.alignItems stretch
        , Css.displayFlex
        , Css.fontSize (rem 1)
        , Css.justifyContent spaceBetween
        , Css.overflow hidden
        , Css.overflowX auto
        , Css.whiteSpace noWrap
        ]


navModifiers : List Modifier -> Style
navModifiers mods =
    Css.batch (List.map navModifier mods)


navModifier : Modifier -> Style
navModifier mod =
    case mod of
        Medium ->
            Css.fontSize (em 1.5)


ulStyles : List Style
ulStyles =
    [ Css.alignItems center
    , Css.borderBottomColor (Colors.border |> Colors.toCss)
    , Css.borderBottomStyle solid
    , Css.borderBottomWidth (px 1)
    , Css.displayFlex
    , Css.flexGrow (int 1)
    , Css.flexShrink zero
    , Css.justifyContent flexStart
    ]



-- LINK


{-| An active link is rendered as a blue link, non-active are rendered av dark text.

    link False "https://example.com/" [ text "Go to example.com" ]

-}
link : IsActive -> String -> List (Html msg) -> Link msg
link =
    Link


linkToHtml : Link msg -> Html msg
linkToHtml (Link isActive url html) =
    styled Html.Styled.li
        (liStyles isActive)
        []
        [ styled
            Html.Styled.a
            (aStyles isActive)
            [ Html.Styled.Attributes.href url ]
            html
        ]


liStyles : IsActive -> List Style
liStyles isActive =
    [ Css.display Css.block
    ]


aStyles : IsActive -> List Style
aStyles isActive =
    [ Css.alignItems center
    , Css.borderBottomColor (Colors.border |> Colors.toCss)
    , Css.borderBottomStyle solid
    , Css.borderBottomWidth (px 1)
    , Colors.color Colors.text
    , Css.displayFlex
    , Css.justifyContent center
    , Css.marginBottom (px -1)
    , Css.padding2 (em 0.5) (em 1)
    , Css.verticalAlign top
    , hover
        [ Colors.color (Colors.border |> Colors.hover)
        , Css.borderBottomColor (Colors.border |> Colors.hover |> Colors.toCss)
        ]
    , if isActive then
        Css.batch
            [ Css.borderBottomColor (Colors.link |> Colors.hover |> Colors.toCss)
            , Colors.color Colors.link
            ]

      else
        Css.batch []
    ]
