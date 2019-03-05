module SE.Framework.Form exposing (InputModifier(..), InputRecord, control, field, input)

import Css exposing (Style, absolute, active, block, bold, borderBox, calc, center, em, flexStart, focus, hover, important, inlineFlex, int, left, minus, none, pct, pseudoClass, pseudoElement, px, relative, rem, rgba, solid, top, transparent)
import Css.Global exposing (descendants, each)
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (placeholder)
import Html.Styled.Events exposing (onInput)
import SE.Framework.Colors exposing (base, black, danger, darker, info, light, lighter, lightest, link, linkDark, primary, success, warning, white)
import SE.Framework.Utils exposing (loader, radius)


{-| Label
TODO add size modifier?
-}
label : String -> Html msg
label s =
    styled Html.Styled.label
        [ Css.color darker
        , Css.display block
        , Css.fontSize (rem 1)
        , Css.fontWeight bold
        , pseudoClass "not(:last-child)"
            [ Css.marginBottom (em 0.5)
            ]
        ]
        []
        [ text s ]


type alias InputRecord =
    { placeholder : String
    , modifiers : List InputModifier
    }


type
    InputModifier
    -- Colors
    = Primary
    | Info
    | Success
    | Warning
    | Danger
      -- Sizes ( ignored for now)
      -- | Small
      -- | Normal
      -- | Medium
      -- | Large
      -- State
    | Disabled
    | ReadOnly
    | Static


{-| Input
TODO add size modifier?
-}
input : InputRecord -> (String -> msg) -> String -> Html msg
input rec onInput val =
    styled Html.Styled.input
        (inputStyle
            ++ List.map inputModifierStyle
                rec.modifiers
        )
        [ Html.Styled.Events.onInput onInput, Html.Styled.Attributes.placeholder rec.placeholder, Html.Styled.Attributes.value val ]
        []



--   // Colors
--   @each $name, $pair in $colors
--     $color: nth($pair, 1)
--     &.is-#{$name}
--       border-color: $color
--       &:focus,
--       &.is-focused,
--       &:active,
--       &.is-active
--         box-shadow: $input-focus-box-shadow-size rgba($color, 0.25)


inputModifierStyle : InputModifier -> Style
inputModifierStyle modifier =
    let
        style color prop =
            Css.batch
                [ Css.borderColor color
                , focus [ prop, Css.borderColor color ]
                , active [ prop, Css.borderColor color ]
                , hover [ Css.borderColor color ]
                ]
    in
    case modifier of
        Primary ->
            style primary (Css.property "box-shadow" "0 0 0 0.125em rgba(53, 157, 55, 0.25)")

        Info ->
            style info (Css.property "box-shadow" "0 0 0 0.125em rgba(50, 115, 220, 0.25)")

        Success ->
            style success (Css.property "box-shadow" "0 0 0 0.125em rgba(35, 209, 96, 0.25)")

        Warning ->
            style warning (Css.property "box-shadow" "0 0 0 0.125em rgba(255,221,87, 0.25)")

        Danger ->
            style danger (Css.property "box-shadow" "0 0 0 0.125em rgba(255,56,96, 0.25)")

        Static ->
            Css.batch []

        Disabled ->
            Css.batch []

        ReadOnly ->
            Css.batch []



-- $input-color: $grey-darker !default
-- $input-background-color: $white !default
-- $input-border-color: $grey-lighter !default
-- $input-height: $control-height !default
-- $input-shadow: inset 0 1px 2px rgba($black, 0.1) !default
-- $input-placeholder-color: rgba($input-color, 0.3) !default
-- $input-hover-color: $grey-darker !default
-- $input-hover-border-color: $grey-light !default
-- $input-focus-color: $grey-darker !default
-- $input-focus-border-color: $link !default
-- $input-disabled-color: $text-light !default
-- $input-disabled-background-color: $background !default
-- $input-disabled-border-color: $background !default
-- $input-disabled-placeholder-color: rgba($input-disabled-color, 0.3) !default
-- $input-arrow: $link !default
-- $input-icon-color: $grey-lighter !default
-- $input-icon-active-color: $grey !default
-- $input-radius: $radius !default
-- $file-border-color: $border !default
-- $file-radius: $radius !default
-- $file-cta-background-color: $white-ter !default
-- $file-cta-color: $grey-dark !default
-- $file-cta-hover-color: $grey-darker !default
-- $file-cta-active-color: $grey-darker !default
-- $file-name-border-color: $border !default
-- $file-name-border-style: solid !default
-- $file-name-border-width: 1px 1px 1px 0 !default
-- $file-name-max-width: 16em !default
-- $label-color: $grey-darker !default
-- $label-weight: $weight-bold !default
-- $help-size: $size-small !default
-- .input,
-- .textarea
--   +input
--   box-shadow: $input-shadow
--   max-width: 100%
--   width: 100%
--   &[readonly]
--     box-shadow: none
--   // Sizes
--   &.is-small
--     +control-small
--   &.is-medium
--     +control-medium
--   &.is-large
--     +control-large
--   // Modifiers
--   &.is-fullwidth
--     display: block
--     width: 100%
--   &.is-inline
--     display: inline
--     width: auto
-- .input
--   &.is-rounded
--     border-radius: $radius-rounded
--     padding-left: 1em
--     padding-right: 1em
--   &.is-static
--     background-color: transparent
--     border-color: transparent
--     box-shadow: none
--     padding-left: 0
--     padding-right: 0
-- .textarea
--   display: block
--   max-width: 100%
--   min-width: 100%
--   padding: 0.625em
--   resize: vertical
--   &:not([rows])
--     max-height: 600px
--     min-height: 120px
--   &[rows]
--     height: initial
--   // Modifiers
--   &.has-fixed-size
--     resize: none


inputStyle : List Style
inputStyle =
    [ inputControlStyle
    , Css.borderColor light
    , Css.color darker
    , Css.maxWidth (pct 100)
    , Css.width (pct 100)
    , placeholder
        [ Css.color (rgba 96 111 123 0.3)
        ]
    , hover
        [ Css.borderColor base
        ]
    , focus
        [ Css.borderColor link
        , Css.property "box-shadow" "0 0 0 0.125em rgba(50,115,220, 0.25)"
        ]
    , active
        [ Css.borderColor link
        , Css.property "box-shadow" "0 0 0 0.125em rgba(50,115,220, 0.25)"
        ]
    ]


placeholder : List Style -> Style
placeholder c =
    Css.batch
        [ pseudoElement "placeholder" c
        , pseudoElement "-webkit-input-placeholder" c
        , pseudoElement "-ms-input-placeholder" c
        ]



-- =input
--   &[disabled],
--   fieldset[disabled] &
--     background-color: $input-disabled-background-color
--     border-color: $input-disabled-border-color
--     box-shadow: none
--     color: $input-disabled-color
--     +placeholder
--       color: $input-disabled-placeholder-color


inputControlStyle : Style
inputControlStyle =
    Css.batch
        [ Css.property "-moz-appearance" "none"
        , Css.property "-webkit-appearance" "none"
        , Css.alignItems center
        , Css.border3 (px 1) solid transparent
        , Css.borderRadius radius
        , Css.boxShadow none
        , Css.display inlineFlex
        , Css.fontSize (rem 1)
        , Css.height (em 2.25)
        , Css.justifyContent flexStart
        , Css.lineHeight (rem 1.5)
        , Css.property "padding-bottom" "calc(0.375em - 1px)"
        , Css.property "padding-left" "calc(0.625em - 1px)"
        , Css.property "padding-right" "calc(0.625em - 1px)"
        , Css.property "padding-top" "calc(0.375em - 1px)"
        , Css.position relative
        , Css.verticalAlign top
        , Css.active
            [ Css.outline none
            ]
        , Css.focus
            [ Css.outline none
            ]
        ]



-- =control
--   // States
--   &[disabled],
--   fieldset[disabled] &
--     cursor: not-allowed
-- // The controls sizes use mixins so they can be used at different breakpoints
-- =control-small
--   border-radius: $control-radius-small
--   font-size: $size-small
-- =control-medium
--   font-size: $size-medium
-- =control-large
--   font-size: $size-large


field : List (Html msg) -> Html msg
field =
    styled Html.Styled.div
        [ pseudoClass "not(:last-child)"
            [ Css.marginBottom (rem 0.75)
            ]
        ]
        []


control : Bool -> List (Html msg) -> Html msg
control loading =
    let
        loadingStyle =
            if loading then
                [ Css.after
                    [ loader
                    , important (Css.position absolute)
                    , Css.right (em 0.625)
                    , Css.top (em 0.625)
                    , Css.zIndex (int 4)
                    ]
                ]

            else
                []
    in
    styled Html.Styled.div
        ([ Css.boxSizing borderBox
         , Css.property "clear" "both"
         , Css.fontSize (rem 1)
         , Css.position relative
         , Css.textAlign left
         ]
            ++ loadingStyle
        )
        []
