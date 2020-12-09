module SE.UI.Pagination exposing
    ( pagination, centeredPagination, rightPagination
    , PaginationRecord
    )

{-| DEPRECATED! Use SE.UI.Pagination.V2 instead.

Bulmas Pagination component
see <https://bulma.io/documentation/components/pagination/>

@docs pagination, centeredPagination, rightPagination


# Pagination record

@docs PaginationRecord

-}

import Css exposing (Style, active, center, default, disabled, em, flexEnd, flexStart, focus, hover, int, none, num, rem, spaceBetween, wrap)
import Css.Global exposing (adjacentSiblings, children, typeSelector)
import Html.Styled exposing (Html, a, button, li, nav, span, styled, text)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events exposing (onClick)
import SE.UI.Colors as Colors
import SE.UI.Control as Control exposing (controlHeight, controlStyle)
import SE.UI.Utils exposing (tablet, unselectable)


{-| The record holds all the data

  - lastPage: The last possible page that the pagination state could be in
  - currentPage: The current page
  - nextPageLabel : Button text for the next button
  - previousPageLabel : Button text for the previous button
  - msg : A function that takes an Int and returns a msg, when the message is triggered it will be loaded will the appropriate page to load. (Example: Current page is 4, the next button will trigger `msg 5`)

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
    | Center
    | Right



-- CONTAINER


{-| If the lastPage is <= 7, the pagination will be rendered without any ellipsis. Any number above 7 will render the pagination with ellipsis in the appropriate places.

    pagination
        { lastPage = 8
        , currentPage = 5
        , nextPageLabel = "Next"
        , previousPageLabel = "Previous"
        , msg = ChangePage
        }
        == "1 ... 4 5 6 ... 9"

-}
pagination : PaginationRecord msg -> Html msg
pagination rec =
    internalPagination Left rec


{-| Centered pagination
-}
centeredPagination : PaginationRecord msg -> Html msg
centeredPagination rec =
    internalPagination Center rec


{-| Right aligned pagination
-}
rightPagination : PaginationRecord msg -> Html msg
rightPagination rec =
    internalPagination Right rec


internalPagination : Alignment -> PaginationRecord msg -> Html msg
internalPagination alignment rec =
    styled Html.Styled.nav
        (navStyles alignment)
        [ Attributes.classList [ ( "pagination", True ) ], Attributes.attribute "role" "navigation", Attributes.attribute "aria-label" "pagination" ]
        [ previous rec.msg rec.previousPageLabel rec.currentPage
        , next rec.msg rec.nextPageLabel rec.currentPage rec.lastPage
        , list rec.msg rec.lastPage rec.currentPage
        ]


navStyles : Alignment -> List Style
navStyles alignment =
    [ Css.batch navAndListStyles
    , Css.fontSize (rem 1)
    , Css.margin (rem -0.25)
    , tablet
        [ Css.justifyContent spaceBetween
        , case alignment of
            Left ->
                leftNavStyles

            Center ->
                centerNavStyles

            Right ->
                rightNavStyles
        ]
    ]


leftNavStyles : Style
leftNavStyles =
    children
        [ typeSelector "ul"
            [ Css.justifyContent flexStart
            , Css.order (int 1)
            ]

        -- previous
        , typeSelector "button"
            [ Css.order (int 2)
            , adjacentSiblings
                --next
                [ typeSelector "button"
                    [ Css.order (int 3)
                    ]
                ]
            ]
        ]


centerNavStyles : Style
centerNavStyles =
    children
        [ typeSelector "ul"
            [ Css.justifyContent center
            , Css.order (int 2)
            ]

        -- previous
        , typeSelector "button"
            [ Css.order (int 1)
            , adjacentSiblings
                --next
                [ typeSelector "button"
                    [ Css.order (int 3)
                    ]
                ]
            ]
        ]


rightNavStyles : Style
rightNavStyles =
    children
        [ typeSelector "ul"
            [ Css.justifyContent flexEnd
            , Css.order (int 3)
            ]

        -- previous
        , typeSelector "button"
            [ Css.order (int 1)
            , adjacentSiblings
                --next
                [ typeSelector "button"
                    [ Css.order (int 2)
                    ]
                ]
            ]
        ]



-- NEXT


next : (Int -> msg) -> String -> Int -> Int -> Html msg
next msg label currentPage lastPage =
    let
        isDisabled =
            currentPage == lastPage

        attrs =
            if isDisabled then
                [ Attributes.disabled isDisabled ]

            else
                [ onClick (msg (currentPage + 1)) ]
    in
    styled button (itemStyles False) (Attributes.classList [ ( "pagination-next", True ) ] :: attrs) [ text label ]



-- PREVIOUS


previous : (Int -> msg) -> String -> Int -> Html msg
previous msg label currentPage =
    let
        isDisabled =
            currentPage == 1
    in
    styled button (itemStyles False) [ onClick (msg (currentPage - 1)), Attributes.classList [ ( "pagination-previous", True ) ], Attributes.disabled isDisabled ] [ text label ]



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
    listItem message (currentPage == 1) 1
        :: (if currentPage > 3 then
                listEllipsis

            else
                text ""
           )
        :: (if currentPage > 2 then
                listItem message False (currentPage - 1)

            else
                text ""
           )
        :: (if currentPage /= 1 && currentPage /= lastPage then
                listItem message True currentPage

            else
                text ""
           )
        :: (if currentPage < (lastPage - 1) then
                listItem message False (currentPage + 1)

            else
                text ""
           )
        :: (if currentPage < (lastPage - 2) then
                listEllipsis

            else
                text ""
           )
        :: listItem message (currentPage == lastPage) lastPage
        :: []


all : (Int -> msg) -> Int -> Int -> List (Html msg)
all message lastPage currentPage =
    List.range 1 lastPage
        |> List.map (\p -> listItem message (p == currentPage) p)


listStyles : List Style
listStyles =
    [ Css.batch navAndListStyles
    , Css.flexWrap wrap
    , tablet
        [ Css.flexGrow (int 1)
        , Css.flexShrink (int 1)
        ]
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
        [ styled a (itemStyles isCurrent) [ onClick (message page) ] [ text (String.fromInt page) ]
        ]


itemAndEllipsisStyles : Style
itemAndEllipsisStyles =
    Css.batch
        [ controlStyle Control.Regular
        , unselectable
        , Colors.backgroundColor Colors.white
        , Css.fontSize (em 1)
        , Css.paddingLeft (em 0.5)
        , Css.paddingRight (em 0.5)
        , Css.justifyContent center
        , Css.margin (rem 0.25)
        , Css.textAlign center
        ]


itemStyles : Bool -> List Style
itemStyles isCurrent =
    [ itemAndEllipsisStyles
    , Colors.borderColor Colors.border
    , Colors.color Colors.text
    , Css.minWidth controlHeight
    , hover
        [ Colors.borderColor Colors.dark
        ]
    , focus
        [ Colors.borderColor Colors.dark
        ]
    , active
        [ Colors.borderColor Colors.dark
        ]
    , disabled
        [ Colors.backgroundColor Colors.lighter
        , Colors.borderColor Colors.lighter
        , Css.boxShadow none
        , Colors.color Colors.base
        , Css.opacity (num 0.5)
        ]
    , Css.batch <|
        if isCurrent then
            [ Colors.backgroundColor Colors.link
            , Css.important (Colors.borderColor Colors.link)
            , Css.important (Colors.color Colors.white)
            , Css.pointerEvents none
            , Css.cursor default
            ]

        else
            []
    ]


listEllipsis : Html msg
listEllipsis =
    li [] [ styled span ellipsisStyle [] [ text "…" ] ]


ellipsisStyle : List Style
ellipsisStyle =
    [ itemAndEllipsisStyles
    , Colors.color Colors.light
    , Css.pointerEvents none
    ]
