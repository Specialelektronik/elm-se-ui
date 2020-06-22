module SE.UI.Table.V2 exposing (Modifier(..), body, toHtml, withFoot, withHead, withModifiers)

{-| Bulmas table element
see <https://bulma.io/documentation/elements/table/>

The second try on the Table component. This time we go with the with Star pattern that we use on Input and Card.

-}

import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Utils as Utils


type Table msg
    = Table (Internals msg)


type alias Internals msg =
    { body : ( List (Attribute msg), List (Html msg) )
    , head : List (Html msg)
    , foot : List (Html msg)
    , mods : List Modifier
    }


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
        { body = ( attrs, kids )
        , head = []
        , foot = []
        , mods = []
        }


toHtml : Table msg -> Html msg
toHtml (Table internals) =
    wrapper
        (styled Html.table
            (tableStyles internals.mods)
            (Attributes.class "table"
                :: Tuple.first internals.body
            )
            [ thead []
                [ Html.tr [] internals.head
                ]
            , Html.tbody [] (Tuple.second internals.body)
            , tfoot []
                [ Html.tr [] internals.foot
                ]
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


withHead : List (Html msg) -> Table msg -> Table msg
withHead rows (Table internals) =
    Table { internals | head = rows }


withFoot : List (Html msg) -> Table msg -> Table msg
withFoot rows (Table internals) =
    Table { internals | foot = rows }


{-| Makes the table horizontal scrollable if wanted
-}
wrapper : Html msg -> Html msg
wrapper kids =
    styled Html.div
        []
        -- [ Utils.block
        -- , Utils.overflowTouch
        -- , Css.overflow Css.auto
        -- , Css.overflowY Css.hidden
        -- , Css.maxWidth (Css.pct 100)
        -- ]
        []
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
        , Css.Global.typeSelector "th"
            [ Css.textAlign Css.left
            , Css.fontWeight Css.bold
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
