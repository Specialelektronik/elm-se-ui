module SE.UI.Table.V2 exposing (Modifier(..), body, toHtml, withModifiers)

{-| Bulmas table element
see <https://bulma.io/documentation/elements/table/>

The second try on the Table component. This time we go with the with Star pattern that we use on Input and Card.

-}

import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import SE.UI.Colors as Colors
import SE.UI.Utils as Utils


type Table msg
    = Table (Internals msg)


type alias Internals msg =
    { body : ( List (Attribute msg), List (Html msg) )
    , head : ( List (Attribute msg), List (Html msg) )
    , foot : ( List (Attribute msg), List (Html msg) )
    , mods : List Modifier
    }


type Modifier
    = Bordered
    | Fullwidth
    | Hoverable
    | Narrow
    | Striped
    | OnBlack
    | Mobilefriendly


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
        { body = ( attrs, kids )
        , head = ( [], [] )
        , foot = ( [], [] )
        , mods = []
        }


toHtml : Table msg -> Html msg
toHtml (Table internals) =
    wrapper internals.mods
        (styled Html.table
            (tableStyles ++ tableModifierStyles internals.mods)
            (Attributes.class "table"
                :: Tuple.first internals.body
            )
            [ thead (Tuple.first internals.head) (Tuple.second internals.head)
            , Html.tbody [] (Tuple.second internals.body)
            , Html.tfoot (Tuple.first internals.foot) (Tuple.second internals.foot)
            ]
        )


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


withModifiers : List Modifier -> Table msg -> Table msg
withModifiers mods (Table internals) =
    Table { internals | mods = mods }


{-| Makes the table horizontal scrollable if wanted
-}
wrapper : List Modifier -> Html msg -> Html msg
wrapper mods t =
    if List.member Mobilefriendly mods then
        styled Html.div
            [ Utils.block
            , Utils.overflowTouch
            , Css.overflow Css.auto
            , Css.overflowY Css.hidden
            , Css.maxWidth (Css.pct 100)
            ]
            []
            [ t ]

    else
        t



-- STYLES


tableStyles : List Style
tableStyles =
    [ Utils.block
    , Colors.color Colors.darker
    , Css.Global.descendants
        [ Css.Global.each [ Css.Global.typeSelector "td", Css.Global.typeSelector "th" ]
            [ Css.border3 (Css.px 1) Css.solid (Colors.light |> Colors.toCss)
            , Css.borderWidth3 Css.zero Css.zero (Css.px 1)
            , Css.padding2 (Css.em 0.5) (Css.em 0.75)
            , Css.verticalAlign Css.top
            ]
        , Css.Global.typeSelector "th"
            [ Css.textAlign Css.left
            ]
        , Css.Global.selector "thead th"
            [ Css.borderWidth3 Css.zero Css.zero (Css.px 2)
            , Colors.color Colors.darkest
            ]
        , Css.Global.selector "tfoot td"
            [ Css.borderWidth3 (Css.px 2) Css.zero Css.zero
            , Colors.color Colors.darkest
            ]
        , Css.Global.selector "tbody tr:last-child td"
            [ Css.borderBottomWidth Css.zero
            ]
        ]
    ]


tableModifierStyles : List Modifier -> List Style
tableModifierStyles mods =
    List.map (tableModifierStyle mods) mods


tableModifierStyle : List Modifier -> Modifier -> Style
tableModifierStyle allMods mod =
    case mod of
        Bordered ->
            Css.batch
                [ Css.Global.descendants
                    [ Css.Global.each [ Css.Global.selector "thead th", Css.Global.selector "tbody td", Css.Global.selector "tfoot td" ]
                        [ Css.borderWidth (Css.px 1)
                        ]
                    , Css.Global.each [ Css.Global.selector "tr:last-child td", Css.Global.selector "tr:last-child th" ]
                        [ Css.important (Css.borderBottomWidth (Css.px 1))
                        ]
                    ]
                ]

        Fullwidth ->
            Css.batch
                [ Css.width (Css.pct 100)
                ]

        Hoverable ->
            Css.batch
                [ Css.Global.descendants
                    (Css.Global.selector "tbody tr:not([selected]):hover"
                        [ Colors.backgroundColor Colors.lighter
                        ]
                        :: (if List.member Striped allMods then
                                [ Css.Global.selector "tbody tr:not([selected]):hover:nth-child(even)"
                                    [ Colors.backgroundColor Colors.light
                                    ]
                                ]

                            else
                                []
                           )
                    )
                ]

        Narrow ->
            Css.batch
                [ Css.Global.descendants
                    [ Css.Global.each
                        [ Css.Global.typeSelector "td"
                        , Css.Global.typeSelector "th"
                        ]
                        [ Css.padding2 (Css.em 0.25) (Css.em 0.5)
                        ]
                    ]
                ]

        Striped ->
            Css.batch
                [ Css.Global.descendants
                    [ Css.Global.selector "tbody tr:not([selected]):nth-child(even)"
                        [ Colors.backgroundColor Colors.lighter
                        ]
                    ]
                ]

        OnBlack ->
            Css.batch
                [ Colors.color Colors.lighter
                , Css.Global.descendants
                    [ Css.Global.selector "thead th"
                        [ Colors.color Colors.lightest
                        ]
                    , Css.Global.selector "tfoot td"
                        [ Colors.color Colors.lightest
                        ]
                    ]
                ]

        -- Mobilefriendly only wraps the table, no additional styling
        Mobilefriendly ->
            Css.batch []
