module Main exposing (main)

import Browser
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, hr, img, nav, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, height, href, src, width)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Button exposing (button)
import SE.Framework.Container exposing (container, isFluid)
import SE.Framework.Content exposing (content)
import SE.Framework.Form exposing (InputRecord, input)
import SE.Framework.Modifiers exposing (Modifier(..))
import SE.Framework.Navbar exposing (brand, led, link, navbar, noBrand)
import SE.Framework.Section exposing (section)


view : Model -> Html Msg
view model =
    div []
        [ navbar
            (brand "/"
                [ img [ src "/images/se-logo-white-bg.svg", width 123, height 38 ] []
                ]
            )
            [ link "/" "Home"
            , link "/about" "About"
            ]
        , led False
        , navbar noBrand
            [ link "/" "Home"
            , link "/about" "About"
            ]
        , section []
            [ container [ isFluid ]
                [ button [ Primary ] (Just DoSomething) "Primary"
                , button [ Link ] (Just DoSomething) "Link"
                , button [ Info ] (Just DoSomething) "Info"
                , button [ Success ] (Just DoSomething) "Success"
                , button [ Warning ] (Just DoSomething) "Warning"
                , button [ Danger ] (Just DoSomething) "Danger"
                ]
            ]
        , section []
            [ input
                { placeholder = "Hello world"
                , modifiers = []
                }
                InputMsg
            , text model.input
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view >> toUnstyled
        , update = update
        , init = initialModel
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoSomething ->
            model

        InputMsg s ->
            { model | input = s }


type Msg
    = DoSomething
    | InputMsg String


type alias Model =
    { input : String
    }


initialModel : Model
initialModel =
    { input = ""
    }
