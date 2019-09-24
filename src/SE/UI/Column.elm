module SE.UI.Column exposing (Column, Device(..), Width(..), column, isMobileColumns, toHtml, withAttributes, withSizes, withStyles)

import Css exposing (Style, block, calc, int, minus, none, pct, pseudoClass, rem, wrap, zero)
import Css.Global exposing (children, typeSelector)
import Html.Styled as Html exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes as Attributes
import SE.UI.Utils exposing (desktop, extended, fullhd, mobile, tablet, widescreen)


type Column msg
    = Column (Options msg) (List (Html msg))


type alias Options msg =
    { sizes : Sizes
    , styles : List Style
    , attributes : List (Attribute msg)
    }


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
    | Extended
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


defaultOptions : Options msg
defaultOptions =
    { sizes = []
    , styles = []
    , attributes = [ Attributes.class "column" ]
    }


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
column : List (Html msg) -> Column msg
column cols =
    Column defaultOptions cols


withSizes : Sizes -> Column msg -> Column msg
withSizes sizes (Column options kids) =
    Column { options | sizes = sizes } kids


withStyles : List Style -> Column msg -> Column msg
withStyles styles (Column options kids) =
    Column { options | styles = styles } kids


withAttributes : List (Attribute msg) -> Column msg -> Column msg
withAttributes attributes (Column options kids) =
    Column { options | attributes = attributes } kids


toHtml : Column msg -> Html msg
toHtml (Column { sizes, styles, attributes } kids) =
    styled Html.div
        (columnStyles sizes ++ styles)
        attributes
        kids


isMobileColumns : List (Column msg) -> Bool
isMobileColumns cols =
    List.map isMobileColumn cols
        |> List.foldl (||) False


isMobileColumn : Column msg -> Bool
isMobileColumn (Column { sizes } _) =
    List.map Tuple.first sizes
        |> List.member Mobile



-- STYLES


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

        Extended ->
            extended [ translateWidth width ]

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
