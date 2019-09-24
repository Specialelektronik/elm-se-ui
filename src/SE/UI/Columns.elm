module SE.UI.Columns exposing
    ( columns, keyedColumns, toHtml
    , withAttributes, Gap(..), withGap, withMultiline, withStyles
    )

{-| Bulmas Columns
see <https://bulma.io/documentation/columns/>


# Basics

Too a large extend, these functions works very similar a Bulmas own version. Each container modifier is its own function. The `.is-mobile` modifier isn't needed since the `Sizes` type contains a mobile option. Instead of variable gap, we have 3 different gap widths, Small (0.5 rem), Normal (0.75 rem) and Large (1 rem) with a Gapless option as well.

Columns are a type which needs to be transformed to `Html Msg` using `toHtml`

@docs columns, keyedColumns, toHtml


# Options

@docs withAttributes, Gap, withGap, withMultiline, withStyles


# Unsupported features

  - .is-vcentered
  - .is-centered
  - .is-variable and .is-2-mobile etc.

-}

import Css exposing (Style, block, calc, int, minus, none, pct, pseudoClass, rem, wrap, zero)
import Css.Global exposing (children, typeSelector)
import Html.Styled as Html exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes as Attributes
import Html.Styled.Keyed as Keyed
import SE.UI.Column as Column exposing (Column, isMobileColumns, toHtml)
import SE.UI.Utils exposing (desktop, extended, fullhd, mobile, tablet, widescreen)


type Columns msg
    = NotKeyed (Options msg) (List (Column msg))
    | Keyed (Options msg) (List ( String, Column msg ))


type alias Options msg =
    { isMultiline : Bool
    , gap : Gap
    , styles : List Style
    , attributes : List (Attribute msg)
    }


{-| @see withGap
-}
type Gap
    = Gapless
    | Small
    | Normal
    | Large


type alias IsMobile =
    Bool


defaultOptions : Options msg
defaultOptions =
    { isMultiline = False
    , gap = Normal
    , styles = []
    , attributes = [ Attributes.class "columns" ]
    }



-- COLUMNS


{-| Standard `div.columns`, normal gap, no multiline

    columns []
        |> toHtml
        == "<div class='columns'></div>"

-}
columns : List (Column msg) -> Columns msg
columns cols =
    NotKeyed defaultOptions cols


{-| Keyed version of standard `div.columns`, normal gap, no multiline
-}
keyedColumns : List ( String, Column msg ) -> Columns msg
keyedColumns cols =
    Keyed defaultOptions cols


{-| Override default Normal Gap

    columns []
        |> withGap Small
        |> toHtml
        == "<div class='columns is-2'></div>"

-}
withGap : Gap -> Columns msg -> Columns msg
withGap gap cols =
    mapOptions (\options -> { options | gap = gap }) cols


{-| Make columns multiline

    columns []
        |> withMultiline
        |> toHtml
        == "<div class='columns is-multiline'></div>"

-}
withMultiline : Columns msg -> Columns msg
withMultiline cols =
    mapOptions (\options -> { options | isMultiline = True }) cols


{-| Add custom styles to columns

    columns []
        |> withStyles [ Css.Color Colors.White ]
        |> toHtml
        == "<style>.d45{color: #fff;}</style><div class='columns is-multiline d45'></div>"

-}
withStyles : List Style -> Columns msg -> Columns msg
withStyles styles cols =
    mapOptions (\options -> { options | styles = styles }) cols


{-| Add attributes to columns

    columns []
        |> withAttributes [ Html.Styled.Attributes.id "products" ]
        |> toHtml
        == "<div class='columns is-multiline' id='products'></div>"

-}
withAttributes : List (Attribute msg) -> Columns msg -> Columns msg
withAttributes attributes cols =
    mapOptions
        (\options -> { options | attributes = attributes })
        cols


mapOptions : (Options msg -> Options msg) -> Columns msg -> Columns msg
mapOptions transform cols =
    case cols of
        NotKeyed options kids ->
            NotKeyed (transform options) kids

        Keyed options kids ->
            Keyed (transform options) kids


{-| Transform Columns to Html Msg
-}
toHtml : Columns msg -> Html msg
toHtml cols =
    case cols of
        NotKeyed options kids ->
            styled Html.div
                (columnsStyles options (Column.isMobileColumns kids)
                    ++ options.styles
                )
                options.attributes
                (List.map Column.toHtml kids)

        Keyed options kids ->
            keyedToHtml
                (columnsStyles options (Column.isMobileColumns (List.map Tuple.second kids))
                    ++ options.styles
                )
                options.attributes
                kids


keyedToHtml : List Style -> List (Attribute msg) -> List ( String, Column msg ) -> Html msg
keyedToHtml styles attributes cols =
    Keyed.node "div"
        (Attributes.css styles :: attributes)
        (List.map (Tuple.mapSecond Column.toHtml) cols)



-- STYLES


columnsStyles : Options msg -> IsMobile -> List Style
columnsStyles { gap, isMultiline } isMobile =
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
    , if isMultiline then
        Css.flexWrap wrap

      else
        Css.batch []
    , if isMobile then
        Css.displayFlex

      else
        Css.batch []
    ]


columnGap : Gap -> Css.Rem
columnGap gap =
    rem (columnGapHelper gap)


negativeColumnGap : Gap -> Css.Rem
negativeColumnGap gap =
    rem (columnGapHelper gap * -1)


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
