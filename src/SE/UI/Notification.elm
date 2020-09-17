module SE.UI.Notification exposing (notification, primary, link, danger, custom)

{-| Bulmas notification element
see <https://bulma.io/documentation/elements/notification/>


# Definition

This module exposes one function for each color. If you supply a message it will be triggered if the user clicks the delete button. If no message is supplied, no delete button will be displayed.

@docs notification, primary, link, danger, custom

-}

import Css exposing (Style, absolute, block, currentColor, relative, rem, transparent)
import Css.Global exposing (descendants, each, selector, typeSelector)
import Html.Styled exposing (Html, styled, text)
import SE.UI.Colors as Colors
import SE.UI.Delete as Delete
import SE.UI.Utils as Utils exposing (radius)


padding : Style
padding =
    Css.padding4 (rem 1.25) (rem 2.5) (rem 1.25) (rem 1.5)


{-| Grey notification
-}
notification : Maybe msg -> List (Html msg) -> Html msg
notification =
    internalNotification Colors.background


{-| Primary notification
-}
primary : Maybe msg -> List (Html msg) -> Html msg
primary =
    internalNotification Colors.primary


{-| Link notification
-}
link : Maybe msg -> List (Html msg) -> Html msg
link =
    internalNotification Colors.link


{-| Danger notification
-}
danger : Maybe msg -> List (Html msg) -> Html msg
danger =
    internalNotification Colors.danger


{-| Notification with custom color
Please use sparingly
-}
custom : Colors.Color -> Maybe msg -> List (Html msg) -> Html msg
custom color =
    internalNotification (Colors.toHsla color)


internalNotification : Colors.Hsla -> Maybe msg -> List (Html msg) -> Html msg
internalNotification color maybeMsg content =
    let
        button =
            Maybe.map delete maybeMsg
                |> Maybe.withDefault (text "")
    in
    styled Html.Styled.div
        [ Utils.block
        , Colors.backgroundColor color
        , Colors.color (color |> Colors.invert)
        , Css.borderRadius radius
        , padding
        , Css.position relative
        , descendants
            [ typeSelector "strong"
                [ Css.color currentColor
                ]
            , each [ typeSelector "code", typeSelector "pre" ]
                [ Colors.backgroundColor Colors.white
                ]
            , selector "pre code"
                [ Css.backgroundColor transparent
                ]
            ]
        ]
        []
        (button :: content)


delete : msg -> Html msg
delete msg =
    Delete.regular
        [ Css.position absolute
        , Css.right (rem 0.5)
        , Css.top (rem 0.5)
        ]
        msg
