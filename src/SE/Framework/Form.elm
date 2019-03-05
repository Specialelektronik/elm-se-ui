module SE.Framework.Form exposing (InputModifier(..), InputRecord, checkbox, control, field, input, select, textarea)

import Css exposing (Style, absolute, active, auto, block, bold, borderBox, calc, center, deg, em, flexStart, focus, hover, important, initial, inlineBlock, inlineFlex, int, left, middle, minus, noRepeat, none, pct, pointer, pseudoClass, pseudoElement, px, relative, rem, rgba, rotate, scale, solid, sub, top, transparent, url, vertical, zero)
import Css.Global exposing (descendants, each, withAttribute)
import Css.Transitions
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (placeholder)
import Html.Styled.Events exposing (onInput)
import SE.Framework.Colors exposing (base, black, danger, darker, info, light, lighter, lightest, link, linkDark, primary, success, warning, white)
import SE.Framework.Utils as Utils exposing (loader, radius)


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


type alias TextareaRecord a =
    { a
        | rows : Int
    }


type alias SelectRecord a =
    { a
        | options : List Option
    }


type alias Option =
    { label : String
    , value : String
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
    | Loading
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


textarea : TextareaRecord InputRecord -> (String -> msg) -> String -> Html msg
textarea rec onInput val =
    styled Html.Styled.textarea
        (textareaStyle
            ++ List.map inputModifierStyle
                rec.modifiers
        )
        [ Html.Styled.Events.onInput onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value val
        , Html.Styled.Attributes.rows rec.rows
        ]
        []


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

        Loading ->
            Css.batch []

        Static ->
            Css.batch []

        Disabled ->
            Css.batch []

        ReadOnly ->
            Css.batch []


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


textareaStyle : List Style
textareaStyle =
    inputStyle
        ++ [ Css.display block
           , Css.maxWidth (pct 100)
           , Css.minWidth (pct 100)
           , Css.padding (em 0.625)
           , Css.resize vertical
           , pseudoClass "not([rows])"
                [ Css.maxHeight (px 600)
                , Css.minHeight (px 120)
                ]
           , withAttribute "rows"
                [ Css.height initial
                ]
           ]


placeholder : List Style -> Style
placeholder c =
    Css.batch
        [ pseudoElement "placeholder" c
        , pseudoElement "-webkit-input-placeholder" c
        , pseudoElement "-ms-input-placeholder" c
        ]


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


select : SelectRecord InputRecord -> (String -> msg) -> String -> Html msg
select rec onChange val =
    let
        after =
            if List.member Loading rec.modifiers then
                [ loader
                , Css.marginTop zero
                , Css.position absolute
                , Css.right (em 0.625)
                , Css.top (em 0.625)
                , Css.transform none
                ]

            else
                [ arrow
                , Css.borderColor darker
                , Css.right (em 1.125)
                , Css.zIndex (int 4)
                ]
    in
    styled Html.Styled.div
        [ Css.display inlineBlock
        , Css.maxWidth (pct 100)
        , Css.position relative
        , Css.verticalAlign top
        , Css.height (em 2.25)
        , Css.after after
        ]
        []
        [ styled Html.Styled.select
            (inputStyle
                ++ [ Css.cursor pointer
                   , Css.display block
                   , Css.fontSize (em 1)
                   , Css.maxWidth (pct 100)
                   , Css.outline none
                   , Css.paddingRight (em 2.5)
                   , pseudoElement "ms-expand" [ Css.display none ]
                   ]
                ++ List.map inputModifierStyle
                    rec.modifiers
            )
            [ Utils.onChange onChange
            ]
            (option val { label = rec.placeholder, value = "" } :: List.map (option val) rec.options)
        ]


option : String -> Option -> Html msg
option val o =
    Html.Styled.option
        [ Html.Styled.Attributes.value o.value
        , Html.Styled.Attributes.selected
            (o.value == val)
        ]
        [ text o.label ]


arrow : Style
arrow =
    Css.batch
        [ Css.border3 (px 3) solid link
        , Css.borderRadius (px 2)
        , Css.borderRight zero
        , Css.borderTop zero
        , Css.property "content" "\"\""
        , Css.display block
        , Css.height (em 0.625)
        , Css.marginTop (em -0.4375)
        , Css.pointerEvents none
        , Css.position absolute
        , Css.top (pct 50)
        , Css.transform (rotate (deg -45))
        , Css.width (em 0.625)
        ]


checkbox : String -> Bool -> msg -> Html msg
checkbox l checked onClick =
    let
        checkedInt =
            if checked then
                1

            else
                0
    in
    styled Html.Styled.div
        [ Css.cursor pointer ]
        [ Html.Styled.Events.onClick onClick ]
        [ styled Html.Styled.span
            (inputStyle
                ++ [ Css.width (rem 0.875)
                   , Css.height (rem 0.875)
                   , Css.padding zero
                   , Css.verticalAlign middle
                   , Css.marginBottom (px 2)
                   , Css.property "margin-right" "calc(0.625em - 1px)"
                   , Css.before
                        [ Css.display block
                        , Css.property "content" "\"\""
                        , Css.width (rem 0.875)
                        , Css.height (rem 0.875)
                        , Css.backgroundImage (url "/images/tick.svg")
                        , Css.backgroundRepeat noRepeat
                        , Css.backgroundPosition center
                        , Css.backgroundSize2 (rem 0.5) auto
                        , Css.transform (scale checkedInt)
                        , Css.Transitions.transition
                            [ Css.Transitions.transform 100
                            ]
                        ]
                   ]
            )
            []
            []
        , text
            l
        ]
