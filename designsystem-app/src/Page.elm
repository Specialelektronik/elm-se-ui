module Page exposing (notFound, view)

import Browser
import Css exposing (Style)
import Html.Styled as Html exposing (Html, div, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (class, css)
import Navbar
import SE.UI.Global exposing (global)
import SE.UI.Section as Section



-- VIEW


view : (a -> msg) -> { title : String, body : List (Html a) } -> { title : String, body : List (Html msg) }
view toMsg doc =
    { title =
        doc.title
    , body = [ viewFrame (List.map (Html.map toMsg) doc.body) ]
    }


viewFrame : List (Html msg) -> Html msg
viewFrame content =
    styled div
        [ Css.paddingTop (Css.px 69) ]
        [ class "wrapper" ]
        [ global
        , Navbar.view
        , Section.section []
            [ div [] [ text "sidebar" ]
            , div [] content
            ]
        ]


notFound : { title : String, body : List (Html msg) }
notFound =
    { title = "Not Found"
    , body = [ text "Page not found." ]
    }
