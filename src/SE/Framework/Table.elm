module SE.Framework.Table exposing (body, foot, head, headCell, table)

import Css exposing (Style, bold, em, int, num, px, rem, solid, top, zero)
import Css.Global exposing (descendants, each, typeSelector)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Colors exposing (darker, darkest, light, white)
import SE.Framework.Utils exposing (block)


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


type CellModifier
    = Selected
    | Narrow


type Cell msg
    = Cell (Html msg)



-- table (head []) (foot []) (body [
--     row [
--         cell [ text "Hello"]
--     ]
-- ])


table : Head msg -> Foot msg -> Body msg -> Html msg
table h f b =
    styled Html.Styled.table
        tableStyles
        []
        [ headtoHtml h
        ]


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
            ]
        ]
    ]


head : List (HeadCell msg) -> Head msg
head headcells =
    Head headcells


body : List (Row msg) -> Body msg
body rows =
    Body rows


foot : List (Cell msg) -> Foot msg
foot cells =
    Foot cells


headCell : Html msg -> HeadCell msg
headCell html =
    HeadCell html


headtoHtml : Head msg -> Html msg
headtoHtml (Head headCells) =
    Html.Styled.thead [] (List.map headCelltoHtml headCells)


headCelltoHtml : HeadCell msg -> Html msg
headCelltoHtml (HeadCell html) =
    Html.Styled.th [] [ html ]
