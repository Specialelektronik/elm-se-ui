module SE.Framework.OuterClick exposing (withId, succeedIfClickIsOustideOfId)

{-|

@docs withId, succeedIfClickIsOustideOfId

More or less copied from <https://github.com/xarvh/elm-onclickoutside>

Explanation for relatedTarget: <https://stackoverflow.com/questions/42764494/blur-event-relatedtarget-returns-null>

How to use:

import Html exposing (..)
import Html.Attributes exposing (class)
import SE.Framework.OuterClick

type Msg
= UserClickedOutsideOfFruitDropdown

dropdownView =
let
onClickOutsideAttributes =
SE.Framework.OuterClick.withId "fruit-dropdown" UserClickedOutsideOfFruitDropdown

        otherAttributes =
            [ class "generic-dropdown" ]

        allAttributes =
            onClickOutsideAttributes ++ otherAttributes
    in
        div
            allAttributes
            [ text "apples"
            , text "oranges"
            , text "pears"
            ]

-}

import Html.Styled as Html
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Decode as Decode exposing (Decoder)


succeedIfBloodlineHasId : String -> Decoder ()
succeedIfBloodlineHasId targetId =
    Decode.field "id" Decode.string
        |> Decode.andThen
            (\id ->
                if id == targetId then
                    Decode.succeed ()

                else
                    Decode.field "parentNode" (succeedIfBloodlineHasId targetId)
            )


invertDecoder : Decoder a -> Decoder ()
invertDecoder decoder =
    Decode.maybe decoder
        |> Decode.andThen
            (\maybe ->
                if maybe == Nothing then
                    Decode.succeed ()

                else
                    Decode.fail ""
            )


{-| This is a Json.Decoder that you can use to decode a DOM
[FocusEvent](https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent).
It will _fail_ if `event.relatedTarget` or any of its ancestors have the
given DOM id.
It will succeed otherwise.
-}
succeedIfClickIsOustideOfId : String -> Decoder ()
succeedIfClickIsOustideOfId targetId =
    succeedIfBloodlineHasId targetId
        |> Decode.field "relatedTarget"
        |> invertDecoder


{-| The first argument is the DOM id that you want to assign to the element.
The second argument is the message that you want to trigger when the user
clicks outside the element.
The function returns a list of Html.Attributes to apply to the element.
The attributes are `tabindex`, `id` and the `focusout` event handler.
This function is meant to cover most use cases, but if you need more control
on the attributes, you will have to use
[succeedIfClickIsOustideOfId](#succeedIfClickIsOustideOfId) instead.
-}
withId : String -> msg -> List (Html.Attribute msg)
withId id onClickOutsideMsg =
    [ Attributes.tabindex 0
    , Attributes.id id
    , Events.on "focusout" <| Decode.map (always onClickOutsideMsg) (succeedIfClickIsOustideOfId id)
    ]
