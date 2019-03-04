module SE.Framework.Button exposing (button)

import Css exposing (Style, bold, center, em, noWrap, pointer, px, rem, rgba, transparent, zero)
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Colors as Color
import SE.Framework.Control exposing (control)
import SE.Framework.Modifiers exposing (Modifier(..))


{-| A reusable button which has some styles pre-applied to it.
-}
button : List Modifier -> Maybe msg -> String -> Html msg
button modifiers onPress label =
    let
        eventAttribs =
            case onPress of
                Nothing ->
                    []

                Just msg ->
                    [ onClick msg ]
    in
    styled Html.Styled.button
        [ control
        , Css.backgroundColor Color.white
        , Css.borderColor Color.light
        , Css.borderWidth (px 1)
        , Css.color Color.darkest
        , Css.cursor pointer
        , Css.justifyContent center
        , Css.textAlign center
        , Css.whiteSpace noWrap
        , Css.fontWeight bold
        , Css.boxShadow5 zero (px 2) (px 4) zero (rgba 0 0 0 0.1)
        , Css.marginRight (rem 0.5)
        , buttonModifiers buttonModifier modifiers
        , Css.hover
            [ Css.backgroundColor Color.lightest
            , buttonModifiers buttonHoverModifier modifiers
            ]
        ]
        eventAttribs
        [ text label ]


buttonModifiers : (Modifier -> Style) -> List Modifier -> Style
buttonModifiers callback modifiers =
    Css.batch (List.map callback modifiers)


buttonModifier : Modifier -> Style
buttonModifier modifier =
    case modifier of
        Primary ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.primary
                , Css.borderColor transparent
                ]

        Link ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.link
                , Css.borderColor transparent
                ]

        Info ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.info
                , Css.borderColor transparent
                ]

        Success ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.success
                , Css.borderColor transparent
                ]

        Warning ->
            Css.batch
                [ Css.backgroundColor Color.warning
                , Css.borderColor transparent
                ]

        Danger ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.danger
                , Css.borderColor transparent
                ]

        _ ->
            Css.batch []


buttonHoverModifier : Modifier -> Style
buttonHoverModifier modifier =
    case modifier of
        Primary ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.primaryDark
                , Css.borderColor transparent
                ]

        Link ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.linkDark
                , Css.borderColor transparent
                ]

        Info ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.infoDark
                , Css.borderColor transparent
                ]

        Success ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.successDark
                , Css.borderColor transparent
                ]

        Warning ->
            Css.batch
                [ Css.backgroundColor Color.warningDark
                , Css.borderColor transparent
                ]

        Danger ->
            Css.batch
                [ Css.color Color.white
                , Css.backgroundColor Color.dangerDark
                , Css.borderColor transparent
                ]

        _ ->
            Css.batch []



-- &:hover,
--   &.is-hovered
--
--   &:focus,
--   &.is-focused
--     border-color: $button-focus-border-color
--     color: $button-focus-color
--     &:not(:active)
--       box-shadow: $button-focus-box-shadow-size $button-focus-box-shadow-color
--   &:active,
--   &.is-active
--     border-color: $button-active-border-color
--     color: $button-active-color
