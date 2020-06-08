module SE.UI.Card exposing (content, withTitle, withSubTitle, withBoxShadow, toHtml)

{-| Bulmas card component
see <https://bulma.io/documentation/components/card/>

The card component originates from Bulmas equivalent without the footer and image header. We also have a sub title available.

Like the [Input](SE.UI.Form.Input) components, Card uses the withStar-pattern.

    Card.content
        [ Content.content []
            [ Html.p []
                [ Html.text "This is where the content goes. It can be any content you like."
                ]
            ]
        ]
        |> Card.withTitle "This is a title"
        |> Card.withSubTitle "This is a subtitle"
        |> Card.withBoxShadow
        |> Card.toHtml


# Definition

@docs content, withTitle, withSubTitle, withBoxShadow, toHtml

-}

import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Html, styled)
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Title as Title
import SE.UI.Utils as Utils


{-| Use `content` to create a card.
-}
type Card msg
    = Card (Internals msg)


type alias Internals msg =
    { title : String
    , subTitle : String
    , content : List (Html msg)
    , boxShadow : Bool
    }


{-| Turn the Card into Html

Use it in the end of a pipeline, see the example at the top.

-}
toHtml : Card msg -> Html msg
toHtml (Card internals) =
    styled Html.div
        (cardStyles internals.boxShadow)
        []
        [ titleToHtml internals
        , styled Html.div contentStyles [] internals.content
        ]


titleToHtml : Internals msg -> Html msg
titleToHtml { title, subTitle } =
    if String.isEmpty title then
        Html.text ""

    else
        styled Html.div
            headerStyles
            []
            [ Title.title5 title
            , subTitleToHtml subTitle
            ]


subTitleToHtml : String -> Html msg
subTitleToHtml subTitle =
    if String.isEmpty subTitle then
        Html.text ""

    else
        styled Html.p
            [ Css.margin Css.zero
            , Font.bodySizeEm -2
            , Utils.desktop
                [ Css.marginLeft (Css.rem 0.88888888)
                ]
            ]
            []
            [ Html.text subTitle ]


{-| Create a Card with the provided Html.
-}
content : List (Html msg) -> Card msg
content kids =
    Card
        { title = ""
        , subTitle = ""
        , content = kids
        , boxShadow = False
        }


{-| Add a title to the card
-}
withTitle : String -> Card msg -> Card msg
withTitle title (Card internals) =
    Card { internals | title = title }


{-| Add a subtitle to the card, note that a title also needs to be present in order for the card to display the subtitle.
-}
withSubTitle : String -> Card msg -> Card msg
withSubTitle subTitle (Card internals) =
    Card { internals | subTitle = subTitle }


{-| Add box-shadow to the card
-}
withBoxShadow : Card msg -> Card msg
withBoxShadow (Card internals) =
    Card { internals | boxShadow = True }



-- STYLES


cardStyles : Bool -> List Style
cardStyles hasBoxShadow =
    [ Colors.backgroundColor Colors.white

    --   box-shadow: $card-shadow
    , Css.maxWidth (Css.pct 100)
    , Css.position Css.relative
    , Css.borderRadius Utils.radius
    , Css.borderWidth (Css.px 1)
    , Css.borderStyle Css.solid
    , Colors.borderColor Colors.border
    , if hasBoxShadow then
        Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Colors.black |> Colors.mapAlpha (always 0.15) |> Colors.toCss)

      else
        Css.batch []
    ]


contentStyles : List Style
contentStyles =
    [ Css.padding (Css.rem 0.88888888) ]


headerStyles : List Style
headerStyles =
    [ Css.displayFlex
    , Css.flexDirection Css.column
    , Colors.backgroundColor Colors.lightBlue
    , Css.alignItems Css.baseline
    , Css.borderBottomWidth (Css.px 1)
    , Css.borderBottomStyle Css.solid
    , Colors.borderColor Colors.border
    , Css.padding (Css.rem 0.88888888)
    , Utils.desktop
        [ Css.flexDirection Css.row
        ]
    , Css.Global.children
        [ Css.Global.typeSelector "h5"
            [ Css.important (Css.margin Css.zero)
            ]
        ]
    ]


titleStyles : List Style
titleStyles =
    [ Css.alignItems Css.center
    , Css.displayFlex
    , Css.flexGrow (Css.int 1)
    , Css.padding2 (Css.rem 0.88888888) (Css.rem 0.55555555)
    ]
