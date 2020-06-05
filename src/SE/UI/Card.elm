module SE.UI.Card exposing (delete)

{-| Bulmas delete tag
see <https://bulma.io/documentation/components/card/>

The card component comprises several elements that you can mix and match:

card: the main container
card-header: a horizontal bar with a shadow
card-header-title: a left-aligned bold text
card-header-icon: a placeholder for an icon
card-image: a fullwidth container for a responsive image
card-content: a multi-purpose container for any other element
card-footer: a horizontal list of controls
card-footer-item: a repeatable list item


# Definition

@docs delete

-}

import Css exposing (Style)
import Css.Transitions
import Html.Styled exposing (Html, styled)
import Html.Styled.Events as Events
import SE.UI.Colors as Colors
import SE.UI.Utils as Utils


type alias Card msg =
    { header : Header msg
    , image : Maybe Image.Image
    , content : List (Html msg)
    , footer : List (FooterItem msg)
    }


type FooterItem msg
    = Link (Html.Attribute msg)
    | Custom List (Html msg)


type Header msg
    = NoHeader
    | Header String
    | WithIcon String (Control.Size -> Html msg)


toHtml : Html msg
