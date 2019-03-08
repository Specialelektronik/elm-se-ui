module SE.Framework.Columns exposing (column, columns, defaultColumn, defaultColumns, Device(..), Width(..))

import Css exposing (Style, block, calc, pct, int, minus, none, pseudoClass, rem, wrap, zero)
import Css.Global exposing (children, typeSelector)
import Dict exposing (Dict)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Utils exposing (desktop, tablet)


columnGap : Gap -> Css.Rem
columnGap gap =
    rem (columnGapHelper gap)


columnGapHelper : Gap -> Float
columnGapHelper gap =
    case gap of
        Small ->
            0.5

        Normal ->
            0.75

        Large ->
            1


negativeColumnGap : Gap -> Css.Rem
negativeColumnGap gap =
    rem (columnGapHelper gap * -1)


type Width
    = Auto
    | Narrow
    | OneQuarter
    | OneThird
    | Half
    | TwoThirds
    | ThreeQuarters
    | Full


type Device
    = All
    | Mobile
    | Tablet
    | Desktop
    | Widescreen
    | FullHD


type alias Sizes =
    Dict Device Width


type Gap
    = Small
    | Normal
    | Large


type alias Modifier =
    { gap : Gap
    , isMultiline : Bool
    }


{-| TODO add modifiers
-}
columns : Modifier -> List (Html msg) -> Html msg
columns mods =
    styled Html.Styled.div
        (columnsStyles mods)
        []


defaultColumns : List (Html msg) -> Html msg
defaultColumns =
    columns { gap = Normal, isMultiline = False }


column : Sizes -> List (Html msg) -> Html msg
column sizes =
    styled Html.Styled.div
        (columnStyles sizes)
        []


defaultColumn : List (Html msg) -> Html msg
defaultColumn =
    column Dict.empty


columnsStyles : Modifier -> List Style
columnsStyles { gap, isMultiline } =
    [ Css.marginLeft (negativeColumnGap gap)
    , Css.marginRight (negativeColumnGap gap)
    , Css.marginTop (negativeColumnGap gap)
    , pseudoClass "not(:last-child)"
        [ Css.marginBottom (calc (rem 1.5) minus (columnGap gap))
        ]
    , pseudoClass ":last-child"
        [ Css.marginBottom (negativeColumnGap gap)
        ]
    , tablet [ Css.displayFlex ]
    , children
        [ typeSelector "div"
            [ Css.padding (columnGap gap)
            ]
        ]
    , if isMultiline then
        Css.flexWrap wrap

      else
        Css.batch []
    ]


columnStyles : Sizes -> List Style
columnStyles sizes =
    [ Css.display block
    , Css.flex3 (int 1) (int 1) (int 0)
    , Css.batch (columnSizes sizes)
    ]


columnSizes : Sizes -> List Style
columnSizes sizes =
    Dict.toList sizes
        |> List.map columnSize


columnSize : ( Device, Width ) -> Style
columnSize ( device, width ) =
    case device of
        All ->
            translateWidth width

        _ ->
            Css.batch []


translateWidth : Width -> Style
translateWidth width =
    case width of
        Auto ->
            Css.batch []

        Narrow ->
            Css.flex none

        OneQuarter ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 25)
                ]

        OneThird ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 33.3333)
                ]

        Half ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 50)
                ]

        TwoThirds ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 66.6666)
                ]

        ThreeQuarters ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 75)
                ]

        Full ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 100)
                ]
