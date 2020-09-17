module SE.UI.Notification exposing (notification, primary, link, danger, custom)

{-| Bulmas notification element
see <https://bulma.io/documentation/elements/notification/>


# Definition

This module exposes one function for each color. If you supply a message it will be triggered if the user clicks the delete button. If no message is supplied, no delete button will be displayed.

@docs notification, primary, link, danger, custom

-}

import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Html, styled)
import SE.UI.Colors as Colors
import SE.UI.Delete as Delete
import SE.UI.Utils as Utils


padding : Style
padding =
    Css.padding4 (Css.rem 1.25) (Css.rem 2.5) (Css.rem 1.25) (Css.rem 1.5)


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
                |> Maybe.withDefault (Html.text "")
    in
    styled Html.div
        [ Utils.block
        , Colors.backgroundColor color
        , Colors.color (color |> Colors.invert)
        , Css.borderRadius Utils.radius
        , padding
        , Css.position Css.relative
        , Css.Global.descendants
            [ Css.Global.strong
                [ Css.color Css.currentColor
                ]
            , Css.Global.a
                [ Css.color Css.currentColor
                , Css.textDecoration Css.underline
                , Css.hover
                    [ Colors.color (color |> Colors.invert |> Colors.hover)
                    ]
                ]
            , Css.Global.each [ Css.Global.code, Css.Global.pre ]
                [ Colors.backgroundColor Colors.white
                ]
            , Css.Global.selector "pre code"
                [ Css.backgroundColor Css.transparent
                ]
            ]
        ]
        []
        (button :: content)


delete : msg -> Html msg
delete msg =
    Delete.regular
        [ Css.position Css.absolute
        , Css.right (Css.rem 0.5)
        , Css.top (Css.rem 0.5)
        ]
        msg
