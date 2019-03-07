module SE.Framework.Tabs exposing (Modifier(..), activeLink, link, tabs)

import Css exposing (Style, auto, center, default, em, flex, flexStart, hidden, hover, int, noWrap, none, px, rem, solid, spaceBetween, stretch, top, wrap, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, selector, typeSelector)
import Css.Transitions
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes
import SE.Framework.Colors as Colors exposing (background, white)
import SE.Framework.Utils exposing (block, desktop, overflowTouch, radius, tablet, unselectable)


type Link msg
    = Link IsActive String (List (Html msg))


type alias IsActive =
    Bool


type Modifier
    = Medium


link : String -> List (Html msg) -> Link msg
link =
    Link False


activeLink : String -> List (Html msg) -> Link msg
activeLink =
    Link True


tabs : List Modifier -> List (Link msg) -> Html msg
tabs mods links =
    styled Html.Styled.nav
        [ navStyle, navModifiers mods ]
        []
        [ styled Html.Styled.ul ulStyles [] (List.map linkToHtml links)
        ]


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
    , Css.borderBottomColor Colors.border
    , Css.borderBottomStyle solid
    , Css.borderBottomWidth (px 1)
    , Css.displayFlex
    , Css.flexGrow (int 1)
    , Css.flexShrink zero
    , Css.justifyContent flexStart
    ]


liStyles : IsActive -> List Style
liStyles isActive =
    [ Css.display Css.block
    ]


aStyles : IsActive -> List Style
aStyles isActive =
    [ Css.alignItems center
    , Css.borderBottomColor Colors.border
    , Css.borderBottomStyle solid
    , Css.borderBottomWidth (px 1)
    , Css.color Colors.text
    , Css.displayFlex
    , Css.justifyContent center
    , Css.marginBottom (px -1)
    , Css.padding2 (em 0.5) (em 1)
    , Css.verticalAlign top
    , hover
        [ Css.color Colors.linkHover
        , Css.borderBottomColor Colors.linkHover
        ]
    , if isActive then
        Css.batch
            [ Css.borderBottomColor Colors.link
            , Css.color Colors.link
            ]

      else
        Css.batch []
    ]
