module SE.Framework.Columns exposing (column, columns)

import Css exposing (Style, block, calc, int, minus, none, pseudoClass, rem, zero)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Utils exposing (desktop, tablet)


columnGap : Css.Rem
columnGap =
    rem 0.75


negativeColumnGap : Css.Rem
negativeColumnGap =
    rem -0.75


{-| TODO add modifiers
-}
columns : List (Html msg) -> Html msg
columns =
    styled Html.Styled.div
        [ Css.marginLeft negativeColumnGap
        , Css.marginRight negativeColumnGap
        , Css.marginTop negativeColumnGap
        , pseudoClass "not(:last-child)"
            [ Css.marginBottom (calc (rem 1.5) minus columnGap)
            ]
        , pseudoClass ":last-child"
            [ Css.marginBottom negativeColumnGap
            ]
        , tablet [ Css.displayFlex ]
        ]
        []


column : List (Html msg) -> Html msg
column =
    styled Html.Styled.div
        [ Css.display block
        , Css.flex3 (int 1) (int 1) (int 0)
        , Css.padding columnGap
        ]
        []
