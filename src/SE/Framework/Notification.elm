module SE.Framework.Notification exposing (notification, primary, link, info, success, warning, danger)

{-| Bulmas notification element
see <https://bulma.io/documentation/elements/notification/>


# Definition

This module exposes one function for each color. If you supply a message it will be triggered if the user clicks the delete button. If no message is supplied, no delete button will be displayed.

@docs notification, primary, link, info, success, warning, danger

-}

import Css exposing (Style, absolute, block, currentColor, int, minus, none, pseudoClass, relative, rem, transparent, zero)
import Css.Global exposing (descendants, each, selector, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Colors as Colors exposing (background, white)
import SE.Framework.Delete as Delete
import SE.Framework.Utils exposing (block, desktop, radius, tablet)


padding : Style
padding =
    Css.padding4 (rem 1.25) (rem 2.5) (rem 1.25) (rem 1.5)


{-| Grey notification
-}
notification : Maybe msg -> List (Html msg) -> Html msg
notification =
    internalNotification []


{-| Primary notification
-}
primary : Maybe msg -> List (Html msg) -> Html msg
primary =
    internalNotification
        [ Css.backgroundColor Colors.primary
        , Css.color Colors.white
        ]


{-| Link notification
-}
link : Maybe msg -> List (Html msg) -> Html msg
link =
    internalNotification
        [ Css.backgroundColor Colors.link
        , Css.color Colors.white
        ]


{-| Info notification
-}
info : Maybe msg -> List (Html msg) -> Html msg
info =
    internalNotification
        [ Css.backgroundColor Colors.info
        , Css.color Colors.white
        ]


{-| Success notification
-}
success : Maybe msg -> List (Html msg) -> Html msg
success =
    internalNotification
        [ Css.backgroundColor Colors.success
        , Css.color Colors.white
        ]


{-| Warning notification
-}
warning : Maybe msg -> List (Html msg) -> Html msg
warning =
    internalNotification
        [ Css.backgroundColor Colors.warning
        , Css.color Colors.white
        ]


{-| Danger notification
-}
danger : Maybe msg -> List (Html msg) -> Html msg
danger =
    internalNotification
        [ Css.backgroundColor Colors.danger
        , Css.color Colors.white
        ]


internalNotification : List Style -> Maybe msg -> List (Html msg) -> Html msg
internalNotification colors maybeMsg content =
    let
        button =
            Maybe.map delete maybeMsg
                |> Maybe.withDefault (text "")
    in
    styled Html.Styled.div
        [ block
        , Css.backgroundColor background
        , Css.borderRadius radius
        , padding
        , Css.position relative
        , descendants
            [ typeSelector "strong"
                [ Css.color currentColor
                ]
            , each [ typeSelector "code", typeSelector "pre" ]
                [ Css.backgroundColor white
                ]
            , selector "pre code"
                [ Css.backgroundColor transparent
                ]
            ]
        , Css.batch colors
        ]
        []
        (button :: content)


delete : msg -> Html msg
delete msg =
    Delete.delete
        [ Css.position absolute
        , Css.right (rem 0.5)
        , Css.top (rem 0.5)
        ]
        msg
