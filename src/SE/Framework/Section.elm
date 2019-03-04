module SE.Framework.Section exposing (section)

import Css exposing (rem)
import Html.Styled exposing (Attribute, Html, styled, text)


section : List (Attribute msg) -> List (Html msg) -> Html msg
section =
    styled Html.Styled.section
        [ Css.padding2 (rem 3) (rem 1.5)
        ]
