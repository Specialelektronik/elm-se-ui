module Main exposing (main)

import Browser
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, hr, img, nav, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, height, href, src, width)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Button exposing (button)
import SE.Framework.Columns exposing (column, columns)
import SE.Framework.Container exposing (container, isFluid)
import SE.Framework.Content exposing (content)
import SE.Framework.Form as Form exposing (InputRecord, checkbox, control, field, input, select, textarea)
import SE.Framework.Modifiers exposing (Modifier(..))
import SE.Framework.Navbar exposing (brand, led, link, navbar, noBrand)
import SE.Framework.Notification as Notification
import SE.Framework.Section exposing (section)
import SE.Framework.Table as Table exposing (body, foot, head, headCell, table)
import SE.Framework.Title as Title


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
            [ container [ isFluid ]
                ([ field
                    [ input
                        { placeholder = "Input"
                        , modifiers = []
                        }
                        InputMsg
                        model.input
                    ]
                 ]
                    ++ List.map
                        (\m ->
                            field
                                [ control False
                                    [ input
                                        { placeholder = "Input"
                                        , modifiers = m :: []
                                        }
                                        InputMsg
                                        model.input
                                    ]
                                ]
                        )
                        [ Form.Primary, Form.Info, Form.Success, Form.Warning, Form.Danger ]
                    ++ [ text model.input ]
                )
            ]
        , section []
            [ container [ isFluid ]
                ([ field
                    [ control True
                        [ textarea
                            { placeholder = "Input"
                            , modifiers = []
                            , rows = 3
                            }
                            InputMsg
                            model.input
                        ]
                    ]
                 ]
                    ++ List.map
                        (\m ->
                            field
                                [ control False
                                    [ textarea
                                        { placeholder = "Input"
                                        , modifiers = m :: []
                                        , rows = 3
                                        }
                                        InputMsg
                                        model.input
                                    ]
                                ]
                        )
                        [ Form.Primary, Form.Info, Form.Success, Form.Warning, Form.Danger ]
                    ++ [ text model.input ]
                )
            ]
        , section []
            [ container [ isFluid ]
                [ select
                    { placeholder = "Select dropdown"
                    , modifiers = [ Form.Warning ]
                    , options =
                        [ { value = "Value 1"
                          , label = "Label 1"
                          }
                        ]
                    }
                    InputMsg
                    "Value 2"
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ checkbox "Checkbox" model.checked CheckBox
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ message Notification.primary model.message
                , message Notification.link model.message
                , message Notification.info model.message
                , message Notification.success model.message
                , message Notification.warning model.message
                , message Notification.danger model.message
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Det här är en titel samma som title3"
                , Title.title1 "Det här är en titel1"
                , Title.title2 "Det här är en titel2"
                , Title.title3 "Det här är en titel3"
                , Title.title4 "Det här är en titel4"
                , Title.title5 "Det här är en titel5"
                , Title.title6 "Det här är en titel6"
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ table
                    (head
                        [ headCell (text "Tabellrubrik")
                        ]
                    )
                    (foot [])
                    (body [])
                ]
            ]
        ]


message : (Maybe Msg -> List (Html Msg) -> Html Msg) -> String -> Html Msg
message f m =
    if String.isEmpty m then
        text ""

    else
        f (Just ClearMessage) [ text m ]


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

        CheckBox ->
            { model | checked = not model.checked }

        ClearMessage ->
            { model | message = "" }


type Msg
    = DoSomething
    | InputMsg String
    | CheckBox
    | ClearMessage


type alias Model =
    { input : String
    , checked : Bool
    , message : String
    }


initialModel : Model
initialModel =
    { input = ""
    , checked = False
    , message = "Här är ett meddelande"
    }
