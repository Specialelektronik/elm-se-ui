module Main exposing (main)

import Browser
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, hr, img, nav, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, height, href, src, width)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Button exposing (button)
import SE.Framework.Container exposing (container, isFluid)
import SE.Framework.Content exposing (content)
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
            [ content
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
    model


type Msg
    = DoSomething


type alias Model =
    ()


initialModel : Model
initialModel =
    ()
