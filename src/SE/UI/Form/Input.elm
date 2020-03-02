module SE.UI.Form.Input exposing
    ( text, textarea, select, checkbox, radio, number, date, email, password, tel, toHtml
    , withTrigger, Trigger(..)
    , withPlaceholder, withStep, withRange, withRows, withMinDate, withMaxDate
    , withModifier, Modifier(..)
    )

{-| Essentially all input elements except buttons


# With\* pattern (pron. With start pattern)

The inspiration to this module and its API comes from Brian Hicks talk about Robot Buttons from Mars (<https://youtu.be/PDyWP-0H4Zo?t=1467>). (Please view the entire talk).

Example:

    Input.text (\input -> TriggerMsgWithInputString input) inputStringValue
        |> Input.withPlaceholder "A placeholder to explain this input"
        |> Input.withModifier Input.Primary
        |> Input.toHtml

@docs text, textarea, select, checkbox, radio, number, date, email, password, tel, toHtml


# Triggers

Traditionally, Elm apps use [`onInput`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput) to drive form interactions. Sometimes though, we need to wait for the use to be done modifying the input before we can take action on it. The range filter inputs are an exceptional example of this since we do not want to alter the search result when the user adjust the price range. We should only update the query once the user have decided on an acceptable price range.

To allow the programmer to specify _when_ a message should trigger, the inputs have a `Trigger` type which can take either `OnInput` or `OnChange`. `OnChange` (usually) triggers once the user leaves the input.

@docs withTrigger, Trigger


# With\*

@docs withPlaceholder, withStep, withRange, withRows, withMinDate, withMaxDate


## Modifiers

@docs withModifier, Modifier

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
    | Date (DateRecord (InputRecord msg))
    | Password (PasswordRecord (InputRecord msg))
    | Select (SelectRecord msg)
    | Checkbox (CheckboxRecord msg)
    | Radio (CheckboxRecord msg)
    | Email (InputRecord msg)
    | Tel (InputRecord msg)


{-| Available triggers
-}
type Trigger
    = OnInput
    | OnChange


type alias InputRecord msg =
    { value : String
    , placeholder : String
    , modifiers : List Modifier
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
type alias SelectRecord msg =
    { value : String
    , placeholder : String
    , modifiers : List Modifier
    , msg : String -> msg
    , options : List Option
    }


{-| label and value properties for the <option> tag
-}
type alias Option =
    { label : String
    , value : String
    }


type alias CheckboxRecord msg =
    { label : String
    , msg : msg
    , checked : Bool
    , modifiers : List Modifier
    }


{-| Available input modifiers
-}
type
    Modifier
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
select : (String -> msg) -> List Option -> String -> Input msg
select msg options value =
    Select
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , options = options
        }


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
-}
checkbox : msg -> String -> Bool -> Input msg
checkbox msg label checked =
    Checkbox
        { label = label
        , msg = msg
        , checked = checked
        , modifiers = []
        }



-- RADIO


{-| The radio depart from Bulma, instead we use a styled span to get a "better looking" radio.
-}
radio : msg -> String -> Bool -> Input msg
radio msg label checked =
    Radio
        { label = label
        , msg = msg
        , checked = checked
        , modifiers = []
        }


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
date : (String -> msg) -> String -> Input msg
date msg value =
    Date
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        , min = ""
        , max = ""
        }


{-| `input[type="email"].input`
-}
email : (String -> msg) -> String -> Input msg
email msg value =
    Email
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        }


{-| `input[type="tel"].input`
-}
tel : (String -> msg) -> String -> Input msg
tel msg value =
    Tel
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        }


{-| `input[type="password"].input`
-}
password : (String -> msg) -> String -> Input msg
password msg value =
    Password
        { value = value
        , placeholder = ""
        , modifiers = []
        , msg = msg
        , trigger = OnChange
        , autocomplete = Current
        }


passwordAutocompleteToString : PasswordAutocomplete -> String
passwordAutocompleteToString a =
    case a of
        Current ->
            "current-password"

        New ->
            "new-password"


extractControlSize : List Modifier -> Control.Size
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


{-| Turn the Input into Html

Use it in the end of a pipeline, see the example at the top.

-}
toHtml : Input msg -> Html msg
toHtml input_ =
    case input_ of
        Text rec ->
            generalToHtml "text" rec

        Number rec ->
            numberToHtml rec

        Textarea rec ->
            textareaToHtml rec

        Date rec ->
            dateToHtml rec

        Email rec ->
            generalToHtml "email" rec

        Tel rec ->
            generalToHtml "tel" rec

        Select rec ->
            selectToHtml rec

        Password rec ->
            passwordToHtml rec

        Checkbox rec ->
            checkboxToHtml rec

        Radio rec ->
            radioToHtml rec


generalToHtml : String -> InputRecord msg -> Html msg
generalToHtml type_ rec =
    styled Html.input
        (inputStyle rec.modifiers)
        (Attributes.type_ type_
            :: initAttributes rec.trigger rec.msg rec.value
            |> noneEmptyAttribute Attributes.placeholder rec.placeholder
        )
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
                |> noneEmptyAttribute Attributes.placeholder rec.placeholder
    in
    styled Html.input
        (inputStyle rec.modifiers)
        attrs
        []


textareaToHtml : TextareaRecord (InputRecord msg) -> Html msg
textareaToHtml rec =
    let
        attrs =
            Attributes.rows rec.rows
                :: initAttributes rec.trigger rec.msg rec.value
                |> noneEmptyAttribute Attributes.placeholder rec.placeholder
    in
    styled Html.textarea
        (textareaStyle rec.modifiers)
        attrs
        []


dateToHtml : DateRecord (InputRecord msg) -> Html msg
dateToHtml rec =
    let
        attrs =
            initAttributes rec.trigger rec.msg rec.value
                ++ [ Attributes.pattern "(((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))-02-29)|(((19|2[0-9])[0-9]{2})-02-(0[1-9]|1[0-9]|2[0-8]))|(((19|2[0-9])[0-9]{2})-(0[13578]|10|12)-(0[1-9]|[12][0-9]|3[01]))|(((19|2[0-9])[0-9]{2})-(0[469]|11)-(0[1-9]|[12][0-9]|30)))" -- Pattern is for backward compatibility, leap year validation https://stackoverflow.com/a/55025950
                   , Attributes.type_ "date"
                   ]
                |> noneEmptyAttribute Attributes.min rec.min
                |> noneEmptyAttribute Attributes.max rec.max
                |> noneEmptyAttribute Attributes.placeholder rec.placeholder
    in
    styled Html.input
        (inputStyle rec.modifiers)
        attrs
        []


selectToHtml : SelectRecord msg -> Html msg
selectToHtml rec =
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


passwordToHtml : PasswordRecord (InputRecord msg) -> Html msg
passwordToHtml rec =
    let
        attrs =
            Attributes.type_ "password"
                :: Attributes.attribute "autocomplete" (passwordAutocompleteToString rec.autocomplete)
                :: initAttributes rec.trigger rec.msg rec.value
                |> noneEmptyAttribute Attributes.placeholder rec.placeholder
    in
    styled Html.input
        (inputStyle rec.modifiers)
        attrs
        []


checkboxToHtml : CheckboxRecord msg -> Html msg
checkboxToHtml rec =
    let
        tickSize =
            if rec.checked then
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
        [ Events.onClick rec.msg ]
        [ styled Html.span
            (inputStyle rec.modifiers
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
            rec.label
        ]


tick : Int -> Html msg
tick size =
    Svg.svg [ width (String.fromInt size), height (String.fromInt size), viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "4" ] [ Svg.path [ d "M20 6L9 17l-5-5" ] [] ]


radioToHtml : CheckboxRecord msg -> Html msg
radioToHtml rec =
    let
        checkedInt =
            if rec.checked then
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
        [ Events.onClick rec.msg ]
        [ styled Html.span
            (inputStyle rec.modifiers
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
            rec.label
        ]



-- WITH STAR


{-| Add placeholder to the input

Note: The checkbox and radio input does not have a placeholder so they will ignore calls to this function

-}
withPlaceholder : String -> Input msg -> Input msg
withPlaceholder placeholder_ input =
    case input of
        Text rec ->
            Text { rec | placeholder = placeholder_ }

        Number rec ->
            Number { rec | placeholder = placeholder_ }

        Textarea rec ->
            Textarea { rec | placeholder = placeholder_ }

        Date rec ->
            Date { rec | placeholder = placeholder_ }

        Password rec ->
            Password { rec | placeholder = placeholder_ }

        Select rec ->
            Select { rec | placeholder = placeholder_ }

        Email rec ->
            Email { rec | placeholder = placeholder_ }

        Tel rec ->
            Tel { rec | placeholder = placeholder_ }

        Checkbox _ ->
            input

        Radio _ ->
            input


{-| Change the trigger of the input

Note: The checkbox, radio and select input will ignore calls to this function since they can only the onChange trigger

-}
withTrigger : Trigger -> Input msg -> Input msg
withTrigger trigger input =
    case input of
        Text rec ->
            Text { rec | trigger = trigger }

        Number rec ->
            Number { rec | trigger = trigger }

        Textarea rec ->
            Textarea { rec | trigger = trigger }

        Date rec ->
            Date { rec | trigger = trigger }

        Password rec ->
            Password { rec | trigger = trigger }

        Email rec ->
            Email { rec | trigger = trigger }

        Tel rec ->
            Tel { rec | trigger = trigger }

        Checkbox _ ->
            input

        Radio _ ->
            input

        Select _ ->
            input


{-| Add min and max to a number input. All other input types will ignore this function
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


{-| Add step to a number input. All other input types will ignore this function
-}
withStep : Float -> Input msg -> Input msg
withStep step input =
    case input of
        Number rec ->
            Number { rec | step = Just step }

        _ ->
            input


{-| Add rows a textarea input. All other input types will ignore this function
-}
withRows : Int -> Input msg -> Input msg
withRows rows input =
    case input of
        Textarea rec ->
            Textarea { rec | rows = rows }

        _ ->
            input


{-| Add max date to a date input. All other input types will ignore this function
-}
withMaxDate : String -> Input msg -> Input msg
withMaxDate max input =
    case input of
        Date rec ->
            Date { rec | max = max }

        _ ->
            input


{-| Add min date to a date input. All other input types will ignore this function
-}
withMinDate : String -> Input msg -> Input msg
withMinDate min input =
    case input of
        Date rec ->
            Date { rec | min = min }

        _ ->
            input


{-| Add a `Modifier` to an input.

Please review the Modifier documentation for further information.

-}
withModifier : Modifier -> Input msg -> Input msg
withModifier mod input =
    case input of
        Text rec ->
            Text { rec | modifiers = mod :: rec.modifiers }

        Number rec ->
            Number { rec | modifiers = mod :: rec.modifiers }

        Textarea rec ->
            Textarea { rec | modifiers = mod :: rec.modifiers }

        Date rec ->
            Date { rec | modifiers = mod :: rec.modifiers }

        Password rec ->
            Password { rec | modifiers = mod :: rec.modifiers }

        Select rec ->
            Select { rec | modifiers = mod :: rec.modifiers }

        Email rec ->
            Email { rec | modifiers = mod :: rec.modifiers }

        Tel rec ->
            Tel { rec | modifiers = mod :: rec.modifiers }

        Checkbox rec ->
            Checkbox { rec | modifiers = mod :: rec.modifiers }

        Radio rec ->
            Radio { rec | modifiers = mod :: rec.modifiers }


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


noneEmptyAttribute : (String -> Attribute msg) -> String -> List (Attribute msg) -> List (Attribute msg)
noneEmptyAttribute =
    boolAttribute (String.isEmpty >> not)


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


inputStyle : List Modifier -> List Style
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


inputModifierStyle : Modifier -> Style
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
            Debug.log "danger style" style Colors.danger (Css.property "box-shadow" "0 0 0 0.125em rgba(255,56,96, 0.25)")

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


textareaStyle : List Modifier -> List Style
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
