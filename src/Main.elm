module Main exposing (main)

import Browser
import Css
import Html.Styled exposing (Attribute, Html, div, hr, img, nav, p, span, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, height, href, src, width)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Breadcrumb as Breadcrumb exposing (breadcrumb, link)
import SE.Framework.Buttons as Buttons exposing (button, buttons)
import SE.Framework.Columns exposing (column, columns)
import SE.Framework.Container exposing (container, isFluid)
import SE.Framework.Content exposing (content)
import SE.Framework.Form as Form exposing (InputRecord, checkbox, control, field, input, radio, select, textarea)
import SE.Framework.Icon as Icon exposing (icon, largeIcon, mediumIcon, smallIcon)
import SE.Framework.Image as Image exposing (image, source)
import SE.Framework.Modal exposing (modal)
import SE.Framework.Navbar exposing (brand, led, link, navbar, noBrand)
import SE.Framework.Notification as Notification
import SE.Framework.Section exposing (section)
import SE.Framework.Table as Table exposing (body, cell, foot, head, headCell, row, table)
import SE.Framework.Tabs as Tabs exposing (tabs)
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
                (List.map
                    (\( mods, label ) ->
                        field [ button mods (Just DoSomething) [ text label ] ]
                    )
                    [ ( [], "Button" )
                    , ( [ Buttons.Primary ], "Primary" )
                    , ( [ Buttons.Link ], "Link" )
                    , ( [ Buttons.Info ], "Info" )
                    , ( [ Buttons.Success ], "Success" )
                    , ( [ Buttons.Warning ], "Warning" )
                    , ( [ Buttons.Danger ], "Danger" )
                    , ( [ Buttons.White ], "White" )
                    , ( [ Buttons.Lightest ], "Lightest" )
                    , ( [ Buttons.Lighter ], "Lighter" )
                    , ( [ Buttons.Light ], "Light" )
                    , ( [ Buttons.Dark ], "Dark" )
                    , ( [ Buttons.Darker ], "Darker" )
                    , ( [ Buttons.Darkest ], "Darkest" )
                    , ( [ Buttons.Black ], "Black" )
                    , ( [ Buttons.Text ], "Text" )
                    , ( [ Buttons.Small ], "Small button" )
                    , ( [ Buttons.Medium ], "Medium button" )
                    , ( [ Buttons.Large ], "Large button" )
                    ]
                )
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Buttons"
                , buttons []
                    [ button [ Buttons.Success ]
                        Nothing
                        [ icon Icon.Save
                        , span [] [ text "Save changes" ]
                        ]
                    , button [ Buttons.Info ] (Just DoSomething) [ text "Save and continue" ]
                    , button [ Buttons.Danger ] (Just DoSomething) [ text "Cancel" ]
                    ]
                , field
                    [ text "Add attached modifier to remove margin between buttons"
                    ]
                , field
                    [ buttons [ Buttons.Attached ]
                        [ button [ Buttons.Lighter ] (Just DoSomething) [ text "Save changes" ]
                        , button [ Buttons.Lighter ] (Just DoSomething) [ text "Save and continue" ]
                        , button [ Buttons.Lighter ] (Just DoSomething) [ text "Cancel" ]
                        ]
                    ]
                , field
                    [ button [ Buttons.Fullwidth, Buttons.Primary ] (Just DoSomething) [ text "Fullwidth button" ]
                    ]
                , field
                    [ button [ Buttons.Static ] (Just DoSomething) [ text "Static button" ]
                    ]
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
                , radio "Radio" model.checked CheckBox
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
        , section []
            [ container [ isFluid ]
                [ Title.title "Tabs"
                , tabs [ Tabs.Medium ]
                    [ Tabs.link "/"
                        [ mediumIcon Icon.Home
                        , span [] [ text "Bulma" ]
                        ]
                    , Tabs.link "/"
                        [ text "Documentation"
                        ]
                    , Tabs.link "/"
                        [ text "Components"
                        ]
                    , Tabs.activeLink "/"
                        [ text "Tabs"
                        ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Modal"
                , button [ Buttons.Large, Buttons.Primary ]
                    (Just ToggleModal)
                    [ text "Show Modal"
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title "Image"
                , image ( 640, 480 )
                    [ source "https://bulma.io/images/placeholders/640x480.png" 1
                    , source "https://bulma.io/images/placeholders/640x320.png" 2
                    ]
                ]
            ]
        , modalView model.showModal
        ]


modalView : Bool -> Html Msg
modalView isActive =
    if isActive == True then
        modal ToggleModal [ text "Modal" ]

    else
        text ""


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

        ToggleModal ->
            { model | showModal = not model.showModal }


type Msg
    = DoSomething
    | InputMsg String
    | CheckBox
    | ClearMessage
    | ToggleModal


type alias Model =
    { input : String
    , checked : Bool
    , message : String
    , showModal : Bool
    }


initialModel : Model
initialModel =
    { input = ""
    , checked = False
    , message = "Här är ett meddelande"
    , showModal = False
    }
