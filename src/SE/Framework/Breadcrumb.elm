module SE.Framework.Breadcrumb exposing (activeLink, breadcrumb, link)

import Css exposing (Style, center, default, em, flex, flexStart, hover, noWrap, none, rem, wrap, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, selector, typeSelector)
import Css.Transitions
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes
import SE.Framework.Colors as Colors exposing (background, white)
import SE.Framework.Utils exposing (block, desktop, radius, tablet, unselectable)


type Link msg
    = Link IsActive String (List (Html msg))


type alias IsActive =
    Bool


link : String -> List (Html msg) -> Link msg
link =
    Link False


activeLink : String -> List (Html msg) -> Link msg
activeLink =
    Link True


breadcrumb : List (Link msg) -> Html msg
breadcrumb links =
    styled Html.Styled.nav
        navStyles
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


navStyles : List Style
navStyles =
    [ block
    , unselectable
    , Css.fontSize (rem 1)
    , Css.whiteSpace noWrap
    ]


ulStyles : List Style
ulStyles =
    [ Css.alignItems flexStart
    , Css.displayFlex
    , Css.flexWrap wrap
    , Css.justifyContent flexStart
    ]


liStyles : IsActive -> List Style
liStyles isActive =
    [ Css.alignItems center
    , Css.displayFlex
    , Css.firstChild
        [ descendants
            [ typeSelector "a"
                [ Css.paddingLeft zero
                ]
            ]
        ]
    , adjacentSiblings
        [ typeSelector "li"
            [ Css.before
                [ Css.color Colors.light
                , Css.property
                    "content"
                    "\"/\""
                ]
            ]
        ]
    , if isActive then
        Css.batch
            [ descendants
                [ typeSelector "a"
                    [ Css.color Colors.darkest
                    , Css.cursor
                        default
                    , Css.pointerEvents
                        none
                    ]
                ]
            ]

      else
        Css.batch []
    ]


aStyles : IsActive -> List Style
aStyles isActive =
    [ Css.alignItems center
    , Css.color Colors.link
    , Css.displayFlex
    , Css.justifyContent center
    , Css.padding2 zero (em 0.75)
    , hover
        [ Css.color Colors.linkHover
        ]
    ]
