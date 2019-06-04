module SE.UI.Dropdown exposing
    ( dropdown
    , button
    , link, content, hr
    )

{-| Bulmas Dropdown component
see <https://bulma.io/documentation/components/dropdown/>

The Elm Arcitecture makes it a little difficult to listen to clicks on the entire document. Instead we use the OuterClick utility library to know if the user has clicked outside of the dropdown.


# Unsupported features

  - Hoverable
  - Right aligned
  - Drop up


# Definition

@docs dropdown


# Button

@docs button


# Content

@docs link, content, hr

-}

import Css exposing (Style, absolute, active, auto, block, bold, borderBox, calc, center, deg, em, flexStart, focus, hover, important, initial, inlineBlock, inlineFlex, int, left, middle, minus, noRepeat, noWrap, none, num, pct, pointer, pseudoClass, pseudoElement, px, relative, rem, rgba, rotate, scale, solid, sub, top, transparent, url, vertical, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, typeSelector, withAttribute)
import Css.Transitions
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (class, placeholder)
import Html.Styled.Events exposing (onInput)
import SE.UI.Buttons as Buttons exposing (button)
import SE.UI.Colors as Colors exposing (black, danger, darker, info, light, lighter, link, primary, success, warning, white)
import SE.UI.Control exposing (controlStyle)
import SE.UI.OuterClick exposing (withId)
import SE.UI.Utils as Utils exposing (loader, radius)


type alias Url =
    String


type Item msg
    = Link Url (List (Html msg))
    | Content (List (Html msg))
    | Hr


type Button msg
    = Button (List Buttons.Modifier) (Maybe msg) (List (Html msg))


dropdownContentOffset : Css.Px
dropdownContentOffset =
    px 4


dropdownContentShadow : Style
dropdownContentShadow =
    Css.property "box-shadow" "0 2px 3px rgba(34, 41, 47, 0.1), 0 0 0 1px rgba(34, 41, 47, 0.1)"


{-| Render the dropdown
Parameters

1.  String id for the dropdown, should be unique in order to support multiple dropdowns on the same page
2.  Close message
3.  Bool isOpen
4.  A button created via the `button` function
5.  A list of Items created via `link`, `content` or `hr`

-}
dropdown : String -> msg -> Bool -> Button msg -> List (Item msg) -> Html msg
dropdown id closeMsg isOpen btn items =
    let
        outerClickAttributes =
            withId id closeMsg
    in
    styled Html.Styled.div
        dropdownStyles
        outerClickAttributes
        [ Html.Styled.div []
            [ buttonToHtml btn
            ]
        , styled Html.Styled.div
            (menuStyles isOpen)
            []
            [ styled Html.Styled.div
                contentStyles
                []
                (List.map itemToHtml items)
            ]
        ]


{-| The dropdown button, toggles open/closed
see the button component for more documentation on the modifiers
-}
button : List Buttons.Modifier -> Maybe msg -> List (Html msg) -> Button msg
button =
    Button


{-| Renders a dropdown item
-}
link : Url -> List (Html msg) -> Item msg
link =
    Link


{-| Renders a dropdown content tag
-}
content : List (Html msg) -> Item msg
content =
    Content


{-| Renders a dropdown divider
-}
hr : Item msg
hr =
    Hr


itemToHtml : Item msg -> Html msg
itemToHtml item =
    case item of
        Link url html ->
            styled Html.Styled.a (itemStyles ++ linkStyles) [ Html.Styled.Attributes.href url ] html

        Content html ->
            styled Html.Styled.div itemStyles [] html

        Hr ->
            styled Html.Styled.hr hrStyles [] []


buttonToHtml : Button msg -> Html msg
buttonToHtml (Button modifiers onPress html) =
    Buttons.button modifiers onPress html



-- TODO
--rightDropdown


dropdownStyles : List Style
dropdownStyles =
    [ Css.display inlineFlex
    , Css.position relative
    , Css.verticalAlign top
    , focus
        [ Css.outline none
        ]
    ]


menuStyles : Bool -> List Style
menuStyles isOpen =
    let
        displayStyle =
            if isOpen then
                Css.display block

            else
                Css.display none
    in
    [ displayStyle
    , Css.left zero
    , Css.minWidth (rem 12)
    , Css.paddingTop dropdownContentOffset
    , Css.position absolute
    , Css.top (pct 100)
    , Css.zIndex (int 20)
    ]


contentStyles : List Style
contentStyles =
    [ Css.backgroundColor Colors.white
    , Css.borderRadius radius
    , dropdownContentShadow
    , Css.paddingBottom (rem 0.5)
    , Css.paddingTop (rem 0.5)
    ]


itemStyles : List Style
itemStyles =
    [ Css.color Colors.darker
    , Css.display block
    , Css.fontSize (rem 0.875)
    , Css.lineHeight (num 1.5)
    , Css.padding2 (rem 0.375) (rem 1)
    , Css.position relative
    ]


linkStyles : List Style
linkStyles =
    [ Css.paddingRight (rem 3)
    , Css.textAlign left
    , Css.whiteSpace noWrap
    , Css.width (pct 100)
    , hover
        [ Css.backgroundColor Colors.background
        , Css.color Colors.black
        ]
    ]


hrStyles : List Style
hrStyles =
    [ Css.backgroundColor Colors.border
    , Css.borderStyle none
    , Css.display block
    , Css.height (px 1)
    , Css.margin2 (rem 0.5) zero
    ]
