module SE.Framework.Table exposing (Modifier(..), body, cell, foot, head, headCell, row, table)

import Css exposing (Style, auto, bold, currentColor, em, hidden, important, int, left, num, pct, px, rem, solid, top, zero)
import Css.Global exposing (descendants, each, selector, typeSelector)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Colors exposing (darker, darkest, light, lighter, primary, white)
import SE.Framework.Utils exposing (block, overflowTouch)


type Head msg
    = Head (List (HeadCell msg))


type Body msg
    = Body (List (Row msg))


type Foot msg
    = Foot (List (Cell msg))


type Row msg
    = Row (List (Cell msg))


type HeadCell msg
    = HeadCell (Html msg)


type Cell msg
    = Cell (Html msg)


type Modifier
    = Bordered
    | Fullwidth
    | Hoverable
    | Narrow
    | Striped
    | Mobilefriendly


table : List Modifier -> Head msg -> Foot msg -> Body msg -> Html msg
table mods h f b =
    wrapper mods
        (styled Html.Styled.table
            (tableModifierStyles mods ++ tableStyles)
            []
            [ headToHtml h
            , bodyToHtml b
            ]
        )


wrapper : List Modifier -> Html msg -> Html msg
wrapper mods t =
    if List.member Mobilefriendly mods then
        styled Html.Styled.div
            [ block
            , overflowTouch
            , Css.overflow auto
            , Css.overflowY hidden
            , Css.maxWidth (pct 100)
            ]
            []
            [ t ]

    else
        t


tableStyles : List Style
tableStyles =
    [ block
    , Css.backgroundColor white
    , Css.color darker
    , descendants
        [ each [ typeSelector "td", typeSelector "th" ]
            [ Css.border3 (px 1) solid light
            , Css.borderWidth3 zero zero (px 1)
            , Css.padding2 (em 0.5) (em 0.75)
            , Css.verticalAlign top
            , descendants
                [ each [ typeSelector "a", typeSelector "strong" ]
                    [ Css.color currentColor
                    ]
                ]
            ]
        , typeSelector "th"
            [ Css.textAlign left
            ]
        , selector "thead th"
            [ Css.borderWidth3 zero zero (px 2)
            , Css.color darkest
            ]
        , selector "tfoot td"
            [ Css.borderWidth3 (px 2) zero zero
            , Css.color darkest
            ]
        , selector "tbody tr:last-child td"
            [ Css.borderBottomWidth zero
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
                [ descendants
                    [ each [ selector "thead th", selector "tbody td", selector "tfoot td" ]
                        [ Css.borderWidth (px 1)
                        ]
                    , each [ selector "tr:last-child td", selector "tr:last-child th" ]
                        [ important (Css.borderBottomWidth (px 1))
                        ]
                    ]
                ]

        Fullwidth ->
            Css.batch
                [ Css.width (pct 100)
                ]

        Hoverable ->
            Css.batch
                [ descendants
                    ([ selector "tbody tr:not([selected]):hover"
                        [ Css.backgroundColor lighter
                        ]
                     ]
                        ++ (if List.member Striped allMods then
                                [ selector "tbody tr:not([selected]):hover:nth-child(even)"
                                    [ Css.backgroundColor light
                                    ]
                                ]

                            else
                                []
                           )
                    )
                ]

        Narrow ->
            Css.batch
                [ descendants
                    [ each
                        [ typeSelector "td"
                        , typeSelector "th"
                        ]
                        [ Css.padding2 (em 0.25) (em 0.5)
                        ]
                    ]
                ]

        Striped ->
            Css.batch
                [ descendants
                    [ selector "tbody tr:not([selected]):nth-child(even)"
                        [ Css.backgroundColor lighter
                        ]
                    ]
                ]

        -- Mobilefriendly only wraps the table, no additional styling
        Mobilefriendly ->
            Css.batch []


head : List (HeadCell msg) -> Head msg
head =
    Head


body : List (Row msg) -> Body msg
body =
    Body


foot : List (Cell msg) -> Foot msg
foot =
    Foot


headCell : Html msg -> HeadCell msg
headCell =
    HeadCell


row : List (Cell msg) -> Row msg
row =
    Row


cell : Html msg -> Cell msg
cell =
    Cell


headToHtml : Head msg -> Html msg
headToHtml (Head headCells) =
    Html.Styled.thead []
        [ Html.Styled.tr [] (List.map headCelltoHtml headCells)
        ]


bodyToHtml : Body msg -> Html msg
bodyToHtml (Body rows) =
    Html.Styled.tbody [] (List.map rowToHtml rows)


rowToHtml : Row msg -> Html msg
rowToHtml (Row cells) =
    Html.Styled.tr [] (List.map cellToHtml cells)


cellToHtml : Cell msg -> Html msg
cellToHtml (Cell html) =
    Html.Styled.td [] [ html ]


headCelltoHtml : HeadCell msg -> Html msg
headCelltoHtml (HeadCell html) =
    Html.Styled.th [] [ html ]
