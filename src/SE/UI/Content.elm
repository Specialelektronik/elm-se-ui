module SE.UI.Content exposing (content)

{-| Bulmas content element
see <https://bulma.io/documentation/elements/content/>


# Definition

@docs content

-}

import Css exposing (auto, center, circle, decimal, disc, em, inlineBlock, italic, left, outside, pct, pseudoClass, px, solid, square, top, zero)
import Css.Global exposing (blockquote, dd, descendants, dl, each, h1, h2, h3, h4, h5, h6, img, ol, p, pre, selector, table, td, tfoot, th, thead, typeSelector, ul)
import Html.Styled exposing (Html, styled)
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Utils exposing (block)


{-| Styles most HTML tags

  - <p> paragraphs
  - <ul> <ol> <dl> lists
  - <h1> to <h6> headings
  - <blockquote> quotes
  - <em> and <strong>
  - <table> <tr> <th> <td> tables

Works like a normal Html.Styled.div:

    content []
        [ h1 [] [ text "Heading 1" ]
        , p [] [ text "Content body text" ]
        ]

-}
content : List (Html.Styled.Attribute msg) -> List (Html msg) -> Html msg
content =
    styled Html.Styled.div
        [ block
        , descendants
            -- Inline
            [ typeSelector "li + li"
                [ Css.marginTop (em 0.25)
                ]

            --   // Block
            , each [ p, dl, ol, ul, blockquote, pre, table ]
                [ pseudoClass "not(:last-child)"
                    [ Css.marginBottom (em 1)
                    ]
                ]
            , each [ h1, h2, h3, h4, h5, h6 ]
                [ Css.fontWeight (Css.int 600)
                , Css.lineHeight (Css.num 1.3)
                ]
            , h1
                [ Font.emSize 6
                , Css.marginBottom (em 0.5)
                , pseudoClass "not(:first-child)"
                    [ Css.marginBottom (em 1)
                    ]
                ]
            , h2
                [ Font.emSize 5
                , Css.marginBottom (em 0.5714)
                , pseudoClass "not(:first-child)"
                    [ Css.marginBottom (em 1.1428)
                    ]
                ]
            , h3
                [ Font.emSize 4
                , Css.marginBottom (em 0.6666)
                , pseudoClass "not(:first-child)"
                    [ Css.marginBottom (em 1.3333)
                    ]
                ]
            , h4
                [ Font.emSize 3
                , Css.marginBottom (em 0.8)
                ]
            , h5
                [ Font.emSize 2
                , Css.marginBottom (em 0.8888)
                ]
            , h6
                [ Font.emSize 1
                , Css.marginBottom (em 1)
                ]
            , blockquote
                [ Css.backgroundColor (Colors.lightest |> Colors.toCss)
                , Css.borderLeft3 (px 5) solid (Colors.border |> Colors.toCss)
                , Css.padding2 (em 1.25) (em 1.5)
                ]
            , ol
                [ Css.listStylePosition outside
                , Css.marginLeft (em 2)
                , Css.marginTop (em 1)
                , pseudoClass "not([type])"
                    [ Css.listStyleType decimal
                    ]
                ]
            , ul
                [ Css.listStyle2 disc outside
                , Css.marginLeft (em 2)
                , Css.marginTop (em 1)
                , descendants
                    [ ul
                        [ Css.listStyleType circle
                        , Css.marginTop (em 0.5)
                        , descendants
                            [ ul
                                [ Css.listStyleType square
                                ]
                            ]
                        ]
                    ]
                ]
            , dd
                [ Css.marginLeft (em 2)
                ]
            , typeSelector "figure"
                [ Css.marginLeft (em 2)
                , Css.marginRight (em 2)
                , Css.textAlign center
                , pseudoClass "not(:first-child)"
                    [ Css.marginTop (em 2)
                    ]
                , pseudoClass "not(:last-child)"
                    [ Css.marginBottom (em 2)
                    ]
                , descendants
                    [ img
                        [ Css.display inlineBlock
                        ]
                    , typeSelector "figcaption"
                        [ Css.fontStyle italic
                        ]
                    ]
                ]
            , pre
                [ -- TODO +overflow-touch
                  Css.overflowX auto
                , Css.padding2 (em 1.25) (em 1.5)
                , Css.whiteSpace Css.pre
                , Css.property "word-wrap" "normal"
                ]
            , typeSelector "sup, sub"
                [ Css.fontSize (pct 75)
                ]
            , table
                [ Css.width (pct 100)
                , descendants
                    [ each [ td, th ]
                        [ Css.border3 (px 1) solid (Colors.border |> Colors.toCss)
                        , Css.borderWidth3 zero zero (px 1)
                        , Css.padding2 (em 0.5) (em 0.75)
                        , Css.verticalAlign top
                        ]
                    , th
                        [ Css.color (Colors.black |> Colors.toCss)
                        , Css.textAlign left
                        ]
                    , thead
                        [ descendants
                            [ each [ th, td ]
                                [ Css.borderWidth3 zero zero (px 2)
                                , Css.color (Colors.black |> Colors.toCss)
                                ]
                            ]
                        ]
                    , tfoot
                        [ descendants
                            [ each [ th, td ]
                                [ Css.borderWidth3 (px 2) zero zero
                                , Css.color (Colors.black |> Colors.toCss)
                                ]
                            ]
                        ]
                    , selector "tbody tr:last-child td, tbody tr:last-child th"
                        [ Css.borderBottomWidth zero
                        ]
                    ]
                ]
            ]
        ]
