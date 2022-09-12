module SE.UI.Form.Input exposing
    ( text, textarea, select, Option, checkbox, radio, CheckboxLabel, number, date, email, password, tel, toHtml
    , withTrigger, Trigger(..)
    , withPlaceholder, withName, withRequired, withDisabled, withReadonly, withStep, withRange, withRows, withMinDate, withMaxDate, withNewPassword, withCustomLabel, withValue
    , withModifier, withModifiers, Modifier(..)
    , inputStyle
    )

{-| Essentially all input elements except buttons


# With\* pattern (pron. With start pattern)

The inspiration to this module and its API comes from Brian Hicks talk about Robot Buttons from Mars (<https://youtu.be/PDyWP-0H4Zo?t=1467>). (Please view the entire talk).

Example:

    Input.text (\input -> TriggerMsgWithInputString input) inputStringValue
        |> Input.withPlaceholder "A placeholder to explain this input"
        |> Input.withModifier Input.Primary
        |> Input.toHtml

@docs text, textarea, select, Option, checkbox, radio, CheckboxLabel, number, date, email, password, tel, toHtml


# Triggers

Traditionally, Elm apps use [`onInput`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput) to drive form interactions. Sometimes though, we need to wait for the use to be done modifying the input before we can take action on it. The range filter inputs are an exceptional example of this since we do not want to alter the search result when the user adjust the price range. We should only update the query once the user have decided on an acceptable price range.

To allow the programmer to specify _when_ a message should trigger, the inputs have a `Trigger` type which can take either `OnInput` or `OnChange`. `OnChange` (usually) triggers once the user leaves the input.

@docs withTrigger, Trigger


# With\*

@docs withPlaceholder, withName, withRequired, withDisabled, withReadonly, withStep, withRange, withRows, withMinDate, withMaxDate, withNewPassword, withCustomLabel, withValue


## Modifiers

@docs withModifier, withModifiers, Modifier


# Styles

@docs inputStyle

-}

import Css exposing (Style, active, block, center, em, focus, hover, initial, inlineBlock, none, pct, pointer, pseudoClass, pseudoElement, px, vertical, zero)
import Css.Global exposing (withAttribute)
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events exposing (onInput)
import Json.Decode as Decode
import SE.UI.Colors as Colors
import SE.UI.Control as Control exposing (controlStyle)
import SE.UI.Icon.V2 as Icon
import SE.UI.Utils as Utils
import Svg.Styled.Attributes exposing (height, width)


type Input msg
    = Text (InputRecord msg)
    | Number (NumberRecord (InputRecord msg))
    | Textarea (TextareaRecord (InputRecord msg))
    | Date (DateRecord (InputRecord msg))
    | Password (PasswordRecord (InputRecord msg))
    | Select (SelectRecord msg)
    | Button ButtonType (CheckboxRecord msg)
    | Email (InputRecord msg)
    | Tel (InputRecord msg)


type ButtonType
    = Checkbox
    | Radio


{-| Available triggers
-}
type Trigger
    = OnInput
    | OnChange
    | OnBlur


type alias InputRecord msg =
    { value : String
    , placeholder : String
    , modifiers : List Modifier
    , msg : String -> msg
    , trigger : Trigger
    , required : Bool
    , disabled : Bool
    , readonly : Bool
    , name : String
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
    , required : Bool
    , disabled : Bool
    , readonly : Bool
    , name : String
    }


{-| label and value properties for the <option> tag
-}
type alias Option =
    { label : String
    , value : String
    }


type alias CheckboxRecord msg =
    { label : CheckboxLabel
    , msg : msg
    , checked : Bool
    , modifiers : List Modifier
    , required : Bool
    , disabled : Bool
    , readonly : Bool
    , name : String
    , value : String
    }


{-| Style checkbox and radio labels.
Each checkbox and radio is encapsulated in a label element with default styling. If you want to include anything else than a simple String label, use Custom and include styling to determine how the label show align your content. Preferably `Css.alignItems`.
-}
type CheckboxLabel
    = Simple String
    | Custom (List Style) (List (Html Never))


{-| Available input modifiers
-}
type
    Modifier
    -- Colors
    = Primary
    | Danger
      -- Size
    | Size Control.Size
      -- State
    | Loading
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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
        }



-- SELECT


{-| `select` with input styling

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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
        }


option : String -> Option -> Html msg
option val o =
    Html.option
        [ Attributes.value o.value
        , Attributes.selected
            (o.value == val)
        ]
        [ Html.text o.label ]



-- CHECKBOX


{-| The checkbox depart from Bulma to get a "better looking" checkbox.
-}
checkbox : msg -> String -> Bool -> Input msg
checkbox msg label checked =
    Button Checkbox
        { label = Simple label
        , msg = msg
        , checked = checked
        , modifiers = []
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
        , value = ""
        }



-- RADIO


{-| The radio depart from Bulma to get a "better looking" radio.
-}
radio : msg -> String -> Bool -> Input msg
radio msg label checked =
    Button Radio
        { label = Simple label
        , msg = msg
        , checked = checked
        , modifiers = []
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
        , value = ""
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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
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
        , trigger = OnBlur
        , min = ""
        , max = ""
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
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
        , required = False
        , disabled = False
        , readonly = False
        , name = ""
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

        Button type_ rec ->
            buttonToHtml type_ rec


generalToHtml : String -> InputRecord msg -> Html msg
generalToHtml type_ rec =
    styled Html.input
        (inputStyle rec.modifiers)
        (Attributes.type_ type_
            :: initAttributes rec
            |> noneEmptyAttribute Attributes.placeholder rec.placeholder
        )
        []


numberToHtml : NumberRecord (InputRecord msg) -> Html msg
numberToHtml rec =
    let
        attrs =
            Attributes.type_ "number"
                :: initAttributes rec
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
                :: initAttributes rec
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
            initAttributes rec
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


{-| New select element based on <https://www.filamentgroup.com/lab/select-css.html>
-}
selectToHtml : SelectRecord msg -> Html msg
selectToHtml rec =
    styled Html.select
        (selectStyle rec.modifiers)
        ([ Utils.onChange rec.msg
         ]
            |> boolAttribute Attributes.required rec.required
            |> boolAttribute Attributes.disabled rec.disabled
            |> boolAttribute Attributes.readonly rec.readonly
            |> noneEmptyAttribute Attributes.name rec.name
        )
        (option rec.value { label = rec.placeholder, value = "" } :: List.map (option rec.value) rec.options)


passwordToHtml : PasswordRecord (InputRecord msg) -> Html msg
passwordToHtml rec =
    let
        attrs =
            Attributes.type_ "password"
                :: Attributes.attribute "autocomplete" (passwordAutocompleteToString rec.autocomplete)
                :: initAttributes rec
                |> noneEmptyAttribute Attributes.placeholder rec.placeholder
    in
    styled Html.input
        (inputStyle rec.modifiers)
        attrs
        []


buttonToHtml : ButtonType -> CheckboxRecord msg -> Html msg
buttonToHtml buttonType rec =
    let
        isLoading =
            List.member Loading rec.modifiers

        isDisabled =
            isLoading || rec.disabled

        { type_, bg, radius } =
            case buttonType of
                Checkbox ->
                    { type_ = "checkbox", bg = Icon.tick, radius = Css.borderRadius (Css.em 0.25) }

                Radio ->
                    { type_ = "radio", bg = Icon.circle, radius = Css.borderRadius (Css.pct 100) }

        cursor =
            if isDisabled then
                Css.notAllowed

            else
                Css.pointer

        labelStyles =
            case rec.label of
                Simple _ ->
                    [ Css.alignItems Css.center ]

                Custom styles _ ->
                    styles

        loadingStyles =
            if isLoading then
                [ Css.pointerEvents none
                , Css.after
                    [ Utils.loader
                    , Utils.centerEm 1 1
                    ]
                , Css.checked
                    [ Css.backgroundImage Css.none
                    ]
                ]

            else
                []
    in
    styled Html.label
        ([ Css.display Css.inlineFlex
         , Css.property "gap" "0.5em"
         , Css.cursor cursor
         , Css.marginLeft (Css.rem 0.5)
         , Css.firstChild [ Css.marginLeft Css.zero ]
         ]
            ++ labelStyles
        )
        []
        [ styled Html.input
            (inputStyle rec.modifiers
                ++ [ Css.property "-webkit-print-color-adjust" "exact"
                   , Css.property "color-adjust" "exact"
                   , Css.display Css.inlineBlock
                   , Css.backgroundOrigin Css.borderBox
                   , Css.property "-webkit-user-select" "none"
                   , Css.property "-moz-user-select" "none"
                   , Css.property "-ms-user-select" "none"
                   , Css.property "user-select" "none"
                   , Css.flexShrink Css.zero
                   , Css.height (Css.em 1)
                   , Css.width (Css.em 1)
                   , Css.cursor cursor
                   , Css.color (buttonColor rec.modifiers |> Colors.toCss)
                   , Colors.backgroundColor Colors.background
                   , radius
                   , Css.padding Css.zero
                   , Css.checked
                        [ Css.backgroundImage (Css.url ("\"" ++ bg ++ "\""))
                        , Css.borderColor Css.transparent
                        , Css.backgroundColor Css.currentColor
                        , Css.backgroundSize2 (Css.pct 100) (Css.pct 100)
                        , Css.backgroundPosition Css.center
                        , Css.backgroundRepeat Css.noRepeat
                        ]
                   , Css.disabled
                        [ Css.opacity (Css.num 0.7)
                        ]
                   ]
                ++ loadingStyles
            )
            ([ Attributes.type_ type_, Utils.onChange (always rec.msg) ]
                |> boolAttribute Attributes.checked rec.checked
                |> boolAttribute Attributes.required rec.required
                |> boolAttribute Attributes.disabled isDisabled
                |> boolAttribute Attributes.readonly rec.readonly
                |> noneEmptyAttribute Attributes.name rec.name
                |> noneEmptyAttribute Attributes.value rec.value
            )
            []
        , Html.map never (checkboxLabelToHtml rec.label)
        ]


checkboxLabelToHtml : CheckboxLabel -> Html Never
checkboxLabelToHtml label =
    case label of
        Simple str ->
            Html.text str

        Custom _ kids ->
            Html.div [] kids


buttonColor : List Modifier -> Colors.Hsla
buttonColor mods =
    List.foldl
        (\m carry ->
            case m of
                Primary ->
                    Colors.primary

                Danger ->
                    Colors.danger

                _ ->
                    carry
        )
        Colors.link
        mods



-- WITH STAR


{-| Add the name attribute to the input
-}
withName : String -> Input msg -> Input msg
withName name_ input =
    case input of
        Text rec ->
            Text { rec | name = name_ }

        Number rec ->
            Number { rec | name = name_ }

        Textarea rec ->
            Textarea { rec | name = name_ }

        Date rec ->
            Date { rec | name = name_ }

        Password rec ->
            Password { rec | name = name_ }

        Select rec ->
            Select { rec | name = name_ }

        Email rec ->
            Email { rec | name = name_ }

        Tel rec ->
            Tel { rec | name = name_ }

        Button type_ rec ->
            Button type_ { rec | name = name_ }


{-| Add value to checkbox and radio buttons

It's very unlikely that you will need this function since the value attribute is not normally needed for checkboxes and radios in Elm forms.

Note: All other inputs have other way to populate the value attribute and this function will be ignore by other inputs.

-}
withValue : String -> Input msg -> Input msg
withValue value_ input =
    case input of
        Button type_ rec ->
            Button type_ { rec | value = value_ }

        _ ->
            input


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

        Button _ _ ->
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

        Button _ _ ->
            input

        Select _ ->
            input


{-| Add required to the input
-}
withRequired : Input msg -> Input msg
withRequired input =
    case input of
        Text rec ->
            Text { rec | required = True }

        Number rec ->
            Number { rec | required = True }

        Textarea rec ->
            Textarea { rec | required = True }

        Date rec ->
            Date { rec | required = True }

        Password rec ->
            Password { rec | required = True }

        Select rec ->
            Select { rec | required = True }

        Email rec ->
            Email { rec | required = True }

        Tel rec ->
            Tel { rec | required = True }

        Button type_ rec ->
            Button type_ { rec | required = True }


{-| Add disabled to the input
-}
withDisabled : Input msg -> Input msg
withDisabled input =
    case input of
        Text rec ->
            Text { rec | disabled = True }

        Number rec ->
            Number { rec | disabled = True }

        Textarea rec ->
            Textarea { rec | disabled = True }

        Date rec ->
            Date { rec | disabled = True }

        Password rec ->
            Password { rec | disabled = True }

        Select rec ->
            Select { rec | disabled = True }

        Email rec ->
            Email { rec | disabled = True }

        Tel rec ->
            Tel { rec | disabled = True }

        Button type_ rec ->
            Button type_ { rec | disabled = True }


{-| Add readonly to the input
-}
withReadonly : Input msg -> Input msg
withReadonly input =
    case input of
        Text rec ->
            Text { rec | readonly = True }

        Number rec ->
            Number { rec | readonly = True }

        Textarea rec ->
            Textarea { rec | readonly = True }

        Date rec ->
            Date { rec | readonly = True }

        Password rec ->
            Password { rec | readonly = True }

        Select rec ->
            Select { rec | readonly = True }

        Email rec ->
            Email { rec | readonly = True }

        Tel rec ->
            Tel { rec | readonly = True }

        Button type_ rec ->
            Button type_ { rec | readonly = True }


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


{-| Add autocomplete = new-password to password input
-}
withNewPassword : Input msg -> Input msg
withNewPassword input =
    case input of
        Password rec ->
            Password { rec | autocomplete = New }

        _ ->
            input


{-| Add a `Modifier` to an input.

Please review the Modifier documentation for further information.

-}
withModifier : Modifier -> Input msg -> Input msg
withModifier mod input =
    let
        newRec rec =
            { rec | modifiers = mod :: rec.modifiers }
    in
    case input of
        Text rec ->
            Text (newRec rec)

        Number rec ->
            Number (newRec rec)

        Textarea rec ->
            Textarea (newRec rec)

        Date rec ->
            Date (newRec rec)

        Password rec ->
            Password (newRec rec)

        Select rec ->
            Select (newRec rec)

        Email rec ->
            Email (newRec rec)

        Tel rec ->
            Tel (newRec rec)

        Button type_ rec ->
            Button type_ (newRec rec)


{-| Add (not replace) multiple `Modifier` to an input.

Please review the Modifier documentation for further information.

-}
withModifiers : List Modifier -> Input msg -> Input msg
withModifiers mods input =
    let
        newRec rec =
            { rec | modifiers = mods ++ rec.modifiers }
    in
    case input of
        Text rec ->
            Text (newRec rec)

        Number rec ->
            Number (newRec rec)

        Textarea rec ->
            Textarea (newRec rec)

        Date rec ->
            Date (newRec rec)

        Password rec ->
            Password (newRec rec)

        Select rec ->
            Select (newRec rec)

        Email rec ->
            Email (newRec rec)

        Tel rec ->
            Tel (newRec rec)

        Button type_ rec ->
            Button type_ (newRec rec)


{-| A custom checkbox label gives you control over the label and the placement. Include multi line labels with bold styling or any other styling you'd like. The label cannot have any click behaviour since the label itself will check/uncheck the checkbox if clicked. The first argument is given to `Css.alignItems`, possible values are Css.center, Css.baseline, Css.flexStart etc.
-}
withCustomLabel : List Style -> List (Html Never) -> Input msg -> Input msg
withCustomLabel styles kids input =
    case input of
        Button type_ rec ->
            Button type_ { rec | label = Custom styles kids }

        _ ->
            input


triggerToAttribute : Trigger -> (String -> msg) -> Attribute msg
triggerToAttribute trigger =
    case trigger of
        OnInput ->
            Events.onInput

        OnChange ->
            Utils.onChange

        OnBlur ->
            onBlurWithTargetValue


onBlurWithTargetValue : (String -> msg) -> Html.Attribute msg
onBlurWithTargetValue tagger =
    Events.on "blur" (Decode.map tagger Events.targetValue)


maybeAttribute : (a -> Attribute msg) -> Maybe a -> List (Attribute msg) -> List (Attribute msg)
maybeAttribute attrFn maybeAttr attrs =
    case maybeAttr of
        Just val ->
            attrFn val :: attrs

        Nothing ->
            attrs


noneEmptyAttribute : (String -> Attribute msg) -> String -> List (Attribute msg) -> List (Attribute msg)
noneEmptyAttribute attrFn val attrs =
    if val /= "" then
        attrFn val :: attrs

    else
        attrs


boolAttribute : (Bool -> Attribute msg) -> Bool -> List (Attribute msg) -> List (Attribute msg)
boolAttribute attrFn val attrs =
    attrFn val :: attrs


initAttributes :
    { a
        | trigger : Trigger
        , msg : String -> msg
        , value : String
        , required : Bool
        , disabled : Bool
        , readonly : Bool
        , name : String
    }
    -> List (Attribute msg)
initAttributes { trigger, msg, value, required, disabled, readonly, name } =
    [ triggerToAttribute trigger msg
    , Attributes.value value
    ]
        |> boolAttribute Attributes.required required
        |> boolAttribute Attributes.disabled disabled
        |> boolAttribute Attributes.readonly readonly
        |> noneEmptyAttribute Attributes.name name



-- STYLE


{-| Use this if you need a custom input with our styling
-}
inputStyle : List Modifier -> List Style
inputStyle mods =
    let
        size =
            extractControlSize mods
    in
    [ controlStyle size
    , Colors.borderColor Colors.border
    , Colors.color Colors.darker
    , Css.maxWidth (pct 100)
    , Css.width (pct 100)
    , Css.property "box-shadow" "inset 0px 1px 2px rgba(0, 0, 0, 0.05)"
    , placeholder
        [ Colors.color Colors.base
        ]
    , hover
        [ Colors.borderColor (Colors.border |> Colors.hover)
        ]
    , focus
        [ Colors.borderColor Colors.link
        , Css.property "box-shadow" "inset 0px 1px 2px rgba(0, 0, 0, 0.05), 0 0 0 0.125em rgba(50,115,220, 0.25)"
        ]
    , active
        [ Colors.borderColor Colors.link
        , Css.property "box-shadow" "inset 0px 1px 2px rgba(0, 0, 0, 0.05), 0 0 0 0.125em rgba(50,115,220, 0.25)"
        ]
    ]
        ++ List.map inputModifierStyle mods


inputModifierStyle : Modifier -> Style
inputModifierStyle modifier =
    let
        style color prop =
            Css.batch
                [ Colors.borderColor color
                , focus [ prop, Colors.borderColor (color |> Colors.active) ]
                , active [ prop, Colors.borderColor (color |> Colors.active) ]
                , hover [ Colors.borderColor (color |> Colors.hover) ]
                ]
    in
    case modifier of
        Primary ->
            style Colors.primary (Css.property "box-shadow" "0 0 0 0.125em rgba(53, 157, 55, 0.25)")

        Danger ->
            style Colors.danger (Css.property "box-shadow" "0 0 0 0.125em rgba(255,56,96, 0.25)")

        Size _ ->
            Css.batch []

        Loading ->
            Css.batch []

        Static ->
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


selectStyle : List Modifier -> List Style
selectStyle mods =
    inputStyle mods
        ++ [ Css.fontSize (Css.px 16)
           , Css.cursor pointer
           , Css.outline none
           , Colors.backgroundColor Colors.white
           , Css.property "background-image" ("url(\"" ++ Icon.toDataUri Icon.angleDown ++ "\"), linear-gradient(to bottom, hsla(0, 0%, 96%, 1) 0%,hsla(0, 0%, 96%, 1) 100%)")
           , Css.property "background-repeat" "no-repeat, repeat"
           , Css.property "background-position" "right 0.75em top 50%, 0, 0"
           , Css.property "background-size" "0.75em auto, 100%"
           , Css.property "box-shadow" "none"
           , pseudoElement "ms-expand" [ Css.display none ]
           , Css.important (Css.property "padding-right" "calc(2.25em - 1px)")

           --border: 1px solid #aaa;
           -- box-shadow: 0 1px 0 1px rgba(0,0,0,.04);
           ]
