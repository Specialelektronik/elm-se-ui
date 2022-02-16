module SE.UI.Table.V2 exposing
    ( body, keyedBody, toHtml
    , withHead, withFoot, withModifiers, Modifier(..)
    )

{-| Bulmas table element
see <https://bulma.io/documentation/elements/table/>

The second try on the Table component. This time we go with the with Star pattern that we use on Input and Card.

@docs body, keyedBody, toHtml


# With\* pattern (pron. With start pattern)

The inspiration to this module and its API comes from Brian Hicks talk about Robot Buttons from Mars (<https://youtu.be/PDyWP-0H4Zo?t=1467>). (Please view the entire talk).

    Example:

    Table.body []
        [ Html.tr []
            [ Html.th [] [ Html.text "This is a header cell." ]
            , Html.td [] [ Html.text "This is text in a cell." ]
            , Html.td [] [ Html.text "This is text in a cell." ]
            ]
        , Html.tr []
            [ Html.td [] [ Html.text "This is a header cell." ]
            , Html.th [] [ Html.text "This is text in a cell." ]
            , Html.td [] [ Html.text "This is text in a cell." ]
            ]
        ]
        |> Table.withHead
            [ Html.th [] [ Html.text "This is a header cell." ]
            , Html.th [] [ Html.text "This is a header cell." ]
            , Html.th [] [ Html.text "This is a header cell." ]
            ]
        |> Table.withModifiers [ Table.Hoverable ]
        |> Table.toHtml

@docs withHead, withFoot, withModifiers, Modifier

-}

import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Keyed as Keyed
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Utils as Utils


type Table msg
    = Table (Internals msg)


type alias Internals msg =
    { body : Body msg
    , head : List (Html msg)
    , foot : List (Html msg)
    , mods : List Modifier
    }


type Body msg
    = Body ( List (Attribute msg), List (Html msg) )
    | KeyedBody ( List (Attribute msg), List ( String, Html msg ) )


{-| The following modifiers from Bulma are always added:

Striped, Bordered

-}
type Modifier
    = Fullwidth
    | Hoverable


{-| Create a table without thead or tfoot element, even though the functions name is body, the attributes will be added to the table tag. To style the tbody, use

    Css.Global.children
        [ Css.Global.typeSelector "tbody"
            [-- Styles go here
            ]
        ]

-}
body : List (Attribute msg) -> List (Html msg) -> Table msg
body attrs kids =
    Table
        { body = Body ( attrs, kids )
        , head = []
        , foot = []
        , mods = []
        }


{-| Same as `body` but is [keyed](https://guide.elm-lang.org/optimization/keyed.html)
-}
keyedBody : List (Attribute msg) -> List ( String, Html msg ) -> Table msg
keyedBody attrs kids =
    Table
        { body = KeyedBody ( attrs, kids )
        , head = []
        , foot = []
        , mods = []
        }


{-| Turn the table into Html
-}
toHtml : Table msg -> Html msg
toHtml (Table internals) =
    wrapper
        (styled Html.table
            (tableStyles internals.mods)
            (Attributes.class "table"
                :: bodyAttributes internals.body
            )
            [ if List.isEmpty internals.head then
                Html.text ""

              else
                thead []
                    [ Html.tr [] internals.head
                    ]
            , bodyToHtml internals.body
            , if List.isEmpty internals.foot then
                Html.text ""

              else
                tfoot []
                    [ Html.tr [] internals.foot
                    ]
            ]
        )


bodyAttributes : Body msg -> List (Attribute msg)
bodyAttributes body_ =
    case body_ of
        Body ( attrs, _ ) ->
            attrs

        KeyedBody ( attrs, _ ) ->
            attrs


bodyToHtml : Body msg -> Html msg
bodyToHtml body_ =
    case body_ of
        Body ( _, kids ) ->
            Html.tbody [] kids

        KeyedBody ( _, kids ) ->
            Keyed.node "tbody" [] kids


helper : (List (Attribute msg) -> List (Html msg) -> Html msg) -> List (Attribute msg) -> List (Html msg) -> Html msg
helper fn attrs kids =
    if List.isEmpty kids then
        Html.text ""

    else
        fn attrs kids


thead : List (Attribute msg) -> List (Html msg) -> Html msg
thead =
    helper Html.thead


tfoot : List (Attribute msg) -> List (Html msg) -> Html msg
tfoot =
    helper Html.tfoot



-- WITH STAR


{-| Add Modifiers to the Table
-}
withModifiers : List Modifier -> Table msg -> Table msg
withModifiers mods (Table internals) =
    Table { internals | mods = mods }


{-| Add a thead tag to the Table, the thead will also have a tr tag, your input should be a list of td tags.
-}
withHead : List (Html msg) -> Table msg -> Table msg
withHead rows (Table internals) =
    Table { internals | head = rows }


{-| Add a tfoot tag to the end of the Table, the tfoots will also have a tr tag, your input should be a list of td tags.
-}
withFoot : List (Html msg) -> Table msg -> Table msg
withFoot rows (Table internals) =
    Table { internals | foot = rows }


{-| Makes the table horizontal scrollable if wanted
-}
wrapper : Html msg -> Html msg
wrapper kids =
    styled Html.div
        [ Utils.block
        , Utils.overflowTouch
        , Css.overflow Css.auto
        , Css.overflowY Css.hidden
        , Css.maxWidth (Css.pct 100)
        ]
        [ Attributes.class "table-container" ]
        [ kids ]



-- STYLES


tableStyles : List Modifier -> List Style
tableStyles mods =
    [ Css.batch (tableModifierStyles mods)
    , Font.bodySizeRem -2
    , Css.Global.descendants
        [ Css.Global.each
            [ Css.Global.typeSelector "td"
            , Css.Global.typeSelector "th"
            ]
            [ Css.padding2 (Css.rem 0.7) (Css.px 16)
            , Utils.desktop
                [ Css.padding2 (Css.rem 0.5) (Css.px 16)
                ]
            , Css.border3 (Css.px 10) Css.solid (Colors.border |> Colors.toCss)
            , Css.borderWidth2 (Css.px 1) Css.zero
            , Css.pseudoClass "first-child"
                [ Css.borderLeftWidth (Css.px 1)
                ]
            , Css.pseudoClass "last-child"
                [ Css.borderRightWidth (Css.px 1)
                ]
            , Css.verticalAlign Css.top
            ]
        , Css.Global.selector "tbody tr:not([selected]):nth-child(even)"
            [ Colors.backgroundColor Colors.background
            ]
        , Css.Global.selector "thead th"
            [ Colors.backgroundColor Colors.background
            ]
        ]
    ]


tableModifierStyles : List Modifier -> List Style
tableModifierStyles mods =
    List.map tableModifierStyle mods


tableModifierStyle : Modifier -> Style
tableModifierStyle mod =
    case mod of
        Fullwidth ->
            Css.batch
                [ Css.width (Css.pct 100)
                ]

        Hoverable ->
            Css.batch
                [ Css.Global.descendants
                    [ Css.Global.selector
                        "tbody tr:not([selected]):hover"
                        [ Colors.backgroundColor Colors.lighter
                        ]
                    , Css.Global.selector "tbody tr:not([selected]):hover:nth-child(even)"
                        [ Colors.backgroundColor Colors.light
                        ]
                    ]
                ]
