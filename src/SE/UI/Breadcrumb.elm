module SE.UI.Breadcrumb exposing
    ( breadcrumb
    , link, activeLink
    )

{-| Bulmas breadcrumb tags
see <https://bulma.io/documentation/components/breadcrumb/>


# Parent

@docs breadcrumb


# Links

@docs link, activeLink

-}

import Css exposing (Style, center, default, em, flexStart, hover, noWrap, none, rem, wrap, zero)
import Css.Global exposing (adjacentSiblings, descendants, typeSelector)
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes
import SE.UI.Colors as Colors
import SE.UI.Utils exposing (block, unselectable)


type Link msg
    = Link IsActive String (List (Html msg))


type alias IsActive =
    Bool


{-| Creates a non-active link. It takes the url as the first parameter and the a list of html content as the second.
-}
link : String -> List (Html msg) -> Link msg
link =
    Link False


{-| Creates an active link. It takes the url as the first parameter and the a list of html content as the second.
-}
activeLink : String -> List (Html msg) -> Link msg
activeLink =
    Link True


{-| This function takes a list of Link tags (created via the link function or activeLink function). We only support the / separator, left alignment and normal size.
-}
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
        liStyles
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


liStyles : List Style
liStyles =
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
    , if isActive then
        Css.batch
            [ Css.color Colors.darkest
            , Css.cursor
                default
            , Css.pointerEvents
                none
            ]

      else
        Css.batch []
    ]
