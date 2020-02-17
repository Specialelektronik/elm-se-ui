module SE.UI.Form.Input exposing
    ( text, textarea, select, checkbox, radio, number, date, email, password, tel, toHtml
    , withPlaceholder, withStep, withRange, withRows
    )

{-| Holds the basic data for inputs, textareas and selects

Uses the with\*-pattern,

TODO elaborate on With\*
Explain Triggers

@docs text, textarea, select, checkbox, radio, number, date, email, password, tel, toHtml


# Modifiers

@docs withPlaceholder, withStep, withRange, withRows

-}

import Css exposing (Style, absolute, active, auto, block, center, deg, em, focus, hover, initial, inlineBlock, inlineFlex, int, middle, none, pct, pointer, pseudoClass, pseudoElement, px, relative, rem, rgba, rotate, scale, solid, top, vertical, zero)
import Css.Global exposing (adjacentSiblings, descendants, typeSelector, withAttribute)
import Css.Transitions
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events exposing (onInput)
import SE.UI.Colors as Colors
import SE.UI.Control as Control exposing (controlStyle)
import SE.UI.Utils as Utils
import Svg.Styled as Svg
import Svg.Styled.Attributes exposing (d, fill, height, stroke, strokeWidth, viewBox, width)


type Input msg
    = Text (InputRecord msg)
    | Number (NumberRecord (InputRecord msg))
    | Textarea (TextareaRecord (InputRecord msg))
    | Date
    | Password
    | Select
    | Checkbox
    | Radio
    | Email
    | Tel


type Trigger
    = OnInput
    | OnChange


type alias InputRecord msg =
    { value : String
    , placeholder : String
    , modifiers : List InputModifier
    , msg : String -> msg
    , trigger : Trigger
    }


{-| Number field has range and step as well
-}
type alias NumberRecord a =
    { a
        | range : Maybe ( Float, Float )
        , step : Maybe Float
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


type alias IsChecked =
    Bool


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



-- INPUT


{-| `input.input`
-}
text : (String -> msg) -> String -> Input msg
text msg value =
    Text
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        }



-- TEXTAREA


{-| `textarea.textarea`
-}
textarea : (String -> msg) -> String -> Input msg
textarea msg value =
    Textarea
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        , rows = 0
        }



-- SELECT


{-| `div.select > select`

`is-multiple` and `is-rounded` not supported

-}
select : SelectRecord (InputRecord msg) -> Html msg
select rec =
    let
        after =
            if List.member Loading rec.modifiers then
                [ Utils.loader
                , Css.marginTop zero
                , Css.position absolute
                , Css.right (em 0.625)
                , Css.top (em 0.625)
                , Css.transform none
                ]

            else
                [ arrow
                , Css.borderColor Colors.darker
                , Css.right (em 1.125)
                , Css.zIndex (int 4)
                ]
    in
    styled Html.div
        [ Css.display inlineBlock
        , Css.maxWidth (pct 100)
        , Css.position relative
        , Css.verticalAlign top
        , Css.height (em 2.5)
        , Css.after after
        ]
        []
        [ styled Html.select
            (inputStyle rec.modifiers
                ++ [ Css.cursor pointer
                   , Css.display block
                   , Css.maxWidth (pct 100)
                   , Css.outline none
                   , Css.paddingRight (em 2.5)
                   , pseudoElement "ms-expand" [ Css.display none ]
                   ]
            )
            [ Utils.onChange rec.msg
            ]
            (option rec.value { label = rec.placeholder, value = "" } :: List.map (option rec.value) rec.options)
        ]


option : String -> Option -> Html msg
option val o =
    Html.option
        [ Attributes.value o.value
        , Attributes.selected
            (o.value == val)
        ]
        [ Html.text o.label ]


arrow : Style
arrow =
    Css.batch
        [ Css.border3 (px 3) solid Colors.link
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
    styled Html.label
        [ Css.cursor pointer
        , adjacentSiblings
            [ typeSelector "label"
                [ Css.marginLeft (em 0.5)
                ]
            ]
        , hover
            [ descendants
                [ typeSelector "span"
                    [ Css.borderColor Colors.base
                    ]
                ]
            ]
        ]
        [ Events.onClick onClick ]
        [ styled Html.span
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
        , Html.text
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
    styled Html.label
        [ Css.cursor pointer
        , hover
            [ descendants
                [ typeSelector "span"
                    [ Css.borderColor Colors.base
                    ]
                ]
            ]
        ]
        [ Events.onClick onClick ]
        [ styled Html.span
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
                        , Css.backgroundColor Colors.primary
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
        , Html.text
            l
        ]


{-| `input[type="number"].input`

onChange is the default trigger

-}
number : (String -> msg) -> String -> Input msg
number msg value =
    Number
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        , range = Nothing
        , step = Nothing
        }


{-| `input[type="date"].input`
-}
date : DateRecord (InputRecord msg) -> Html msg
date rec =
    styled Html.input
        (inputStyle rec.modifiers)
        [ Attributes.type_ "date"
        , Attributes.min rec.min
        , Attributes.max rec.max
        , Attributes.pattern "(((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))-02-29)|(((19|2[0-9])[0-9]{2})-02-(0[1-9]|1[0-9]|2[0-8]))|(((19|2[0-9])[0-9]{2})-(0[13578]|10|12)-(0[1-9]|[12][0-9]|3[01]))|(((19|2[0-9])[0-9]{2})-(0[469]|11)-(0[1-9]|[12][0-9]|30)))" -- Pattern is for backward compatibility, leap year validation https://stackoverflow.com/a/55025950
        , Events.onInput rec.msg
        , Attributes.placeholder rec.placeholder
        , Attributes.value rec.value
        ]
        []


{-| `input[type="email"].input`
-}
email : InputRecord msg -> Html msg
email rec =
    styled Html.input
        (inputStyle rec.modifiers)
        [ Attributes.type_ "email"
        , Events.onInput rec.msg
        , Attributes.placeholder rec.placeholder
        , Attributes.value rec.value
        ]
        []


{-| `input[type="tel"].input`
-}
tel : InputRecord msg -> Html msg
tel rec =
    styled Html.input
        (inputStyle rec.modifiers)
        [ Attributes.type_ "tel"
        , Events.onInput rec.msg
        , Attributes.placeholder rec.placeholder
        , Attributes.value rec.value
        ]
        []


{-| `input[type="password"].input`
-}
password : PasswordRecord (InputRecord msg) -> Html msg
password rec =
    styled Html.input
        (inputStyle rec.modifiers)
        [ Attributes.type_ "password"
        , Events.onInput rec.msg
        , Attributes.placeholder rec.placeholder
        , Attributes.value rec.value
        , Attributes.attribute "autocomplete" (passwordAutocompleteToString rec.autocomplete)
        ]
        []


passwordAutocompleteToString : PasswordAutocomplete -> String
passwordAutocompleteToString a =
    case a of
        Current ->
            "current-password"

        New ->
            "new-password"


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


placeholder : List Style -> Style
placeholder c =
    Css.batch
        [ pseudoElement "placeholder" c
        , pseudoElement "-webkit-input-placeholder" c
        , pseudoElement "-ms-input-placeholder" c
        ]



-- TO HTML


toHtml : Input msg -> Html msg
toHtml input_ =
    case input_ of
        Text rec ->
            generalToHtml rec

        Number rec ->
            numberToHtml rec

        Textarea rec ->
            textareaToHtml rec

        _ ->
            Debug.todo (Debug.toString input_ ++ "not implemented yet")


generalToHtml : InputRecord msg -> Html msg
generalToHtml rec =
    styled Html.input
        (inputStyle rec.modifiers)
        (initAttributes rec.trigger rec.msg rec.value)
        []


numberToHtml : NumberRecord (InputRecord msg) -> Html msg
numberToHtml rec =
    let
        attrs =
            Attributes.type_ "number"
                :: initAttributes rec.trigger rec.msg rec.value
                |> maybeAttribute (Tuple.first >> String.fromFloat >> Attributes.min) rec.range
                |> maybeAttribute (Tuple.second >> String.fromFloat >> Attributes.max) rec.range
                |> maybeAttribute (String.fromFloat >> Attributes.step) rec.step
                |> boolAttribute (String.isEmpty >> not) Attributes.placeholder rec.placeholder
    in
    styled Html.input
        (inputStyle rec.modifiers)
        attrs
        []


textareaToHtml : TextareaRecord (InputRecord msg) -> Html msg
textareaToHtml rec =
    let
        attrs =
            Attributes.rows rec.rows :: initAttributes rec.trigger rec.msg rec.value
    in
    styled Html.textarea
        (textareaStyle rec.modifiers)
        attrs
        []



-- WITH STAR
-- This technique is called the "with*"-pattern (pron. With Star)


withPlaceholder : String -> Input msg -> Input msg
withPlaceholder placeholder_ input =
    case input of
        Text rec ->
            Text { rec | placeholder = placeholder_ }

        Number rec ->
            Number { rec | placeholder = placeholder_ }

        Textarea rec ->
            Textarea { rec | placeholder = placeholder_ }

        Date ->
            input

        Password ->
            input

        Select ->
            input

        Checkbox ->
            input

        Radio ->
            input

        Email ->
            input

        Tel ->
            input


{-| Add min and max to a number input. All other input types will ignore the range
-}
withRange : ( Float, Float ) -> Input msg -> Input msg
withRange range input =
    case input of
        Number rec ->
            let
                ( min, max ) =
                    ( Basics.min (Tuple.first range) (Tuple.second range)
                    , Basics.max (Tuple.first range) (Tuple.second range)
                    )
            in
            Number { rec | range = Just ( min, max ) }

        _ ->
            input


withStep : Float -> Input msg -> Input msg
withStep step input =
    case input of
        Number rec ->
            Number { rec | step = Just step }

        _ ->
            input


withRows : Int -> Input msg -> Input msg
withRows rows input =
    case input of
        Textarea rec ->
            Textarea { rec | rows = rows }

        _ ->
            input


triggerToAttribute : Trigger -> (String -> msg) -> Attribute msg
triggerToAttribute trigger =
    case trigger of
        OnInput ->
            Events.onInput

        OnChange ->
            Utils.onChange


maybeAttribute : (a -> Attribute msg) -> Maybe a -> List (Attribute msg) -> List (Attribute msg)
maybeAttribute attrFn maybeAttr attrs =
    case maybeAttr of
        Just val ->
            attrFn val :: attrs

        Nothing ->
            attrs


boolAttribute : (a -> Bool) -> (a -> Attribute msg) -> a -> List (Attribute msg) -> List (Attribute msg)
boolAttribute predicateFn attrFn val attrs =
    if predicateFn val then
        attrFn val :: attrs

    else
        attrs


initAttributes : Trigger -> (String -> msg) -> String -> List (Attribute msg)
initAttributes trigger msg value =
    [ triggerToAttribute trigger msg, Attributes.value value ]



-- STYLE


inputStyle : List InputModifier -> List Style
inputStyle mods =
    let
        size =
            extractControlSize mods
    in
    [ controlStyle size
    , Css.borderColor Colors.base
    , Css.color Colors.darker
    , Css.maxWidth (pct 100)
    , Css.width (pct 100)
    , placeholder
        [ Css.color (rgba 96 111 123 0.3)
        ]
    , hover
        [ Css.borderColor Colors.base
        ]
    , focus
        [ Css.borderColor Colors.link
        , Css.property "box-shadow" "0 0 0 0.125em rgba(50,115,220, 0.25)"
        ]
    , active
        [ Css.borderColor Colors.link
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
            style Colors.primary (Css.property "box-shadow" "0 0 0 0.125em rgba(53, 157, 55, 0.25)")

        Info ->
            style Colors.info (Css.property "box-shadow" "0 0 0 0.125em rgba(50, 115, 220, 0.25)")

        Success ->
            style Colors.success (Css.property "box-shadow" "0 0 0 0.125em rgba(35, 209, 96, 0.25)")

        Warning ->
            style Colors.warning (Css.property "box-shadow" "0 0 0 0.125em rgba(255,221,87, 0.25)")

        Danger ->
            style Colors.danger (Css.property "box-shadow" "0 0 0 0.125em rgba(255,56,96, 0.25)")

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
