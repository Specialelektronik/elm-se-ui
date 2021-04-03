module SE.UI.Dropdown exposing
    ( dropdown
    , button, customButton
    , Item, link, msgLink, content, hr
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

@docs button, customButton


# Content

@docs Item, link, msgLink, content, hr

-}

import Css exposing (Style)
import Html.Styled as Html exposing (Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import SE.UI.Buttons as Buttons
import SE.UI.Colors as Colors
import SE.UI.OuterClick exposing (withId)
import SE.UI.Utils


type alias Url =
    String


{-| Use `link`, `content` or `hr` to create a dropdown item
-}
type Item msg
    = Link Url (List (Html msg))
    | MsgLink msg (List (Html msg))
    | Content (List (Html msg))
    | Hr


type Button msg
    = Button (List Buttons.Modifier) (Maybe msg) (List (Html msg))
    | CustomButton (Html msg)


dropdownContentOffset : Css.Px
dropdownContentOffset =
    Css.px 4


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
    styled Html.div
        dropdownStyles
        (Attributes.classList [ ( "dropdown", True ) ] :: outerClickAttributes)
        [ buttonToHtml btn
        , styled Html.div
            (menuStyles isOpen)
            [ Attributes.classList [ ( "dropdown-menu", True ) ] ]
            [ styled Html.div
                contentStyles
                [ Attributes.classList [ ( "dropdown-content", True ) ] ]
                (List.map itemToHtml items)
            ]
        ]


{-| The dropdown button, toggles open/closed
see the button component for more documentation on the modifiers
-}
button : List Buttons.Modifier -> Maybe msg -> List (Html msg) -> Button msg
button =
    Button


{-| Like the `button` function but completely custom. The navbar uses this to create dropdowns with text links instead of a regular button.
-}
customButton : Html msg -> Button msg
customButton =
    CustomButton


{-| Renders a dropdown item
-}
link : Url -> List (Html msg) -> Item msg
link =
    Link


{-| Renders a dropdown item, but with a custom msg instead of a url
-}
msgLink : msg -> List (Html msg) -> Item msg
msgLink =
    MsgLink


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
            styled Html.a (itemStyles ++ linkStyles) [ Attributes.href url ] html

        MsgLink msg html ->
            styled Html.span (itemStyles ++ linkStyles) [ Events.onClick msg ] html

        Content html ->
            styled Html.div itemStyles [] html

        Hr ->
            styled Html.hr hrStyles [] []


buttonToHtml : Button msg -> Html msg
buttonToHtml btn =
    case btn of
        Button modifiers onPress html ->
            Buttons.button modifiers onPress html

        CustomButton html ->
            html



-- TODO
--rightDropdown


dropdownStyles : List Style
dropdownStyles =
    [ Css.display Css.inlineFlex
    , Css.position Css.relative
    , Css.verticalAlign Css.top
    , Css.focus
        [ Css.outline Css.none
        ]
    ]


menuStyles : Bool -> List Style
menuStyles isOpen =
    let
        displayStyle =
            if isOpen then
                Css.display Css.block

            else
                Css.display Css.none
    in
    [ displayStyle
    , Css.left Css.zero
    , Css.minWidth (Css.rem 12)
    , Css.paddingTop dropdownContentOffset
    , Css.position Css.absolute
    , Css.top (Css.pct 100)
    , Css.zIndex (Css.int 20)
    ]


contentStyles : List Style
contentStyles =
    [ Colors.backgroundColor Colors.white
    , Css.borderRadius SE.UI.Utils.radius
    , dropdownContentShadow
    , Css.paddingBottom (Css.rem 0.5)
    , Css.paddingTop (Css.rem 0.5)
    ]


itemStyles : List Style
itemStyles =
    [ Colors.color Colors.text
    , Css.display Css.block
    , Css.fontSize (Css.rem 0.875)
    , Css.lineHeight (Css.num 1.5)
    , Css.padding2 (Css.rem 0.375) (Css.rem 1)
    , Css.position Css.relative
    ]


linkStyles : List Style
linkStyles =
    [ Css.paddingRight (Css.rem 3)
    , Css.textAlign Css.left
    , Css.whiteSpace Css.noWrap
    , Css.width (Css.pct 100)
    , Css.cursor Css.pointer
    , Css.hover
        [ Colors.backgroundColor Colors.background
        , Colors.color Colors.black
        ]
    ]


hrStyles : List Style
hrStyles =
    [ Colors.backgroundColor Colors.border
    , Css.borderStyle Css.none
    , Css.display Css.block
    , Css.height (Css.px 1)
    , Css.margin2 (Css.rem 0.5) Css.zero
    ]
