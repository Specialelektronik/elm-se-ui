module SE.Framework.Notification exposing (danger, info, link, notification, primary, success, warning)

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


notification : Maybe msg -> List (Html msg) -> Html msg
notification =
    internalNotification []


primary : Maybe msg -> List (Html msg) -> Html msg
primary =
    internalNotification
        [ Css.backgroundColor Colors.primary
        , Css.color Colors.white
        ]


link : Maybe msg -> List (Html msg) -> Html msg
link =
    internalNotification
        [ Css.backgroundColor Colors.link
        , Css.color Colors.white
        ]


info : Maybe msg -> List (Html msg) -> Html msg
info =
    internalNotification
        [ Css.backgroundColor Colors.info
        , Css.color Colors.white
        ]


success : Maybe msg -> List (Html msg) -> Html msg
success =
    internalNotification
        [ Css.backgroundColor Colors.success
        , Css.color Colors.white
        ]


warning : Maybe msg -> List (Html msg) -> Html msg
warning =
    internalNotification
        [ Css.backgroundColor Colors.warning
        , Css.color Colors.white
        ]


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



--   // Colors
--   @each $name, $pair in $colors
--     $color: nth($pair, 1)
--     $color-invert: nth($pair, 2)
--     &.is-#{$name}
--       background-color: $color
--       color: $color-invert
