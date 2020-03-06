module Page.Home exposing (Model, Msg, init, view, update)

import Css
import Html.Styled as Html exposing (Html, text, div, toUnstyled)
import Browser
type alias Model = ()

type Msg = NoOp

init : (Model, Cmd Msg)
init = ((), Cmd.none)

view : Model -> {title : String, body : List (Html Msg)}
view model =
    { title = "Home"
    , body =
        [ div [] [ text "Home page!"]
        ]
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    ((), Cmd.none)