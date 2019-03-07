module Main exposing (main)

import Browser
import Css
import Html.Styled exposing (Attribute, Html, div, hr, img, nav, p, span, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, height, href, src, width)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Breadcrumb as Breadcrumb exposing (breadcrumb, link)
import SE.Framework.Button exposing (button)
import SE.Framework.Columns exposing (column, columns)
import SE.Framework.Container exposing (container, isFluid)
import SE.Framework.Content exposing (content)
import SE.Framework.Form as Form exposing (InputRecord, checkbox, control, field, input, select, textarea)
import SE.Framework.Icon as Icon exposing (icon, largeIcon, mediumIcon, smallIcon)
import SE.Framework.Modifiers exposing (Modifier(..))
import SE.Framework.Navbar exposing (brand, led, link, navbar, noBrand)
import SE.Framework.Notification as Notification
import SE.Framework.Section exposing (section)
import SE.Framework.Table as Table exposing (body, cell, foot, head, headCell, row, table)
import SE.Framework.Tag as Tag exposing (deleteTag, tag, tags)
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
                [ table [ Table.Bordered, Table.Fullwidth, Table.Hoverable, Table.Striped, Table.Mobilefriendly, Table.Narrow ]
                    (head
                        [ headCell (text "Tabellrubrik 1")
                        , headCell (text "Tabellrubrik 2")
                        , headCell (text "Tabellrubrik 3")
                        , headCell (text "Tabellrubrik 4")
                        , headCell (text "Tabellrubrik 5")
                        , headCell (text "Tabellrubrik 6")
                        ]
                    )
                    (foot [])
                    (body
                        [ row
                            [ cell (text "Tabellcell 1")
                            , cell (text "Tabellcell 2")
                            , cell (text "Tabellcell 3")
                            , cell (text "Tabellcell 4")
                            , cell (text "Tabellcell 5")
                            , cell (text "Tabellcell 6")
                            ]
                        , row
                            [ cell (text "Tabellcell 1 rad 2")
                            , cell (text "Tabellcell 2 rad 2")
                            , cell (text "Tabellcell 3 rad 2")
                            , cell (text "Tabellcell 4 rad 2")
                            , cell (text "Tabellcell 5 rad 2")
                            , cell (text "Tabellcell 6 rad 2")
                            ]
                        , row
                            [ cell (text "Tabellcell 1 rad 3")
                            , cell (text "Tabellcell 2 rad 3")
                            , cell (text "Tabellcell 3 rad 3")
                            , cell (text "Tabellcell 4 rad 3")
                            , cell (text "Tabellcell 5 rad 3")
                            , cell (text "Tabellcell 6 rad 3")
                            ]
                        ]
                    )
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Ikoner"
                , p []
                    [ icon Icon.Home
                    , text "Regular"
                    ]
                , p []
                    [ smallIcon Icon.Home
                    , text "Small"
                    ]
                , p []
                    [ mediumIcon Icon.Home
                    , text "Medium"
                    ]
                , p []
                    [ largeIcon Icon.Home
                    , text "Large"
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Tags"
                , div []
                    (List.map (\( t, mods ) -> field [ tag mods t ])
                        [ ( "Tag label", [] )
                        , ( "Primary label", [ Tag.Primary ] )
                        , ( "Link label", [ Tag.Link ] )
                        , ( "Info label", [ Tag.Info ] )
                        , ( "Success label", [ Tag.Success ] )
                        , ( "Warning label", [ Tag.Warning ] )
                        , ( "Danger label", [ Tag.Danger ] )
                        , ( "Normal Link label", [ Tag.Normal, Tag.Link ] )
                        , ( "Medium Info label", [ Tag.Medium, Tag.Info ] )
                        , ( "Large Success label", [ Tag.Large, Tag.Success ] )
                        ]
                    )
                , Title.title5 "List of tags"
                , field
                    [ tags []
                        (List.map (\( t, mods ) -> tag mods t)
                            [ ( "Tag label", [] )
                            , ( "Primary label", [ Tag.Primary ] )
                            , ( "Link label", [ Tag.Link ] )
                            , ( "Info label", [ Tag.Info ] )
                            , ( "Success label", [ Tag.Success ] )
                            , ( "Warning label", [ Tag.Warning ] )
                            , ( "Danger label", [ Tag.Danger ] )
                            , ( "Normal Link label", [ Tag.Normal, Tag.Link ] )
                            , ( "Medium Info label", [ Tag.Medium, Tag.Info ] )
                            , ( "Large Success label", [ Tag.Large, Tag.Success ] )
                            ]
                        )
                    ]
                , field
                    [ content [] [ p [] [ text "Attach tags with Addons modifier" ] ]
                    , tags [ Tag.Addons ]
                        (List.map (\( t, mods ) -> tag mods t)
                            [ ( "Tag label", [ Tag.Black ] )
                            , ( "Tag label", [ Tag.Info ] )
                            ]
                        )
                    ]
                , field
                    [ content [] [ p [] [ text "Delete tag" ] ]
                    , tags [ Tag.Addons ]
                        [ tag [ Tag.Link ] "65\""
                        , deleteTag DoSomething
                        ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Breadcrumbs"
                , breadcrumb
                    [ Breadcrumb.link "/"
                        [ icon Icon.Home
                        , span [] [ text "Bulma" ]
                        ]
                    , Breadcrumb.link "/"
                        [ text "Documentation"
                        ]
                    , Breadcrumb.link "/"
                        [ text "Components"
                        ]
                    , Breadcrumb.activeLink "/"
                        [ text "Breadcrumb"
                        ]
                    ]
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
