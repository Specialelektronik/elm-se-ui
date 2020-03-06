module Navbar exposing (view)

import Css exposing (Style)
import Css.Global
import Dict
import Html.Styled as Html exposing (Html, a, div, header, hr, li, nav, span, styled, text, ul)
import Html.Styled.Attributes as Attributes exposing (attribute, href)
import Html.Styled.Events as Events
import SE.UI.Colors as Colors
import SE.UI.Control as Control exposing (controlStyle)
import SE.UI.Icon as Icon
import SE.UI.Logo as Logo
import SE.UI.Utils as Utils


type Mode
    = Light
    | Automatic


navbarHeight =
    Css.rem 3.75


navbarLinkColor =
    Colors.darkest


navbarItemHoverBackgroundColor =
    Colors.light


navbarItemHoverColor =
    Colors.link


view : Html msg
view =
    styled header
        headerStyles
        []
        [ styled nav
            navStyles
            [ attribute "role" "navigation"
            , attribute "ariaLabel" "main navigation"
            ]
            [ brand
            , menu
                []
                []
            ]
        , viewRibbon

        -- , viewCategories
        ]


brand : Html msg
brand =
    styled div
        brandStyles
        []
        [ styled a
            itemAndLinkStyles
            [ href "/" ]
            [ Logo.onWhite
            ]
        ]


menu : List (Html msg) -> List (Html msg) -> Html msg
menu startItems endItems =
    styled div
        menuStyles
        []
        [ styled div startStyles [] startItems
        , styled div endStyles [] endItems
        ]


item : List (Html msg) -> Html msg
item =
    styled div (itemAndLinkStyles ++ itemStyles) []


link : String -> String -> Html msg
link label url =
    styled a linkStyles [ href url ] [ text label ]


viewRibbon : Html msg
viewRibbon =
    styled hr
        ribbonStyles
        []
        []


viewCategories : Html msg
viewCategories =
    let
        forest =
            [ "Components" ]
    in
    styled nav
        [ Css.backgroundColor Colors.white
        ]
        []
        [ styled ul
            [ Css.displayFlex
            , Css.boxShadow4 Css.zero (Css.px 5) (Css.px 5) Colors.border

            -- , Css.borderBottom3 (Css.px 1) Css.solid Colors.border
            ]
            []
            (List.map viewCategoryItem forest)
        ]


viewCategoryItem : String -> Html msg
viewCategoryItem tree =
    li
        []
        [ styled a
            [ Css.color navbarLinkColor
            , Css.display Css.block
            , Css.lineHeight (Css.num 1.5)
            , Css.padding2 (Css.rem 0.75) (Css.rem 0.75)
            , Css.position Css.relative
            , Css.flexGrow Css.zero
            , Css.flexShrink Css.zero
            , Css.backgroundColor (categoryItemBackgroundColor False)
            , Css.cursor Css.pointer
            , Css.hover
                [ Css.color Colors.linkHover
                , Css.backgroundColor Colors.light
                ]
            ]
            [ href ("/" ++ tree) ]
            [ text tree ]
        ]


categoryItemBackgroundColor : Bool -> Css.Color
categoryItemBackgroundColor isActive =
    if isActive then
        Colors.light

    else
        Css.rgba 0 0 0 0



-- STYLES


headerStyles : List Style
headerStyles =
    [ Css.position Css.fixed
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.right Css.zero
    , Css.zIndex (Css.int 9999)
    ]


navStyles : List Style
navStyles =
    [ Css.backgroundColor Colors.white
    , Css.minHeight (Css.rem 3.25)
    , Css.position Css.relative
    , Css.zIndex (Css.int 30)
    , Utils.desktop
        [ Css.alignItems Css.stretch
        , Css.displayFlex
        ]
    ]


brandStyles : List Style
brandStyles =
    [ Css.alignItems Css.stretch
    , Css.displayFlex
    , Css.flexShrink Css.zero
    , Css.minHeight navbarHeight
    ]



-- TODO Do we need this in `brandStyles`
-- +until($navbar-breakpoint)
--   .navbar > .container
--     display: block
--   .navbar-brand,
--   .navbar-tabs
--     .navbar-item
--       align-items: center
--       display: flex


menuStyles : List Style
menuStyles =
    [ Css.display Css.none
    , Utils.desktop
        [ Css.alignItems Css.stretch
        , Css.displayFlex
        , Css.flexGrow (Css.int 1)
        , Css.flexShrink Css.zero
        ]
    ]


startStyles : List Style
startStyles =
    [ Utils.desktop
        [ Css.alignItems Css.stretch
        , Css.displayFlex
        , Css.justifyContent Css.flexStart
        , Css.marginRight Css.auto
        , Css.flexGrow (Css.int 1)
        ]
    ]


endStyles : List Style
endStyles =
    [ Utils.desktop
        [ Css.alignItems Css.stretch
        , Css.displayFlex
        , Css.justifyContent Css.flexEnd
        , Css.marginLeft Css.auto
        ]
    ]


itemAndLinkStyles : List Style
itemAndLinkStyles =
    [ Css.color navbarLinkColor
    , Css.display Css.inlineFlex
    , Css.alignItems Css.center
    , Css.lineHeight (Css.num 1.5)
    , Css.padding2 (Css.rem 0.75) (Css.rem 0.75)
    , Css.position Css.relative
    , Css.Global.descendants
        [ Css.Global.selector ".icon:only-child"
            [ Css.marginLeft (Css.rem -0.25)
            , Css.marginRight (Css.rem -0.25)
            ]
        , Css.Global.typeSelector "svg"
            [ Css.height (Css.px 40)
            ]
        ]
    ]


itemStyles : List Style
itemStyles =
    [ Css.flexGrow Css.zero
    , Css.flexShrink Css.zero
    ]


linkStyles : List Style
linkStyles =
    [ Css.cursor Css.pointer
    , Css.focus
        [ Css.backgroundColor navbarItemHoverBackgroundColor
        , Css.color navbarItemHoverColor
        ]
    , Css.pseudoClass "focus-within"
        [ Css.backgroundColor navbarItemHoverBackgroundColor
        , Css.color navbarItemHoverColor
        ]
    , Css.hover
        [ Css.backgroundColor navbarItemHoverBackgroundColor
        , Css.color navbarItemHoverColor
        ]
    ]


searchStyles : List Style
searchStyles =
    [ controlStyle Control.Regular
    , Css.backgroundColor Colors.lighter
    , Css.color Colors.darker
    , Css.width (Css.pct 100)
    , Css.border Css.zero
    , Css.height (Css.pct 100)
    ]


ribbonStyles : List Style
ribbonStyles =
    [ Css.margin Css.zero
    , Css.height (Css.px 4)
    , Css.backgroundColor Colors.primary
    ]


subNavStyles : List Style
subNavStyles =
    [ Css.pseudoClass "not([hidden])"
        [ Css.displayFlex
        , Css.position Css.absolute
        , Css.left Css.zero
        , Css.right Css.zero
        , Css.backgroundColor Colors.white
        , Css.padding (Css.rem 0.75)
        , Css.marginTop (Css.px 1)
        , Css.justifyContent Css.spaceBetween
        , Css.boxShadow4 Css.zero (Css.px 5) (Css.px 5) Colors.border
        ]
    , Css.Global.children
        [ Css.Global.typeSelector "li"
            [ Css.Global.children
                [ Css.Global.typeSelector "a"
                    [ Css.fontWeight Css.bold
                    ]
                , Css.Global.typeSelector "ul"
                    [ Css.Global.children
                        [ Css.Global.typeSelector "li"
                            [ Css.Global.children
                                [ Css.Global.typeSelector "a"
                                    [ Css.color navbarLinkColor
                                    , Css.hover
                                        [ Css.color Colors.linkHover
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
