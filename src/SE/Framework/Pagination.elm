module SE.Framework.Pagination exposing (PaginationRecord, centeredPagination, pagination, rightPagination)

import Css exposing (Style, block, calc, center, int, minus, none, pct, pseudoClass, rem, wrap, zero)
import Html.Styled exposing (Html, a, li, nav, span, styled, text)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Buttons as Buttons exposing (button)


{-| first link: always 1
last : input from function
current
next page label
previous page label

is-centered
is-right
msg Int

-}
type alias PaginationRecord msg =
    { lastPage : Int
    , currentPage : Int
    , nextPageLabel : String
    , previousPageLabel : String
    , msg : Int -> msg
    }


type Alignment
    = Left
    | Centered
    | Right



-- CONTAINER


pagination : PaginationRecord msg -> Html msg
pagination rec =
    internalPagination Left rec


centeredPagination : PaginationRecord msg -> Html msg
centeredPagination rec =
    text "Centered pagination"


rightPagination : PaginationRecord msg -> Html msg
rightPagination rec =
    text "Right Pagination"


internalPagination : Alignment -> PaginationRecord msg -> Html msg
internalPagination alignment rec =
    styled Html.Styled.nav
        (navStyles alignment)
        []
        [ previous rec.msg rec.previousPageLabel rec.currentPage
        , next rec.msg rec.nextPageLabel rec.currentPage rec.lastPage
        , list rec.msg rec.lastPage rec.currentPage
        ]


navStyles : Alignment -> List Style
navStyles alignment =
    [ Css.fontSize (rem 1)
    , Css.margin (rem -0.25)
    ]



-- NEXT


next : (Int -> msg) -> String -> Int -> Int -> Html msg
next msg label currentPage lastPage =
    let
        message =
            if currentPage == lastPage then
                Nothing

            else
                Just (msg (currentPage + 1))
    in
    button [] message [ text label ]



-- PREVIOUS


previous : (Int -> msg) -> String -> Int -> Html msg
previous msg label currentPage =
    let
        message =
            if currentPage == 1 then
                Nothing

            else
                Just (msg (currentPage - 1))
    in
    button [] message [ text label ]



-- LIST


{-| If the lastPage is over 7, insert ellipsis
-}
list : (Int -> msg) -> Int -> Int -> Html msg
list message lastPage currentPage =
    let
        itemList =
            if lastPage > 7 then
                clipped

            else
                all
    in
    styled Html.Styled.ul
        listStyles
        []
        (itemList message lastPage currentPage)


clipped : (Int -> msg) -> Int -> Int -> List (Html msg)
clipped message lastPage currentPage =
    let
        lst
    in

    case currentPage of
        1 ->
        2 ->
        (lastPage-1) ->
        lastPage ->
        _ ->


all : (Int -> msg) -> Int -> Int -> List (Html msg)
all message lastPage currentPage =
    List.range 1 lastPage
        |> List.map (\p -> listItem message (p == currentPage) p)


listStyles : List Style
listStyles =
    [ Css.flexWrap wrap
    , Css.batch navAndListStyles
    ]


navAndListStyles : List Style
navAndListStyles =
    [ Css.alignItems center
    , Css.displayFlex
    , Css.justifyContent center
    , Css.textAlign center
    ]



-- LIST ITEM


listItem : (Int -> msg) -> Bool -> Int -> Html msg
listItem message isCurrent page =
    li []
        [ a [ onClick (message page) ] [ text (String.fromInt page) ]
        ]


listEllipsis : Html msg
listEllipsis =
    li []
        [ span [] [ text "&hellip;" ]
        ]
