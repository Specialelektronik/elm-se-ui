module SE.Framework.Form exposing (InputModifier, InputRecord, input)

import Css exposing (Style, block, bold, calc, center, em, flexStart, inlineFlex, minus, none, pseudoClass, px, relative, rem, solid, top, transparent)
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (placeholder)
import Html.Styled.Events exposing (onInput)
import SE.Framework.Colors exposing (black, darker, light, lighter, lightest, linkDark, primary, white)
import SE.Framework.Utils exposing (radius)


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
    | Link
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
    | Loading
    | Disabled
    | ReadOnly
    | Static


{-| Input
TODO add size modifier?
-}
input : InputRecord -> (String -> msg) -> Html msg
input rec onInput =
    styled Html.Styled.input
        inputStyle
        [ Html.Styled.Events.onInput onInput, placeholder rec.placeholder ]
        []



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
-- $input-focus-box-shadow-size: 0 0 0 0.125em !default
-- $input-focus-box-shadow-color: rgba($link, 0.25) !default
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
    [ controlStyle
    , Css.backgroundColor white
    , Css.borderColor light
    , Css.color darker
    ]



-- =input
--   +placeholder
--     color: $input-placeholder-color
--   &:hover,
--   &.is-hovered
--     border-color: $input-hover-border-color
--   &:focus,
--   &.is-focused,
--   &:active,
--   &.is-active
--     border-color: $input-focus-border-color
--     box-shadow: $input-focus-box-shadow-size $input-focus-box-shadow-color
--   &[disabled],
--   fieldset[disabled] &
--     background-color: $input-disabled-background-color
--     border-color: $input-disabled-border-color
--     box-shadow: none
--     color: $input-disabled-color
--     +placeholder
--       color: $input-disabled-placeholder-color


controlStyle : Style
controlStyle =
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
        ]



-- =control
--   // States
--   &:focus,
--   &.is-focused,
--   &:active,
--   &.is-active
--     outline: none
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
