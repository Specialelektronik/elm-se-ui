module SE.UI.Pagination.V2 exposing
    ( create
    , toHtml
    )

{-| Bulmas Pagination component
see <https://bulma.io/documentation/components/pagination/>

@docs pagination, centeredPagination, rightPagination


# Pagination record

@docs PaginationRecord

-}

import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import SE.UI.Colors as Colors
import SE.UI.Control as Control
import SE.UI.Font as Font
import SE.UI.Utils as Utils


{-| The record holds all the data

  - lastPage: The last possible page that the pagination state could be in
  - currentPage: The current page
  - nextPageLabel : Button text for the next button
  - previousPageLabel : Button text for the previous button
  - msg : A function that takes an Int and returns a msg, when the message is triggered it will be loaded will the appropriate page to load. (Example: Current page is 4, the next button will trigger `msg 5`)

-}



-- type alias PaginationRecord msg =
--     { lastPage : Int
--     , currentPage : Int
--     , nextPageLabel : String
--     , previousPageLabel : String
--     , msg : Int -> msg
--     }


type Pagination msg
    = Pagination (Internals msg)


type alias Internals msg =
    { alignment : Alignment
    , size : Control.Size
    , currentPage : Int
    , lastPage : Int
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
create :
    { currentPage : Int
    , lastPage : Int
    , nextPageLabel : String
    , previousPageLabel : String
    , msg : Int -> msg
    }
    -> Pagination msg
create { currentPage, lastPage, nextPageLabel, previousPageLabel, msg } =
    Pagination
        { alignment = Left
        , size = Control.Regular
        , currentPage = currentPage
        , lastPage = lastPage
        , nextPageLabel = nextPageLabel
        , previousPageLabel = previousPageLabel
        , msg = msg
        }


toHtml : Pagination msg -> Html msg
toHtml (Pagination internals) =
    styled Html.nav
        navStyles
        [ Attributes.classList
            [ ( "pagination", True )
            , alignmentToClass internals.alignment
            , sizeToClass internals.size
            ]
        , Attributes.attribute "role" "navigation"
        , Attributes.attribute "aria-label" "pagination"
        ]
        [ previous internals.msg internals.previousPageLabel internals.currentPage
        , next internals.msg internals.nextPageLabel internals.currentPage internals.lastPage
        , list internals.msg internals.lastPage internals.currentPage
        ]


alignmentToClass : Alignment -> ( String, Bool )
alignmentToClass alignment =
    ( case alignment of
        Left ->
            "is-left"

        Center ->
            "is-centered"

        Right ->
            "is-right"
    , True
    )


sizeToClass : Control.Size -> ( String, Bool )
sizeToClass size =
    ( case size of
        Control.Regular ->
            ""

        Control.Small ->
            "is-small"

        Control.Medium ->
            "is-medium"

        Control.Large ->
            "is-large"
    , True
    )


navStyles : List Style
navStyles =
    [ Css.batch navAndListStyles
    , Css.margin (Css.rem -0.25)
    , Utils.tablet
        [ Css.justifyContent Css.spaceBetween
        , Css.Global.withClass "is-left" leftNavStyles
        , Css.Global.withClass "is-centered" centerNavStyles
        , Css.Global.withClass "is-right" rightNavStyles
        ]
    , Css.fontSize (Css.px 16)
    , Css.Global.withClass "is-small" [ Css.fontSize (Css.px 12) ]
    , Css.Global.withClass "is-medium" [ Css.fontSize (Css.px 20) ]
    , Css.Global.withClass "is-large" [ Css.fontSize (Css.px 24) ]
    ]


leftNavStyles : List Style
leftNavStyles =
    [ Css.Global.children
        [ Css.Global.typeSelector "ul"
            [ Css.justifyContent Css.flexStart
            , Css.order (Css.int 1)
            ]

        -- previous
        , Css.Global.class "pagination-previous" [ Css.order (Css.int 2) ]

        --next
        , Css.Global.class "pagination-next" [ Css.order (Css.int 3) ]
        ]
    ]


centerNavStyles : List Style
centerNavStyles =
    [ Css.Global.children
        [ Css.Global.typeSelector "ul"
            [ Css.justifyContent Css.center
            , Css.order (Css.int 2)
            ]

        -- previous
        , Css.Global.class "pagination-previous" [ Css.order (Css.int 1) ]

        --next
        , Css.Global.class "pagination-next" [ Css.order (Css.int 3) ]
        ]
    ]


rightNavStyles : List Style
rightNavStyles =
    [ Css.Global.children
        [ Css.Global.typeSelector "ul"
            [ Css.justifyContent Css.flexEnd
            , Css.order (Css.int 3)
            ]

        -- previous
        , Css.Global.class "pagination-previous" [ Css.order (Css.int 1) ]

        --next
        , Css.Global.class "pagination-next" [ Css.order (Css.int 2) ]
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
                [ Events.onClick (msg (currentPage + 1)) ]
    in
    styled Html.a itemStyles (Attributes.classList [ ( "pagination-next", True ) ] :: attrs) [ Html.text label ]



-- PREVIOUS


previous : (Int -> msg) -> String -> Int -> Html msg
previous msg label currentPage =
    let
        isDisabled =
            currentPage == 1
    in
    styled Html.a itemStyles [ Events.onClick (msg (currentPage - 1)), Attributes.classList [ ( "pagination-previous", True ) ], Attributes.disabled isDisabled ] [ Html.text label ]



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
    styled Html.ul
        listStyles
        []
        (itemList message lastPage currentPage)


clipped : (Int -> msg) -> Int -> Int -> List (Html msg)
clipped message lastPage currentPage =
    listItem message (currentPage == 1) 1
        :: (if currentPage > 3 then
                listEllipsis

            else
                Html.text ""
           )
        :: (if currentPage > 2 then
                listItem message False (currentPage - 1)

            else
                Html.text ""
           )
        :: (if currentPage /= 1 && currentPage /= lastPage then
                listItem message True currentPage

            else
                Html.text ""
           )
        :: (if currentPage < (lastPage - 1) then
                listItem message False (currentPage + 1)

            else
                Html.text ""
           )
        :: (if currentPage < (lastPage - 2) then
                listEllipsis

            else
                Html.text ""
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
    , Css.flexWrap Css.wrap
    , Utils.tablet
        [ Css.flexGrow (Css.int 1)
        , Css.flexShrink (Css.int 1)
        ]
    ]


navAndListStyles : List Style
navAndListStyles =
    [ Css.alignItems Css.center
    , Css.displayFlex
    , Css.justifyContent Css.center
    , Css.textAlign Css.center
    ]



-- LIST ITEM


listItem : (Int -> msg) -> Bool -> Int -> Html msg
listItem message isCurrent page =
    Html.li []
        [ styled Html.a itemStyles [ Events.onClick (message page), Attributes.classList [ ( "pagination-link", True ), ( "is-current", isCurrent ) ] ] [ Html.text (String.fromInt page) ]
        ]


itemAndEllipsisStyles : Style
itemAndEllipsisStyles =
    Css.batch
        [ Control.controlStyle Control.Regular
        , Utils.unselectable
        , Colors.backgroundColor Colors.white
        , Css.fontSize (Css.em 1)
        , Css.paddingLeft (Css.em 0.5)
        , Css.paddingRight (Css.em 0.5)
        , Css.justifyContent Css.center
        , Css.margin (Css.rem 0.25)
        , Css.textAlign Css.center
        , Css.minWidth (Css.em 3)
        ]


itemStyles : List Style
itemStyles =
    [ itemAndEllipsisStyles
    , Colors.borderColor Colors.border
    , Colors.color Colors.text
    , Css.hover
        [ Colors.borderColor (Colors.border |> Colors.hover)
        , Colors.color (Colors.text |> Colors.hover)
        ]
    , Css.focus
        [ Colors.borderColor (Colors.border |> Colors.hover)
        , Colors.color (Colors.text |> Colors.hover)
        ]
    , Css.active
        [ Colors.borderColor (Colors.border |> Colors.active)
        , Colors.color (Colors.text |> Colors.active)
        ]
    , Css.disabled
        [ Colors.backgroundColor Colors.lighter
        , Colors.borderColor Colors.lighter
        , Css.boxShadow Css.none
        , Colors.color Colors.base
        , Css.opacity (Css.num 0.5)
        ]
    , Css.Global.withClass "is-current"
        [ Colors.backgroundColor Colors.link
        , Css.important (Colors.borderColor Colors.link)
        , Css.important (Colors.color Colors.white)
        , Css.pointerEvents Css.none
        , Css.cursor Css.default
        ]
    ]


listEllipsis : Html msg
listEllipsis =
    Html.li [] [ styled Html.span ellipsisStyle [] [ Html.text "…" ] ]


ellipsisStyle : List Style
ellipsisStyle =
    [ itemAndEllipsisStyles
    , Colors.color Colors.light
    , Css.pointerEvents Css.none
    ]
