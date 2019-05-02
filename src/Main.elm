module Main exposing (main)

import Browser
import Css
import Html.Styled exposing (Attribute, Html, a, div, hr, img, nav, p, span, strong, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, height, href, src, width)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Breadcrumb as Breadcrumb exposing (breadcrumb, link)
import SE.Framework.Buttons as Buttons exposing (button, buttons)
import SE.Framework.Colors as Colors
import SE.Framework.Columns as Columns exposing (column, columns, defaultColumn, multilineColumns, smallColumns, smallMultilineColumns, wideColumns, wideMultilineColumns)
import SE.Framework.Container exposing (container, isFluid)
import SE.Framework.Content exposing (content)
import SE.Framework.Dropdown as Dropdown exposing (dropdown)
import SE.Framework.Form as Form exposing (InputRecord, checkbox, control, expandedControl, field, input, radio, select, textarea)
import SE.Framework.Icon as Icon exposing (icon, largeIcon, mediumIcon, smallIcon)
import SE.Framework.Image as Image exposing (image, source)
import SE.Framework.Level as Level exposing (centeredLevel, item, level, mobileLevel)
import SE.Framework.Modal exposing (modal)
import SE.Framework.Navbar exposing (brand, led, link, navbar, noBrand)
import SE.Framework.Notification as Notification
import SE.Framework.OuterClick as OuterClick
import SE.Framework.Pagination as Pagination exposing (centeredPagination, pagination, rightPagination)
import SE.Framework.Section exposing (section)
import SE.Framework.Table as Table exposing (body, cell, foot, head, headCell, row, table)
import SE.Framework.Tabs as Tabs exposing (tabs)
import SE.Framework.Tag as Tag exposing (deleteTag, tag, tags)
import SE.Framework.Title as Title


view : Model -> Html Msg
view model =
    let
        paginationRecord =
            { lastPage = 7
            , currentPage = model.page
            , nextPageLabel = "Next page"
            , previousPageLabel = "Previous"
            , msg = ChangePage
            }
    in
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
                        field [] [ button mods (Just DoSomething) [ text label ] ]
                    )
                    [ ( [], "Button" )
                    , ( [ Buttons.Primary ], "Primary" )
                    , ( [ Buttons.Link ], "Link" )
                    , ( [ Buttons.Info ], "Info" )
                    , ( [ Buttons.Success ], "Success" )
                    , ( [ Buttons.Warning ], "Warning" )
                    , ( [ Buttons.CallToAction ], "Call to action" )
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
                [ Title.title3 "Buttons"
                , buttons []
                    [ button [ Buttons.Success ]
                        Nothing
                        [ icon Icon.Save
                        , span [] [ text "Save changes" ]
                        ]
                    , button [ Buttons.Info ] (Just DoSomething) [ text "Save and continue" ]
                    , button [ Buttons.Danger ] (Just DoSomething) [ text "Cancel" ]
                    ]
                , field []
                    [ text "Add attached modifier to remove margin between buttons"
                    ]
                , field []
                    [ buttons [ Buttons.Attached ]
                        [ button [ Buttons.Lighter ] (Just DoSomething) [ text "Save changes" ]
                        , button [ Buttons.Lighter ] (Just DoSomething) [ text "Save and continue" ]
                        , button [ Buttons.Lighter ] (Just DoSomething) [ text "Cancel" ]
                        ]
                    ]
                , field []
                    [ button [ Buttons.Fullwidth, Buttons.Primary ] (Just DoSomething) [ text "Fullwidth button" ]
                    ]
                , field []
                    [ button [ Buttons.Static ] (Just DoSomething) [ text "Static button" ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                ([ Title.title3 "Form"
                 , field []
                    [ Form.label "Input"
                    , control False
                        [ input
                            { placeholder = "Input"
                            , modifiers = []
                            }
                            InputMsg
                            model.input
                        ]
                    ]
                 ]
                    ++ List.map
                        (\m ->
                            field []
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
                [ Title.title3 "Field modifiers"
                , Title.title5 "Attached"
                , field [ Form.Attached ]
                    [ control False
                        [ input
                            { placeholder = "Find a repository"
                            , modifiers = []
                            }
                            InputMsg
                            model.input
                        ]
                    , control False
                        [ button [ Buttons.Info ] (Just DoSomething) [ text "Search" ]
                        ]
                    ]
                , Title.title5 " Control expanded"
                , field [ Form.Attached ]
                    [ expandedControl False
                        [ input
                            { placeholder = "Find a repository"
                            , modifiers = []
                            }
                            InputMsg
                            model.input
                        ]
                    , control False
                        [ button [ Buttons.Info ] (Just DoSomething) [ text "Search" ]
                        ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                ([ field []
                    [ Form.label "Loading input or textarea"
                    , control True
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
                            field []
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
                [ Title.title1 "Det här är en titel1"
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
                [ Title.title3 "Ikoner"
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
                [ Title.title3 "Tags"
                , div []
                    (List.map (\( t, mods ) -> field [] [ tag mods t ])
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
                , field []
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
                , field []
                    [ content [] [ p [] [ text "Attach tags with Addons modifier" ] ]
                    , tags [ Tag.Addons ]
                        (List.map (\( t, mods ) -> tag mods t)
                            [ ( "Tag label", [ Tag.Black ] )
                            , ( "Tag label", [ Tag.Info ] )
                            ]
                        )
                    ]
                , field []
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
                [ Title.title3 "Breadcrumbs"
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
                [ Title.title3 "Tabs"
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
                [ Title.title3 "Modal"
                , button [ Buttons.Large, Buttons.Primary ]
                    (Just ToggleModal)
                    [ text "Show Modal"
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title3 "Image"
                , image ( 640, 480 )
                    [ source "https://bulma.io/images/placeholders/640x480.png" 1
                    , source "https://bulma.io/images/placeholders/640x320.png" 2
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title3 "Level"
                , level
                    [ item
                        [ p []
                            [ strong [] [ text "123" ]
                            , text " posts"
                            ]
                        ]
                    , item
                        [ field [ Form.Grouped ]
                            [ control False [ input { placeholder = "Find a post", modifiers = [] } InputMsg model.input ]
                            , control False [ button [] (Just DoSomething) [ text "Search" ] ]
                            ]
                        ]
                    ]
                    [ item
                        [ strong [] [ text "All" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Published" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Drafts" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Deleted" ]
                        ]
                    , item
                        [ button [ Buttons.Primary ] (Just DoSomething) [ text "New" ]
                        ]
                    ]
                , Title.title3 "Mobile level"
                , mobileLevel
                    [ item
                        [ p []
                            [ strong [] [ text "123" ]
                            , text " posts"
                            ]
                        ]
                    , item
                        [ field [ Form.Grouped ]
                            [ control False [ input { placeholder = "Find a post", modifiers = [] } InputMsg model.input ]
                            , control False [ button [] (Just DoSomething) [ text "Search" ] ]
                            ]
                        ]
                    ]
                    [ item
                        [ strong [] [ text "All" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Published" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Drafts" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Deleted" ]
                        ]
                    , item
                        [ button [ Buttons.Primary ] (Just DoSomething) [ text "New" ]
                        ]
                    ]
                , Title.title3 "Centered level"
                , centeredLevel
                    [ item
                        [ strong [] [ text "All" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Published" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Drafts" ]
                        ]
                    , item
                        [ a [ href "/" ] [ text "Deleted" ]
                        ]
                    , item
                        [ button [ Buttons.Primary ] (Just DoSomething) [ text "New" ]
                        ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title3 "Dropdown"
                , dropdown "dd1"
                    CloseDropdown
                    model.isDropdownOpen
                    (Dropdown.button
                        [ Buttons.Primary ]
                        (Just ToggleDropdown)
                        [ span [] [ text "Dropdown button " ]
                        , smallIcon Icon.AngleDown
                        ]
                    )
                    [ Dropdown.link "/hello" [ text "Hello" ]
                    , Dropdown.hr
                    , Dropdown.content [ p [] [ text "This is content in a paragraph." ] ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title3 "Empty section" ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title3 "Columns"
                , content []
                    [ p []
                        [ text "Anytime a column contains the Mobile Size, the columns get the flex: display style"
                        ]
                    ]
                , Title.title5 "Mobile columns"
                , columns
                    [ column [ ( Columns.Mobile, Columns.OneQuarter ) ]
                        [ text "Mobile column one quarter"
                        ]
                    , defaultColumn
                        [ text "Column 2 - default size"
                        ]
                    , defaultColumn
                        [ text "Column 3 - default size"
                        ]
                    ]
                , Title.title5 "Multiline columns"
                , Columns.multilineColumns
                    [ column [ ( Columns.All, Columns.Full ) ]
                        [ text "Full width column"
                        ]
                    , defaultColumn
                        [ text "Column 2 - default size"
                        ]
                    , defaultColumn
                        [ text "Column 3 - default size"
                        ]
                    ]
                ]
            ]
        , section []
            [ container [ isFluid ]
                [ Title.title3 ("Pagination (current page: " ++ String.fromInt model.page ++ ")")
                , content []
                    [ p []
                        [ text "Pagination"
                        ]
                    ]
                , Title.title5 "Regular"
                , pagination paginationRecord
                , Title.title5 "Centered"
                , centeredPagination paginationRecord
                , Title.title5 "Right"
                , rightPagination paginationRecord
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

        ToggleDropdown ->
            { model | isDropdownOpen = not model.isDropdownOpen }

        CloseDropdown ->
            { model | isDropdownOpen = False }

        ChangePage page ->
            { model | page = page }


type Msg
    = DoSomething
    | InputMsg String
    | CheckBox
    | ClearMessage
    | ToggleModal
    | ToggleDropdown
    | CloseDropdown
    | ChangePage Int


type alias Model =
    { input : String
    , checked : Bool
    , message : String
    , showModal : Bool
    , isDropdownOpen : Bool
    , page : Int
    }


initialModel : Model
initialModel =
    { input = ""
    , checked = False
    , message = "Här är ett meddelande"
    , showModal = False
    , isDropdownOpen = False
    , page = 2
    }
