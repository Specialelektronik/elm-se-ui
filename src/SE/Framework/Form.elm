module SE.Framework.Form exposing
    ( label, input, textarea, select, checkbox, radio
    , InputModifier(..), InputRecord
    , field, FieldModifier(..), control, expandedControl
    )

{-| Bulmas Form elements
see <https://bulma.io/documentation/form/>


# General

@docs label, input, textarea, select, checkbox, radio


# Input Record and Modifiers

@docs InputModifier, InputRecord


# Fields and Controls

@docs field, FieldModifier, control, expandedControl


# Unsupported features

  - Horizontal form
  - Size modifier
  - .help
  - icons in input, textarea, select .control

-}

import Css exposing (Style, absolute, active, auto, block, bold, borderBox, calc, center, deg, em, flexStart, focus, hover, important, initial, inlineBlock, inlineFlex, int, left, middle, minus, noRepeat, none, pct, pointer, pseudoClass, pseudoElement, px, relative, rem, rgba, rotate, scale, solid, sub, top, transparent, url, vertical, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, typeSelector, withAttribute)
import Css.Transitions
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onInput)
import SE.Framework.Colors as Colors exposing (base, black, danger, darker, info, light, link, primary, success, warning, white)
import SE.Framework.Control exposing (controlStyle)
import SE.Framework.Utils as Utils exposing (loader, radius)


{-| Holds the basic data for inputs, textareas and selects
-}
type alias InputRecord msg =
    { value : String
    , placeholder : String
    , modifiers : List InputModifier
    , onInput : String -> msg
    }


{-| Textareas also need a rows attribute
-}
type alias TextareaRecord a =
    { a
        | rows : Int
    }


{-| Selects also need a rows attribute
-}
type alias SelectRecord a =
    { a
        | options : List Option
    }


type alias Option =
    { label : String
    , value : String
    }


{-| Size modifiers are not supported at the moment.
-}
type
    InputModifier
    -- Colors
    = Primary
    | Info
    | Success
    | Warning
    | Danger
      -- State
    | Loading
    | Disabled
    | ReadOnly
    | Static


{-| Field Modifier
-}
type FieldModifier
    = Attached
    | Grouped


type alias IsChecked =
    Bool


type alias IsLoading =
    Bool



-- LABEL


{-| `label.label`
-}
label : String -> Html msg
label s =
    styled Html.Styled.label
        [ Css.color Colors.text
        , Css.display block
        , Css.fontSize (rem 1)
        , Css.fontWeight bold
        , pseudoClass "not(:last-child)"
            [ Css.marginBottom (em 0.5)
            ]
        ]
        []
        [ text s ]



-- INPUT


{-| `input.input`
-}
input : InputRecord msg -> Html msg
input rec =
    styled Html.Styled.input
        (inputStyle
            ++ List.map inputModifierStyle
                rec.modifiers
        )
        [ Html.Styled.Events.onInput rec.onInput, Html.Styled.Attributes.placeholder rec.placeholder, Html.Styled.Attributes.value rec.value ]
        []


inputStyle : List Style
inputStyle =
    [ controlStyle
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



-- TEXTAREA


{-| `textarea.textarea`
-}
textarea : TextareaRecord (InputRecord msg) -> Html msg
textarea rec =
    styled Html.Styled.textarea
        (textareaStyle
            ++ List.map inputModifierStyle
                rec.modifiers
        )
        [ Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        , Html.Styled.Attributes.rows rec.rows
        ]
        []


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



-- SELECT


{-| `div.select > select`

`is-multiple` and `is-rounded` not supported

-}
select : SelectRecord (InputRecord msg) -> Html msg
select rec =
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
        , Css.height (em 2.5)
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
            [ Utils.onChange rec.onInput
            ]
            (option rec.value { label = rec.placeholder, value = "" } :: List.map (option rec.value) rec.options)
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



-- CHECKBOX


{-| The checkbox depart from Bulma, instead we use a styled span to get a "better looking" checkbox.
-}
checkbox : String -> IsChecked -> msg -> Html msg
checkbox l checked onClick =
    let
        checkedInt =
            if checked then
                1

            else
                0
    in
    styled Html.Styled.label
        [ Css.cursor pointer
        , adjacentSiblings
            [ typeSelector "label"
                [ Css.marginLeft (em 0.5)
                ]
            ]
        , hover
            [ descendants
                [ typeSelector "span"
                    [ Css.borderColor base
                    ]
                ]
            ]
        ]
        [ Html.Styled.Events.onClick onClick ]
        [ styled Html.Styled.span
            (inputStyle
                ++ [ Css.width (rem 1.25)
                   , Css.height (rem 1.25)
                   , Css.padding zero
                   , Css.verticalAlign middle
                   , Css.marginBottom (px 2)
                   , Css.property "margin-right" "calc(0.625em - 1px)"
                   , Css.before
                        [ Css.display block
                        , Css.property "content" "\"\""
                        , Css.width (rem 1.25)
                        , Css.height (rem 1.25)
                        , Css.backgroundImage (url "/images/tick.svg")
                        , Css.backgroundRepeat noRepeat
                        , Css.backgroundPosition center
                        , Css.backgroundSize2 (rem 0.6) auto
                        , Css.transform (scale checkedInt)
                        , Css.Transitions.transition
                            [ Css.Transitions.transform 60
                            ]
                        ]
                   ]
            )
            []
            []
        , text
            l
        ]



-- RADIO


{-| The radio depart from Bulma, instead we use a styled span to get a "better looking" radio.
-}
radio : String -> IsChecked -> msg -> Html msg
radio l checked onClick =
    let
        checkedInt =
            if checked then
                1

            else
                0
    in
    styled Html.Styled.label
        [ Css.cursor pointer
        , hover
            [ descendants
                [ typeSelector "span"
                    [ Css.borderColor base
                    ]
                ]
            ]
        ]
        [ Html.Styled.Events.onClick onClick ]
        [ styled Html.Styled.span
            (inputStyle
                ++ [ Css.width (rem 1.25)
                   , Css.height (rem 1.25)
                   , Css.padding zero
                   , Css.verticalAlign middle
                   , Css.marginBottom (px 2)
                   , Css.property "margin-right" "calc(0.625em - 1px)"
                   , Css.borderRadius (pct 50)
                   , Css.before
                        [ Css.display block
                        , Css.property "content" "\"\""
                        , Css.width (pct 50)
                        , Css.height (pct 50)
                        , Css.margin2 zero auto
                        , Css.backgroundColor primary
                        , Css.borderRadius (pct 50)
                        , Css.transform (scale checkedInt)
                        , Css.Transitions.transition
                            [ Css.Transitions.transform 60
                            ]
                        ]
                   ]
            )
            []
            []
        , text
            l
        ]


{-| `div.field`

    field [] [ text "Field" ] == "<div class='field'>Field</div>"

    field [ Attached ] [ text "Attached field" ] = "<div class='field'> Attached field</div>"

    field [ Grouped ] [ text "Grouped field" ] = "<div class='field'>Grouped field</div>"

-}
field : List FieldModifier -> List (Html msg) -> Html msg
field mods =
    styled Html.Styled.div
        [ pseudoClass "not(:last-child)"
            [ Css.marginBottom (rem 0.75)
            ]
        , Css.batch (List.map fieldModifier mods)
        ]
        []


fieldModifier : FieldModifier -> Style
fieldModifier mod =
    Css.batch
        (case mod of
            Attached ->
                [ Css.displayFlex
                , Css.justifyContent flexStart
                , descendants
                    [ Css.Global.class "control"
                        [ pseudoClass "not(:last-child)"
                            [ Css.marginRight (px -1)
                            ]
                        , pseudoClass "not(:first-child):not(:last-child)"
                            [ descendants
                                [ each
                                    [ typeSelector "button"
                                    , typeSelector "input"
                                    , typeSelector "select"
                                    ]
                                    [ Css.borderRadius zero ]
                                ]
                            ]
                        , pseudoClass "first-child:not(:only-child)"
                            [ descendants
                                [ each
                                    [ typeSelector "button"
                                    , typeSelector "input"
                                    , typeSelector "select"
                                    ]
                                    [ Css.borderBottomRightRadius zero
                                    , Css.borderTopRightRadius zero
                                    ]
                                ]
                            ]
                        , pseudoClass "last-child:not(:only-child)"
                            [ descendants
                                [ each
                                    [ typeSelector "button"
                                    , typeSelector "input"
                                    , typeSelector "select"
                                    ]
                                    [ Css.borderBottomLeftRadius zero
                                    , Css.borderTopLeftRadius zero
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]

            Grouped ->
                [ Css.displayFlex
                , Css.justifyContent flexStart
                , Css.Global.children
                    [ Css.Global.class "control"
                        [ Css.flexShrink zero
                        , pseudoClass "not(:last-child)"
                            [ Css.marginBottom zero
                            , Css.marginRight (rem 0.75)
                            ]
                        ]
                    ]
                ]
        )


{-| `div.control`

    control False [] == "<div class='control'></div>"

    control True [] == "<div class='control is-loading'></div>"

-}
control : IsLoading -> List (Html msg) -> Html msg
control =
    internalControl False


{-| `div.control.is-expanded`

    expandedControl False [] == "<div class='controlis-expanded'></div>"

    expandedControl True [] == "<div class='control is-expanded is-loading'></div>"

-}
expandedControl : IsLoading -> List (Html msg) -> Html msg
expandedControl =
    internalControl True


internalControl : Bool -> Bool -> List (Html msg) -> Html msg
internalControl isExpanded loading =
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
         , if isExpanded then
            Css.flexGrow (int 1)

           else
            Css.batch []
         ]
            ++ loadingStyle
        )
        [ class "control" ]


placeholder : List Style -> Style
placeholder c =
    Css.batch
        [ pseudoElement "placeholder" c
        , pseudoElement "-webkit-input-placeholder" c
        , pseudoElement "-ms-input-placeholder" c
        ]
