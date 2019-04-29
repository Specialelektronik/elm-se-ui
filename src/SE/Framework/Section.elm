module SE.Framework.Section exposing (section)

{-| Creates a styled section in line with Bulmas section.


# Definition

@docs section

-}

import Css exposing (rem)
import Html.Styled exposing (Attribute, Html, styled, text)


{-| Creates a styled section html tag in line with [Bulmas section](https://bulma.io/documentation/layout/section/).

    section [] [ text "I'm the text inside the section!" ] == "<section>I'm the text inside the section!</section>"

-}
section : List (Attribute msg) -> List (Html msg) -> Html msg
section =
    styled Html.Styled.section
        [ Css.padding2 (rem 3) (rem 1.5)
        ]
