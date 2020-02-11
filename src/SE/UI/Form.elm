module SE.UI.Form exposing
    ( label, input, textarea, select, checkbox, radio, number, date, email, password, tel
    , InputModifier(..), InputRecord, NumberRecord, TextareaRecord, SelectRecord, Option, PasswordRecord, PasswordAutocomplete
    , field, FieldModifier(..), control, expandedControl
    )

{-| Bulmas Form elements
see <https://bulma.io/documentation/form/>


# General

@docs label, input, textarea, select, checkbox, radio, number, date, email, password, tel


# Input Record and Modifiers

@docs InputModifier, InputRecord, NumberRecord, TextareaRecord, SelectRecord, Option, PasswordRecord, PasswordAutocomplete


# Fields and Controls

@docs field, FieldModifier, control, expandedControl


# Unsupported features

  - Horizontal form
  - Size modifier (for some elements)
  - .help
  - icons in input, textarea, select .control

-}

import Css exposing (Style, absolute, active, auto, block, bold, borderBox, center, deg, em, flexStart, focus, hover, important, initial, inlineBlock, inlineFlex, int, left, middle, none, pct, pointer, pseudoClass, pseudoElement, px, relative, rem, rgba, rotate, scale, solid, top, vertical, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, typeSelector, withAttribute)
import Css.Transitions
import Html.Styled exposing ( Html, styled, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onInput)
import SE.UI.Colors as Colors exposing (base, danger, darker, info, link, primary, success, warning)
import SE.UI.Control as Control exposing (controlStyle)
import SE.UI.Utils as Utils exposing (loader)
import Svg.Styled as Svg
import Svg.Styled.Attributes exposing (d, fill, height, stroke, strokeWidth, viewBox, width)


{-| Holds the basic data for inputs, textareas and selects
-}
type alias InputRecord msg =
    { value : String
    , placeholder : String
    , modifiers : List InputModifier
    , onInput : String -> msg
    }


{-| Number field has range and step as well
-}
type alias NumberRecord a =
    { a
        | range : ( Float, Float )
        , step : Float
    }


{-| Date field has min and max
-}
type alias DateRecord a =
    { a
        | min : String
        , max : String
    }


{-| Password fields has an autocomplete property that can hint at the browser what kind is password field it is. That way the browser can suggest new passwords or the current password depending on the situation.
-}
type alias PasswordRecord a =
    { a
        | autocomplete : PasswordAutocomplete
    }


{-| See <https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/password#Allowing_autocomplete>
-}
type PasswordAutocomplete
    = Current
    | New


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


{-| label and value properties for the <option> tag
-}
type alias Option =
    { label : String
    , value : String
    }


{-| Available input modifiers
-}
type
    InputModifier
    -- Colors
    = Primary
    | Info
    | Success
    | Warning
    | Danger
      -- Size
    | Size Control.Size
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
        (inputStyle rec.modifiers)
        [ Html.Styled.Events.onInput rec.onInput, Html.Styled.Attributes.placeholder rec.placeholder, Html.Styled.Attributes.value rec.value ]
        []


{-| `input[type="number"].input`
-}
number : NumberRecord (InputRecord msg) -> Html msg
number rec =
    let
        ( min, max ) =
            ( Basics.min (Tuple.first rec.range) (Tuple.second rec.range)
            , Basics.max (Tuple.first rec.range) (Tuple.second rec.range)
            )
    in
    styled Html.Styled.input
        (inputStyle rec.modifiers)
        [ Html.Styled.Attributes.type_ "number"
        , Html.Styled.Attributes.min (String.fromFloat min)
        , Html.Styled.Attributes.max (String.fromFloat max)
        , Html.Styled.Attributes.step (String.fromFloat rec.step)
        , Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        ]
        []


{-| `input[type="date"].input`
-}
date : DateRecord (InputRecord msg) -> Html msg
date rec =
    styled Html.Styled.input
        (inputStyle rec.modifiers)
        [ Html.Styled.Attributes.type_ "date"
        , Html.Styled.Attributes.min rec.min
        , Html.Styled.Attributes.max rec.max
        , Html.Styled.Attributes.pattern "(((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))-02-29)|(((19|2[0-9])[0-9]{2})-02-(0[1-9]|1[0-9]|2[0-8]))|(((19|2[0-9])[0-9]{2})-(0[13578]|10|12)-(0[1-9]|[12][0-9]|3[01]))|(((19|2[0-9])[0-9]{2})-(0[469]|11)-(0[1-9]|[12][0-9]|30)))" -- Pattern is for backward compatibility, leap year validation https://stackoverflow.com/a/55025950
        , Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        ]
        []


{-| `input[type="email"].input`
-}
email : InputRecord msg -> Html msg
email rec =
    styled Html.Styled.input
        (inputStyle rec.modifiers)
        [ Html.Styled.Attributes.type_ "email"
        , Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        ]
        []


{-| `input[type="tel"].input`
-}
tel : InputRecord msg -> Html msg
tel rec =
    styled Html.Styled.input
        (inputStyle rec.modifiers)
        [ Html.Styled.Attributes.type_ "tel"
        , Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        ]
        []


{-| `input[type="password"].input`
-}
password : PasswordRecord (InputRecord msg) -> Html msg
password rec =
    styled Html.Styled.input
        (inputStyle rec.modifiers)
        [ Html.Styled.Attributes.type_ "password"
        , Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        , Html.Styled.Attributes.attribute "autocomplete" (passwordAutocompleteToString rec.autocomplete)
        ]
        []


passwordAutocompleteToString : PasswordAutocomplete -> String
passwordAutocompleteToString a =
    case a of
        Current ->
            "current-password"

        New ->
            "new-password"


inputStyle : List InputModifier -> List Style
inputStyle mods =
    let
        size =
            extractControlSize mods
    in
    [ controlStyle size
    , Css.borderColor base
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
        ++ List.map inputModifierStyle mods


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

        Size _ ->
            Css.batch []

        Loading ->
            Css.batch []

        Static ->
            Css.batch []

        Disabled ->
            Css.batch []

        ReadOnly ->
            Css.batch []


extractControlSize : List InputModifier -> Control.Size
extractControlSize mods =
    List.foldl
        (\m init ->
            case m of
                Size s ->
                    s

                _ ->
                    init
        )
        Control.Regular
        mods



-- TEXTAREA


{-| `textarea.textarea`
-}
textarea : TextareaRecord (InputRecord msg) -> Html msg
textarea rec =
    styled Html.Styled.textarea
        (textareaStyle rec.modifiers)
        [ Html.Styled.Events.onInput rec.onInput
        , Html.Styled.Attributes.placeholder rec.placeholder
        , Html.Styled.Attributes.value rec.value
        , Html.Styled.Attributes.rows rec.rows
        ]
        []


textareaStyle : List InputModifier -> List Style
textareaStyle mods =
    inputStyle mods
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
            (inputStyle rec.modifiers
                ++ [ Css.cursor pointer
                   , Css.display block
                   , Css.maxWidth (pct 100)
                   , Css.outline none
                   , Css.paddingRight (em 2.5)
                   , pseudoElement "ms-expand" [ Css.display none ]
                   ]
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
TODO checkbox does not support modifiers, should it?
-}
checkbox : String -> IsChecked -> msg -> Html msg
checkbox l checked onClick =
    let
        tickSize =
            if checked then
                24

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
            (inputStyle []
                ++ [ Css.width (rem 1.25)
                   , Css.height (rem 1.25)
                   , Css.padding zero
                   , Css.verticalAlign middle
                   , Css.marginBottom (px 2)
                   , Css.property "margin-right" "calc(0.625em - 1px)"
                   , Css.color Colors.success
                   , Css.display inlineFlex
                   , Css.justifyContent center
                   , Css.alignItems center
                   ]
            )
            []
            [ tick tickSize ]
        , text
            l
        ]


tick : Int -> Html msg
tick size =
    Svg.svg [ width (String.fromInt size), height (String.fromInt size), viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "4" ] [ Svg.path [ d "M20 6L9 17l-5-5" ] [] ]



-- RADIO


{-| The radio depart from Bulma, instead we use a styled span to get a "better looking" radio.
TODO radio does not support modifiers, should it?
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
            (inputStyle []
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
