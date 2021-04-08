module SE.UI.Columns exposing
    ( columns, multilineColumns, gaplessColumns, smallColumns, gaplessMultilineColumns, smallMultilineColumns, wideColumns, wideMultilineColumns
    , defaultColumn, column
    , Sizes, Device(..), Width(..)
    )

{-| Bulmas Columns
see <https://bulma.io/documentation/columns/>


# Basics

Too a large extend, these functions works very similar a Bulmas own version. Each container modifier is its own function. The `.is-mobile` modifier isn't needed since the `Sizes` type contains a mobile option. Instead of variable gap, we have 3 different gap widths, small (0.5 rem), normal (0.75 rem) and wide (1 rem).

@docs columns, multilineColumns, gaplessColumns, smallColumns, gaplessMultilineColumns, smallMultilineColumns, wideColumns, wideMultilineColumns


# Column

There are 2 different column functions. `defaultColumn` is the standard, no options alternative, if you just want the plain .column class.

@docs defaultColumn, column


# Sizes

The `column` function takes a `Sizes` parameter, a List (Device, Width)

@docs Sizes, Device, Width


# Unsupported features

  - .is-vcentered
  - .is-centered
  - .is-variable and .is-2-mobile etc.

-}

import Css exposing (Style, block, calc, int, minus, none, pct, pseudoClass, rem, wrap)
import Css.Global exposing (children, typeSelector)
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes as Attributes
import SE.UI.Utils exposing (desktop, fullhd, mobile, tablet, widescreen)


columnGap : Gap -> Css.Rem
columnGap gap =
    rem (columnGapHelper gap)


columnGapHelper : Gap -> Float
columnGapHelper gap =
    case gap of
        Gapless ->
            0

        Small ->
            0.5

        Normal ->
            0.75

        Large ->
            1


negativeColumnGap : Gap -> Css.Rem
negativeColumnGap gap =
    rem (columnGapHelper gap * -1)


{-| Combine different `Width` options with a `Device` like this:

    [ ( All, OneThird )
    , ( Mobile, Half )
    ]
        == ".is-one-third .is-half-mobile"

-}
type alias Sizes =
    List ( Device, Width )


{-| The devices we support. `All` sets the width without a mediaquery.
-}
type Device
    = All
    | Mobile
    | Tablet
    | Desktop
    | Widescreen
    | FullHD


{-| A lot of the width modifiers for `column` is supported.
-}
type Width
    = Auto
    | Narrow
    | OneSixth
    | OneFifth
    | OneQuarter
    | OneThird
    | TwoFifths
    | Half
    | ThreeFifths
    | TwoThirds
    | ThreeQuarters
    | FourFifths
    | FiveSixths
    | Full


type Gap
    = Gapless
    | Small
    | Normal
    | Large


type alias IsMultiline =
    Bool


type alias IsMobile =
    Bool


type Column msg
    = Column Sizes (List (Html msg))



-- COLUMNS


{-| Standard `div.columns`, normal gap, no multiline
-}
columns : List (Column msg) -> Html msg
columns =
    internalColumns Normal False


{-| `div.columns.is-multiline`
-}
multilineColumns : List (Column msg) -> Html msg
multilineColumns =
    internalColumns Normal True


{-| `div.columns.is-gapless`
-}
gaplessColumns : List (Column msg) -> Html msg
gaplessColumns =
    internalColumns Gapless False


{-| `div.columns.is-2`
-}
smallColumns : List (Column msg) -> Html msg
smallColumns =
    internalColumns Small False


{-| `div.columns.is-multiline.is-gapless`
-}
gaplessMultilineColumns : List (Column msg) -> Html msg
gaplessMultilineColumns =
    internalColumns Gapless True


{-| `div.columns.is-multiline.is-2`
-}
smallMultilineColumns : List (Column msg) -> Html msg
smallMultilineColumns =
    internalColumns Small True


{-| `div.columns.is-4`
-}
wideColumns : List (Column msg) -> Html msg
wideColumns =
    internalColumns Large False


{-| `div.columns.is-multiline.is-4`
-}
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
        (columnsStyles gap)
        [ Attributes.classList [ ( "columns", True ), ( "is-multiline", isMultiline ), ( "is-mobile", isMobile ) ] ]
        (List.map toHtml cols)


isMobileColumns : List (Column msg) -> Bool
isMobileColumns cols =
    List.map isMobileColumn cols
        |> List.foldl (||) False


isMobileColumn : Column msg -> Bool
isMobileColumn (Column sizes _) =
    List.map Tuple.first sizes
        |> List.member Mobile


columnsStyles : Gap -> List Style
columnsStyles gap =
    [ Css.marginLeft (negativeColumnGap gap)
    , Css.marginRight (negativeColumnGap gap)
    , Css.marginTop (negativeColumnGap gap)
    , pseudoClass "not(:last-child)"
        [ Css.marginBottom (calc (rem 1.5) minus (columnGap gap))
        ]
    , pseudoClass ":last-child"
        [ Css.marginBottom (negativeColumnGap gap)
        ]
    , desktop [ Css.displayFlex ]
    , children
        [ typeSelector "div"
            [ Css.padding (columnGap gap)
            ]
        ]
    , Css.Global.withClass "is-multiline"
        [ Css.flexWrap wrap
        ]
    , Css.Global.withClass "is-mobile"
        [ Css.displayFlex
        ]
    ]



-- COLUMN


{-| Standard no-frills `.column`
-}
defaultColumn : List (Html msg) -> Column msg
defaultColumn html =
    Column [] html


{-| `.column` with Sizes options

    columns
        [ defaultColumn [ text "Default column" ]
        , column
            [ ( All, Half )
            , ( Mobile, OneThird )
            ]
            [ text "Half width column that shrinks to one third on a mobile device" ]
        ]
        == "<div class='columns is-mobile'>\n            <div class='column'>Default column</div>\n            <div class='column is-half is-one-third-mobile'>Half width column that shrinks to one third on a mobile device</div>\n        </div>"

-}
column : Sizes -> List (Html msg) -> Column msg
column sizes html =
    Column sizes html


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

        Widescreen ->
            widescreen [ translateWidth width ]

        FullHD ->
            fullhd [ translateWidth width ]


translateWidth : Width -> Style
translateWidth width =
    case width of
        Auto ->
            Css.batch []

        Narrow ->
            Css.flex none

        OneSixth ->
            Css.batch
                [ Css.flex none
                , Css.width (pct (100 / 6))
                ]

        OneFifth ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 20)
                ]

        OneQuarter ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 25)
                ]

        OneThird ->
            Css.batch
                [ Css.flex none
                , Css.width (pct (100 / 3))
                ]

        TwoFifths ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 40)
                ]

        Half ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 50)
                ]

        ThreeFifths ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 60)
                ]

        TwoThirds ->
            Css.batch
                [ Css.flex none
                , Css.width (pct (100 / 1.5))
                ]

        ThreeQuarters ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 75)
                ]

        FourFifths ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 80)
                ]

        FiveSixths ->
            Css.batch
                [ Css.flex none
                , Css.width (pct ((100 / 6) * 5))
                ]

        Full ->
            Css.batch
                [ Css.flex none
                , Css.width (pct 100)
                ]
