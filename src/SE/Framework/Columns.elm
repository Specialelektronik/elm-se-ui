module SE.Framework.Columns exposing (Device(..), Width(..), column, columns, defaultColumn, multilineColumns, smallColumns, smallMultilineColumns, wideColumns, wideMultilineColumns)

import Css exposing (Style, block, calc, int, minus, none, pct, pseudoClass, rem, wrap, zero)
import Css.Global exposing (children, typeSelector)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Utils exposing (desktop, mobile, tablet)


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


type alias Sizes =
    List ( Device, Width )


type Gap
    = Small
    | Normal
    | Large


type alias IsMultiline =
    Bool


type alias IsMobile =
    Bool


type Column msg
    = Column Sizes (List (Html msg))



-- COLUMNS


columns : List (Column msg) -> Html msg
columns =
    internalColumns Normal False


multilineColumns : List (Column msg) -> Html msg
multilineColumns =
    internalColumns Normal True


smallColumns : List (Column msg) -> Html msg
smallColumns =
    internalColumns Small False


smallMultilineColumns : List (Column msg) -> Html msg
smallMultilineColumns =
    internalColumns Small True


wideColumns : List (Column msg) -> Html msg
wideColumns =
    internalColumns Large False


wideMultilineColumns : List (Column msg) -> Html msg
wideMultilineColumns =
    internalColumns Large True


internalColumns : Gap -> IsMultiline -> List (Column msg) -> Html msg
internalColumns gap isMultiline cols =
    let
        isMobile =
            isMobileColumns cols
    in
    styled Html.Styled.div
        (columnsStyles gap isMultiline isMobile)
        []
        (List.map toHtml cols)


isMobileColumns : List (Column msg) -> Bool
isMobileColumns cols =
    List.map isMobileColumn cols
        |> List.foldl (||) False


isMobileColumn : Column msg -> Bool
isMobileColumn (Column sizes _) =
    List.map Tuple.first sizes
        |> List.member Mobile


columnsStyles : Gap -> IsMultiline -> IsMobile -> List Style
columnsStyles gap isMultiline isMobile =
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
    , if isMobile then
        Css.displayFlex

      else
        Css.batch []
    ]



-- COLUMN


column : Sizes -> List (Html msg) -> Column msg
column sizes html =
    Column sizes html


defaultColumn : List (Html msg) -> Column msg
defaultColumn html =
    Column [] html


toHtml : Column msg -> Html msg
toHtml (Column sizes html) =
    styled Html.Styled.div
        (columnStyles sizes)
        []
        html


columnStyles : Sizes -> List Style
columnStyles sizes =
    [ Css.display block
    , Css.flex3 (int 1) (int 1) (int 0)
    , Css.batch (List.map columnSize sizes)
    ]


columnSize : ( Device, Width ) -> Style
columnSize ( device, width ) =
    case device of
        All ->
            translateWidth width

        Mobile ->
            mobile [ translateWidth width ]

        Tablet ->
            tablet [ translateWidth width ]

        Desktop ->
            desktop [ translateWidth width ]


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
