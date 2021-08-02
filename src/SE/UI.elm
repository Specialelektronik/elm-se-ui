module SE.UI exposing (main)

import Browser
import Css exposing (Style)
import Css.Global
import Html.Styled as Html exposing (Html, div, styled, toUnstyled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import SE.UI.Alignment as Alignment exposing (Alignment)
import SE.UI.Buttons as Buttons
import SE.UI.Card as Card
import SE.UI.Colors as Colors exposing (Color)
import SE.UI.Columns as Columns
import SE.UI.Container as Container
import SE.UI.Content as Content
import SE.UI.Control as Control
import SE.UI.Dropdown as Dropdown
import SE.UI.Font as Font
import SE.UI.Form as Form
import SE.UI.Form.Input as Input
import SE.UI.Global as Global
import SE.UI.Icon.V2 as Icon exposing (Icon)
import SE.UI.Image.V2 as Image
import SE.UI.Level as Level
import SE.UI.Logo as Logo
import SE.UI.Logos.Crestron as Crestron
import SE.UI.Logos.Panasonic as Panasonic
import SE.UI.Modal as Modal
import SE.UI.Navbar as Navbar
import SE.UI.Notification as Notification
import SE.UI.Pagination.V2 as Pagination exposing (Pagination)
import SE.UI.Section as Section
import SE.UI.Snackbar as Snackbar
import SE.UI.Table.V2 as Table
import SE.UI.Tabs.V2 as Tabs exposing (Tabs)
import SE.UI.Title as Title
import SE.UI.Utils as Utils



-- MODEL


type alias Model =
    { count : Int
    , button : ButtonModel
    , notification : NotificationModel
    , columns : ColumnsModel
    , input : String
    , showModal : Bool
    , showDropdown : Bool
    , navbar : Navbar.Model
    , navbarBrand : Navbar.Brand
    , table : TableModel
    , tabs : TabsModel
    , isOpen : Bool
    , showMenuDropdown : Bool
    , crestron : CrestronModel
    , panasonic : PanasonicModel
    , snackbar : Snackbar.Model
    , snackbarSettings : SnackbarSettings
    , pagination : PaginationModel
    , icons : IconsModel
    }


type alias ButtonModel =
    { mods : List Buttons.Modifier
    }


type alias NotificationModel =
    { color : NotificationColor
    , deleteable : Bool
    }


type NotificationColor
    = Regular
    | Primary
    | Link
    | Danger
    | Custom Colors.Color


type alias ColumnsModel =
    { count : Int
    }


type alias TableModel =
    { mods : List Table.Modifier
    }


type alias TabsModel =
    { size : Control.Size
    , style : TabsStyle
    , alignment : Alignment
    , isFullwidth : Bool
    }


type TabsSize
    = Normal
    | Small
    | Medium
    | Large


type TabsStyle
    = Unstyled
    | Boxed
    | Toggled


type TabsAlignment
    = Left
    | Centered
    | Right


type alias CrestronModel =
    { color : CrestronColor
    , variant : CrestronVariant
    }


type CrestronColor
    = Blue
    | Black
    | White


type CrestronVariant
    = Standard
    | Stack
    | Swirl


type alias PanasonicModel =
    { color : PanasonicColor
    , isMonochrome : Panasonic.IsMonochrome
    }


type PanasonicColor
    = OnWhite
    | OnBlack


type alias PaginationModel =
    { size : Control.Size
    , alignment : Alignment
    , currentPage : Int
    , lastPage : Int
    }


type alias IconsModel =
    { activeId : Maybe Int
    , size : Control.Size
    , containerSize : Control.Size
    , transform : Maybe Icon.Transform
    }


type alias SnackbarSettings =
    { duration : Int
    , iconWithColor : Maybe ( Int, Color )
    }


colorToNotification : NotificationColor -> ( String, Maybe msg -> List (Html msg) -> Html msg )
colorToNotification color =
    case color of
        Regular ->
            ( "notification", Notification.notification )

        Primary ->
            ( "primary", Notification.primary )

        Link ->
            ( "link", Notification.link )

        Danger ->
            ( "danger", Notification.danger )

        Custom color_ ->
            ( "custom SE.UI.Colors." ++ Debug.toString color_, Notification.custom color_ )


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { count = 1
      , button = defaultButton
      , notification = defaultNotification
      , columns = defaultColumns
      , input = ""
      , showModal = False
      , showDropdown = False
      , navbar = Navbar.defaultModel
      , navbarBrand = Navbar.DefaultBrand "/"
      , table = defaultTableModel
      , tabs = defaultTabsModel
      , isOpen = False
      , showMenuDropdown = False
      , crestron = defaultCrestronLogo
      , panasonic = defaultPanasonicLogo
      , snackbar = Snackbar.init
      , snackbarSettings = { duration = 3500, iconWithColor = Nothing }
      , pagination = defaultPaginationModel
      , icons = defaultIconsModel
      }
    , Cmd.none
    )


defaultButton : ButtonModel
defaultButton =
    { mods = []
    }


defaultNotification : NotificationModel
defaultNotification =
    { color = Regular
    , deleteable = True
    }


defaultColumns : ColumnsModel
defaultColumns =
    { count = 4
    }


defaultTableModel : TableModel
defaultTableModel =
    { mods = []
    }


defaultTabsModel : TabsModel
defaultTabsModel =
    { size = Control.Regular
    , style = Unstyled
    , alignment = Alignment.Left
    , isFullwidth = False
    }


defaultCrestronLogo : CrestronModel
defaultCrestronLogo =
    { color = Blue
    , variant = Standard
    }


defaultPanasonicLogo : PanasonicModel
defaultPanasonicLogo =
    { color = OnWhite
    , isMonochrome = False
    }


defaultPaginationModel : PaginationModel
defaultPaginationModel =
    { size = Control.Regular
    , alignment = Alignment.Left
    , currentPage = 5
    , lastPage = 8
    }


defaultIconsModel : IconsModel
defaultIconsModel =
    { activeId = Maybe.Nothing
    , size = Control.Regular
    , containerSize = Control.Regular
    , transform = Nothing
    }



-- UPDATE


type Msg
    = NoOp
    | ClickedButton
    | GotInput String
    | GotButtonsMsg ButtonMsg
    | GotNotificationMsg NotificationMsg
    | GotColumnsMsg ColumnsMsg
    | GotNavbarMsg Navbar.Msg
    | GotSnackbarMsg Snackbar.Msg
    | AddSnackbar
    | GotSnackbarDuration String
    | GotSnackbarIcon Int
    | ClickedSnackbarColor Colors.Color
    | ToggleNavbarBrand
    | GotTableMsg TableMsg
    | GotTabsMsg TabsMsg
    | GotCrestronMsg CrestronMsg
    | GotPanasonicMsg PanasonicMsg
    | GotPaginationMsg PaginationMsg
    | ToggledMenu
    | ToggledModal
    | ToggledDropdown
    | ClosedDropdown
    | GotIconsMsg IconsMsg


type ButtonMsg
    = ToggledModifier Buttons.Modifier


type NotificationMsg
    = ClickedColor NotificationColor
    | ClickedCustomColor Colors.Color
    | ToggledDeleteable


type ColumnsMsg
    = AddColumn
    | SubtractColumn


type TableMsg
    = ToggledTableModifier Table.Modifier


type TabsMsg
    = ToggledTabsSize Control.Size
    | ToggledTabsStyle TabsStyle
    | ToggledTabsAlignment Alignment
    | ToggledTabsFullwidth


type CrestronMsg
    = ToggledColor CrestronColor
    | ToggledVariant CrestronVariant


type PanasonicMsg
    = ToggledPanasonicColor PanasonicColor
    | ToggledMonochrome


type PaginationMsg
    = ToggledPaginationSize Control.Size
    | ToggledPaginationAlignment Alignment
    | ChangedPage Int


type IconsMsg
    = ToggledSize Control.Size
    | ToggledContainerSize Control.Size
    | SelectedTransform Icon.Transform
    | SelectedIndex Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ClickedButton ->
            ( model, Cmd.none )

        GotInput str ->
            ( { model | input = str }, Cmd.none )

        GotButtonsMsg subMsg ->
            ( { model | button = updateButton subMsg model.button }, Cmd.none )

        GotNotificationMsg subMsg ->
            ( { model | notification = updateNotification subMsg model.notification }, Cmd.none )

        GotColumnsMsg subMsg ->
            ( { model | columns = updateColumns subMsg model.columns }, Cmd.none )

        GotSnackbarMsg subMsg ->
            let
                ( newSnackbar, cmds ) =
                    Snackbar.update snackbarConfig subMsg model.snackbar
            in
            ( { model | snackbar = newSnackbar }, cmds )

        AddSnackbar ->
            let
                ( newSnackbar, cmds ) =
                    Snackbar.add snackbarConfig
                        model.snackbar
                        (Snackbar.create
                            { label = "Ett produkt har lagts i varukorgen"
                            , message =
                                Html.span []
                                    [ styled Html.span [ Colors.color Colors.primary ] [] [ Html.text "CP3" ]
                                    , styled Html.span [ Colors.color Colors.base ] [] [ Html.text " - Kontrollprocessor 3-serie, LAN, 1HE/19tum" ]
                                    ]
                            }
                            |> Snackbar.withDuration model.snackbarSettings.duration
                            |> (\snckbr ->
                                    case model.snackbarSettings.iconWithColor of
                                        Just ( iconIndex, color ) ->
                                            case find iconIndex allIcons of
                                                Just ( label, icon ) ->
                                                    Snackbar.withIcon icon color snckbr

                                                Nothing ->
                                                    snckbr

                                        Nothing ->
                                            snckbr
                               )
                        )
            in
            ( { model | snackbar = newSnackbar }, cmds )

        GotSnackbarDuration stringDuration ->
            case String.toInt stringDuration of
                Nothing ->
                    ( model, Cmd.none )

                Just duration ->
                    let
                        oldSettings =
                            model.snackbarSettings

                        newSettings =
                            { oldSettings | duration = duration }
                    in
                    ( { model | snackbarSettings = newSettings }, Cmd.none )

        GotSnackbarIcon index ->
            let
                oldSettings =
                    model.snackbarSettings

                newValue =
                    case oldSettings.iconWithColor of
                        Just ( oldIndex, color ) ->
                            if oldIndex == index then
                                Nothing

                            else
                                Just ( index, color )

                        Nothing ->
                            Just ( index, Colors.Buy )

                newSettings =
                    { oldSettings | iconWithColor = newValue }
            in
            ( { model | snackbarSettings = newSettings }, Cmd.none )

        ClickedSnackbarColor color ->
            let
                oldSettings =
                    model.snackbarSettings

                newValue =
                    case oldSettings.iconWithColor of
                        Just ( oldIndex, oldColor ) ->
                            Just ( oldIndex, color )

                        Nothing ->
                            Nothing

                newSettings =
                    { oldSettings | iconWithColor = newValue }
            in
            ( { model | snackbarSettings = newSettings }, Cmd.none )

        GotNavbarMsg subMsg ->
            ( { model | navbar = Navbar.update subMsg model.navbar }, Cmd.none )

        ToggleNavbarBrand ->
            ( { model
                | navbarBrand =
                    case model.navbarBrand of
                        Navbar.DefaultBrand _ ->
                            Navbar.CustomBrand
                                { onWhite = "https://www.facebook.com/images/fb_icon_325x325.png"
                                , onBlack = "https://www.facebook.com/images/fb_icon_325x325.png"
                                }
                                "/"

                        _ ->
                            Navbar.DefaultBrand "/"
              }
            , Cmd.none
            )

        GotTableMsg subMsg ->
            ( { model | table = updateTable subMsg model.table }, Cmd.none )

        GotTabsMsg subMsg ->
            ( { model | tabs = updateTabs subMsg model.tabs }, Cmd.none )

        GotCrestronMsg subMsg ->
            ( { model | crestron = updateCrestron subMsg model.crestron }, Cmd.none )

        GotPanasonicMsg subMsg ->
            ( { model | panasonic = updatePanasonic subMsg model.panasonic }, Cmd.none )

        GotPaginationMsg subMsg ->
            ( { model | pagination = updatePagination subMsg model.pagination }, Cmd.none )

        ToggledModal ->
            ( { model | showModal = not model.showModal }, Cmd.none )

        ToggledDropdown ->
            ( { model | showDropdown = not model.showDropdown }, Cmd.none )

        ToggledMenu ->
            ( { model | isOpen = not model.isOpen }, Cmd.none )

        ClosedDropdown ->
            ( { model | showDropdown = False }, Cmd.none )

        GotIconsMsg subMsg ->
            ( { model | icons = updateIcons subMsg model.icons }, Cmd.none )


updateButton : ButtonMsg -> ButtonModel -> ButtonModel
updateButton msg model =
    case msg of
        ToggledModifier mod ->
            let
                newMods =
                    if List.member mod model.mods then
                        List.filter (\a -> a /= mod) model.mods

                    else
                        mod :: model.mods
            in
            { model | mods = newMods }


updateNotification : NotificationMsg -> NotificationModel -> NotificationModel
updateNotification msg model =
    case msg of
        ClickedColor color ->
            { model | color = color }

        ClickedCustomColor color ->
            { model | color = Custom color }

        ToggledDeleteable ->
            { model | deleteable = not model.deleteable }


updateColumns : ColumnsMsg -> ColumnsModel -> ColumnsModel
updateColumns msg model =
    case msg of
        AddColumn ->
            { model | count = min 12 (model.count + 1) }

        SubtractColumn ->
            { model | count = max 1 (model.count - 1) }


updateTable : TableMsg -> TableModel -> TableModel
updateTable msg model =
    case msg of
        ToggledTableModifier mod ->
            let
                newMods =
                    if List.member mod model.mods then
                        List.filter (\a -> a /= mod) model.mods

                    else
                        mod :: model.mods
            in
            { model | mods = newMods }


updateTabs : TabsMsg -> TabsModel -> TabsModel
updateTabs msg model =
    case msg of
        ToggledTabsSize size ->
            { model | size = size }

        ToggledTabsStyle style ->
            { model | style = style }

        ToggledTabsAlignment alignment ->
            { model | alignment = alignment }

        ToggledTabsFullwidth ->
            { model | isFullwidth = not model.isFullwidth }


updateCrestron : CrestronMsg -> CrestronModel -> CrestronModel
updateCrestron msg model =
    case msg of
        ToggledColor color ->
            { model | color = color }

        ToggledVariant variant ->
            { model | variant = variant }


updatePanasonic : PanasonicMsg -> PanasonicModel -> PanasonicModel
updatePanasonic msg model =
    case msg of
        ToggledPanasonicColor color ->
            { model | color = color }

        ToggledMonochrome ->
            { model | isMonochrome = not model.isMonochrome }


updatePagination : PaginationMsg -> PaginationModel -> PaginationModel
updatePagination msg model =
    case msg of
        ToggledPaginationSize size ->
            { model | size = size }

        ToggledPaginationAlignment alignment ->
            { model | alignment = alignment }

        ChangedPage page ->
            { model | currentPage = page }


updateIcons : IconsMsg -> IconsModel -> IconsModel
updateIcons msg model =
    case msg of
        ToggledSize size ->
            { model | size = size }

        ToggledContainerSize size ->
            { model | containerSize = size }

        SelectedTransform transform ->
            { model | transform = Just transform }

        SelectedIndex key ->
            let
                newKey =
                    case model.activeId of
                        Nothing ->
                            Just key

                        Just oldKey ->
                            if oldKey == key then
                                Nothing

                            else
                                Just key
            in
            { model | activeId = newKey }



-- VIEW
--


navbarConfig : Navbar.Brand -> Navbar.Config Msg
navbarConfig brand =
    { brand = brand
    , transform = GotNavbarMsg
    , ribbon =
        [ { href = Attributes.href "/"
          , label = "Tjänster"
          , icon = Nothing
          }
        , { href = Attributes.href "/"
          , label = "Om oss"
          , icon = Nothing
          }
        , { href = Attributes.href "/"
          , label = "Branscher"
          , icon = Nothing
          }
        , { href = Attributes.href "/"
          , label = "Kontakt"
          , icon = Nothing
          }
        , { href = Attributes.href "/"
          , label = "Event"
          , icon = Nothing
          }
        ]
    , mainNav =
        [ Navbar.LinkItem
            { href = Attributes.href "/"
            , label = "Webbshop"
            , icon = Nothing
            }
        , Navbar.DropdownItem
            { label = "Tjänster"
            , items = [ Dropdown.link "https://google.com" [ Html.text "Google.com" ] ]
            }
        , Navbar.DropdownItem
            { label = "Om oss"
            , items = [ Dropdown.link "https://google.com" [ Html.text "Google.com" ] ]
            }
        , Navbar.CustomItem
            [ viewLoginIcon ]
        , Navbar.CustomItem
            [ viewCartIcon ]
        , Navbar.CustomItem
            [ viewContactAndOpeningHours ]
        ]
    , megaNav =
        [ { label = "AV-Teknik"
          , href = Attributes.href "/av-teknik"
          , content = Html.div [] [ Html.text "Här kommer alla underkategorier" ]
          }
        , { label = "Belysning"
          , href = Attributes.href "/av-teknik"
          , content =
                Html.div []
                    [ Html.ul []
                        [ Html.li [] [ Html.text "Länk 1" ]
                        , Html.li [] [ Html.text "Länk 2" ]
                        , Html.li [] [ Html.text "Länk 3" ]
                        , Html.li [] [ Html.text "Länk 4" ]
                        , Html.li [] [ Html.text "Länk 5" ]
                        , Html.li [] [ Html.text "Länk 6" ]
                        , Html.li [] [ Html.text "Länk 2" ]
                        , Html.li [] [ Html.text "Länk 3" ]
                        , Html.li [] [ Html.text "Länk 4" ]
                        , Html.li [] [ Html.text "Länk 5" ]
                        , Html.li [] [ Html.text "Länk 6" ]
                        , Html.li [] [ Html.text "Länk 2" ]
                        , Html.li [] [ Html.text "Länk 3" ]
                        , Html.li [] [ Html.text "Länk 4" ]
                        , Html.li [] [ Html.text "Länk 5" ]
                        , Html.li [] [ Html.text "Länk 6" ]
                        , Html.li [] [ Html.text "Länk 2" ]
                        , Html.li [] [ Html.text "Länk 3" ]
                        , Html.li [] [ Html.text "Länk 4" ]
                        , Html.li [] [ Html.text "Länk 5" ]
                        , Html.li [] [ Html.text "Länk 6" ]
                        , Html.li [] [ Html.text "Länk 2" ]
                        , Html.li [] [ Html.text "Länk 3" ]
                        , Html.li [] [ Html.text "Länk 4" ]
                        , Html.li [] [ Html.text "Länk 5" ]
                        , Html.li [] [ Html.text "Länk 6" ]
                        ]
                    ]
          }
        , { label = "IP / IT"
          , href = Attributes.href "/av-teknik"
          , content = Html.div [] [ Html.text "Här kommer alla underkategorier" ]
          }
        , { label = "Säkerhet"
          , href = Attributes.href "/av-teknik"
          , content = Html.div [] [ Html.text "Här kommer alla underkategorier" ]
          }
        , { label = "CATV"
          , href = Attributes.href "/av-teknik"
          , content = Html.div [] [ Html.text "Här kommer alla underkategorier" ]
          }
        , { label = "Fiberoptik"
          , href = Attributes.href "/av-teknik"
          , content = Html.div [] [ Html.text "Här kommer alla underkategorier" ]
          }
        ]
    , socialMedia =
        [ { url = "https://facebook.com/specialelektronik"
          , icon = Icon.facebook
          }
        , { url = "https://instagram.com/specialelektronik"
          , icon = Icon.instagram
          }
        , { url = "https://www.linkedin.com/company/specialelektronik-ab"
          , icon = Icon.linkedin
          }
        , { url = "https://www.youtube.com/channel/UC-dTyW9181xms8TpxXHF7oQ"
          , icon = Icon.youtube
          }
        ]
    }


snackbarConfig : Snackbar.Config Msg
snackbarConfig =
    { transform = GotSnackbarMsg
    }


view : Model -> Html Msg
view model =
    div
        []
        [ Global.global
        , Navbar.view (navbarConfig model.navbarBrand) search model.navbar
        , Html.article
            []
            [ viewNavbar model.navbarBrand
            , viewImage
            , viewSnackbarInfo model.snackbarSettings
            , viewLogo
            , viewCrestronLogo model.crestron
            , viewPanasonicLogo model.panasonic
            , viewColors
            , viewTypography
            , viewColumns model.columns
            , viewButtons model.button
            , viewSection
            , viewContainer
            , viewLevel model
            , viewForm model
            , viewNotification model.notification
            , viewModal model.showModal
            , viewIcons model.icons
            , viewCard
            , viewTable model.table
            , viewTabs model.tabs
            , viewPagination model.pagination
            ]
        , Snackbar.view snackbarConfig model.snackbar
        ]


viewLoginIcon : Html Msg
viewLoginIcon =
    styled Html.a
        [ Colors.color Colors.text
        , Css.displayFlex
        , Css.padding (Css.rem 1)
        , Css.width (Css.pct 100)
        , Utils.desktop
            [ Css.flexDirection Css.column
            , Css.alignItems Css.center
            , Css.padding Css.zero
            ]
        , Css.hover
            [ Colors.color Colors.primary
            ]
        ]
        [ Attributes.href "/login" ]
        [ Icon.user |> Icon.withSize Control.Medium |> Icon.toHtml
        , styled Html.span
            [ Css.fontWeight (Css.int 600)
            , Utils.desktop
                [ Colors.color Colors.base
                , Font.bodySizeRem -3
                , Css.fontWeight Css.normal
                ]
            ]
            []
            [ Html.text "Logga in"
            ]
        ]


viewCartIcon : Html Msg
viewCartIcon =
    styled Html.a
        [ Colors.color Colors.text
        , Css.position Css.relative
        , Css.displayFlex
        , Css.padding (Css.rem 1)
        , Css.width (Css.pct 100)
        , Utils.desktop
            [ Css.flexDirection Css.column
            , Css.alignItems Css.center
            , Css.padding Css.zero
            ]
        , Css.hover
            [ Colors.color Colors.primary
            ]
        , Css.Global.withAttribute "data-badge"
            [ Css.after
                [ Colors.backgroundColor Colors.primary
                , Colors.color Colors.white
                , Css.borderRadius (Css.pct 50)
                , Css.position Css.absolute
                , Css.top Css.zero
                , Css.right Css.zero
                , Css.bottom Css.auto
                , Css.left Css.auto
                , Css.minWidth (Css.em 2)
                , Css.minHeight (Css.em 2)
                , Css.textAlign Css.center
                , Css.lineHeight (Css.num 1)
                , Css.padding2 (Css.em 0.5) (Css.em 0.5)
                , Font.bodySizeEm -4
                , Css.property "content" "attr(data-badge)"
                , Css.boxShadow5 Css.zero Css.zero Css.zero (Css.px 2) (Colors.white |> Colors.toCss)
                , Css.transform (Css.translate2 (Css.pct -25) (Css.pct 25))
                ]
            ]
        ]
        [ Attributes.href "/cart", Attributes.attribute "data-badge" "33" ]
        [ Icon.cart |> Icon.withSize Control.Medium |> Icon.toHtml
        , styled Html.span
            [ Css.fontWeight (Css.int 600)
            , Utils.desktop
                [ Colors.color Colors.base
                , Font.bodySizeRem -3
                , Css.fontWeight Css.normal
                ]
            ]
            []
            [ Html.text "Varukorg"
            ]
        ]


viewContactAndOpeningHours : Html Msg
viewContactAndOpeningHours =
    styled Html.div
        [ Css.displayFlex
        , Font.bodySizeRem -3
        , Css.alignItems Css.center
        , Css.borderStyle Css.solid
        , Css.borderWidth (Css.px 1)
        , Colors.borderColor Colors.border
        , Css.padding (Css.em 0.75)
        , Css.borderRadius Utils.radius
        ]
        []
        [ Icon.phone |> Icon.toHtml
        , styled Html.p
            [ Css.paddingLeft (Css.em 0.75)
            ]
            []
            [ Html.strong [] [ Html.text "Prata med säljare?" ]
            , Html.br [] []
            , Html.a [ Attributes.href "tel:+46544442030" ] [ Html.text "054 - 444 2030" ]
            ]
        , styled Html.p
            [ Css.paddingLeft (Css.em 0.75)
            , Css.marginLeft (Css.em 0.75)
            , Css.borderStyle Css.solid
            , Colors.borderColor Colors.border
            , Css.borderWidth Css.zero
            , Css.borderLeftWidth (Css.px 1)
            ]
            []
            [ Html.strong [] [ Html.text "Öppet idag:" ]
            , Html.br [] []
            , styled Html.span [ Colors.color Colors.base ] [] [ Html.text "08:00-17:00" ]
            ]
        ]



-- item : List (Html msg) -> Html msg
-- item =
--     styled div (itemAndLinkStyles ++ itemStyles) []
-- link : String -> String -> Html msg
-- link label url =
--     styled Html.a (itemAndLinkStyles ++ linkStyles) [ Attributes.href url ] [ Html.text label ]


search : Html Msg
search =
    styled Html.form
        [ Css.display Css.block, Css.flexGrow (Css.num 1) ]
        []
        [ Form.field [ Form.Attached ]
            [ Form.expandedControl False
                [ searchInput searchStyles [ Attributes.placeholder "Sök efter produkter, kategorier och fabrikat" ]
                , styled Html.button
                    [ Css.border Css.zero
                    , Css.backgroundColor Css.transparent
                    , Css.position Css.absolute
                    , Css.displayFlex
                    , Css.top Css.zero
                    , Css.bottom Css.zero
                    , Css.right Css.zero
                    , Css.cursor Css.pointer
                    , Colors.color Colors.dark
                    , Css.alignItems Css.center
                    , Css.hover
                        [ Colors.color Colors.link
                        ]
                    ]
                    [ Attributes.type_ "submit" ]
                    [ Utils.visuallyHidden Html.span [] [ Html.text "Sök" ], Icon.search |> Icon.withSize Control.Medium |> Icon.toHtml ]
                ]

            -- , Form.control False
            --     [ Html.button [] [ Html.text "Sök" ]
            --     ]
            ]
        ]


searchStyles : List Style
searchStyles =
    [ Css.batch (Input.inputStyle [])
    , Css.property "padding" "calc(0.75em - 1px) calc(1em - 1px)"

    -- , Colors.backgroundColor Colors.lighter
    -- , Colors.color Colors.darker
    -- , Css.width (Css.pct 100)
    -- , Css.hover
    --     [ Colors.borderColor Colors.base
    --     ]
    -- , Css.focus
    --     [ Colors.borderColor Colors.link
    --     , Css.property "box-shadow" "0 0 0 0.125em rgba(50,115,220, 0.25)"
    --     , Colors.backgroundColor Colors.white
    --     , Colors.color Colors.black
    --     ]
    -- , Css.active
    --     [ Colors.borderColor Colors.link
    --     , Css.property "box-shadow" "0 0 0 0.125em rgba(50,115,220, 0.25)"
    --     ]
    -- , Css.height (Css.pct 100)
    ]


searchInput : List Style -> List (Html.Attribute Msg) -> Html Msg
searchInput styles attrs =
    Html.styled Html.input
        styles
        attrs
        []


viewNavbar : Navbar.Brand -> Html Msg
viewNavbar brand =
    Section.section []
        [ Container.container []
            [ Title.title1 "Navbar"
            , Content.content []
                [ Html.p []
                    [ Html.text "The Navbar is a pretty complicated component with its own state. The module's documentation explains how to use it."
                    ]
                ]
            , Form.field []
                [ Buttons.button [ Buttons.Color Colors.DarkGreen ] (Just ToggleNavbarBrand) [ Html.text "Toggle brand" ]
                ]
            , Html.code [] [ Html.text (Debug.toString brand) ]
            ]
        ]



-- IMAGE


viewImage : Html Msg
viewImage =
    Section.section
        [ Attributes.css
            [ Css.Global.descendants
                [ Css.Global.selector "figure"
                    [ Css.property "background-color" "lightyellow"
                    ]
                ]
            ]
        ]
        [ Container.container []
            [ Title.title1 "Image"
            , Content.content []
                [ Html.p []
                    [ Html.text "The image component has some similarities to the bulma component but has evolved beyond it. There are 3 options:"
                    ]
                , Html.ul []
                    [ Html.li [] [ Html.text "the full ", Html.code [] [ Html.text "picture" ], Html.text " tag with multiple formats" ]
                    , Html.li [] [ Html.text "a single ", Html.code [] [ Html.text "img" ], Html.text " tag" ]
                    , Html.li [] [ Html.text "or a \"missing image\" icon to indicate that there is no image" ]
                    ]
                , Html.p [] [ Html.text "The width and height must always be specified and you can force the image into an aspect ratio with ", Html.code [] [ Html.text "withAspectRatio" ], Html.text " function." ]
                , Html.p [] [ Html.text "The settings comes first to make it possible for you to prepare lots of images with the same settings and then apply the alt text and src at the end." ]
                , Html.p [] [ Html.text "The image will always maintain its original ratio since we use object-fit: contain." ]
                ]
            , Notification.link Nothing [ Html.strong [] [ Html.text "Note: " ], Html.text "The yellow tinted background is only for demostration purposes, to highlight the <figure> area." ]
            , Columns.multilineColumns
                [ Columns.column [ ( Columns.Desktop, Columns.Half ) ]
                    [ styled Html.p
                        [ Utils.block ]
                        []
                        [ Image.create { width = 300, height = 100 }
                            |> Image.withAspectRatio ( 16, 9 )
                            |> Image.toHtml "Testbild"
                                [ Image.source
                                    [ Image.srcset "https://picsum.photos/300/100" 1
                                    ]
                                ]
                        ]
                    , styled Html.p
                        [ Utils.block ]
                        []
                        [ Html.text "The "
                        , Html.code [] [ Html.text "<figure>" ]
                        , Html.text " tag will always keep a 16 / 9 aspect ratio and grow with the container. The "
                        , Html.code [] [ Html.text "picture" ]
                        , Html.text " tag will contain all sizes specified as the last argument of \"toHtml\"."
                        ]
                    , Html.pre []
                        [ Html.code []
                            [ Html.text """Image.create { width = 300, height = 100 }
    |> Image.withAspectRatio ( 16, 9 )
    |> Image.toHtml "Testbild"
        [ Image.source
            [ Image.srcset "https://picsum.photos/300/100" 1
            ]
        ]"""
                            ]
                        ]
                    ]
                , Columns.column [ ( Columns.Desktop, Columns.Half ) ]
                    [ styled Html.p
                        [ Utils.block ]
                        []
                        [ Image.create { width = 300, height = 300 }
                            |> Image.withAspectRatio ( 16, 9 )
                            |> Image.toSimpleHtml { alt = "Testbild", src = "https://picsum.photos/300/300" }
                        ]
                    , styled Html.p
                        [ Utils.block ]
                        []
                        [ Html.text "The "
                        , Html.code [] [ Html.text "<figure>" ]
                        , Html.text " tag will always keep a 16 / 9 aspect ratio and grow with the container. It only contains one "
                        , Html.code [] [ Html.text "img" ]
                        , Html.text " tag."
                        ]
                    , Html.pre []
                        [ Html.code []
                            [ Html.text """
-- The <figure> tag will always keep a 16 / 9 aspect ratio and grow with the container.
Image.create { width = 300, height = 300 }
    |> Image.withAspectRatio ( 16, 9 )
    |> Image.toSimpleHtml { alt = "Testbild", src = "https://picsum.photos/300/300" }
"""
                            ]
                        ]
                    ]
                , Columns.column [ ( Columns.Desktop, Columns.Half ) ]
                    [ styled Html.p
                        [ Utils.block ]
                        []
                        [ Image.create { width = 300, height = 300 }
                            |> Image.toSimpleHtml { alt = "Testbild", src = "https://picsum.photos/300/300" }
                        ]
                    , styled Html.p
                        [ Utils.block ]
                        []
                        [ Html.text "The "
                        , Html.code [] [ Html.text "<figure>" ]
                        , Html.text " tag will grow with the container and keep the image centered. It only only contain one "
                        , Html.code [] [ Html.text "img" ]
                        , Html.text " tag."
                        ]
                    , Html.pre []
                        [ Html.code []
                            [ Html.text """
Image.create { width = 300, height = 300 }
    |> Image.toSimpleHtml { alt = "Testbild", src = "https://picsum.photos/300/300" }
"""
                            ]
                        ]
                    ]
                , Columns.column [ ( Columns.Desktop, Columns.Half ) ]
                    [ styled Html.p
                        [ Utils.block ]
                        []
                        [ Image.create { width = 300, height = 300 }
                            |> Image.toHtml "Testbild" []
                        ]
                    , styled Html.p
                        [ Utils.block ]
                        []
                        [ Html.text "If the source list is empty, the figure will contain the \"missing image\" icon"
                        ]
                    , Html.pre []
                        [ Html.code []
                            [ Html.text """
Image.create { width = 300, height = 300 }
    |> Image.toHtml  "Testbild" []
"""
                            ]
                        ]
                    ]
                , Columns.column [ ( Columns.Desktop, Columns.Half ) ]
                    [ styled Html.p
                        [ Utils.block ]
                        []
                        [ Image.create { width = 300, height = 300 }
                            |> Image.withAspectRatio ( 16, 9 )
                            |> Image.toMissingHtml
                        ]
                    , styled Html.p
                        [ Utils.block ]
                        []
                        [ Html.text "You can force the missing image icon using \"toMissingHtml\". The icon will adhere the same aspect ratio settings as an image."
                        ]
                    , Html.pre []
                        [ Html.code []
                            [ Html.text """
Image.create { width = 300, height = 300 }
    |> Image.withAspectRatio ( 16, 9 )
    |> Image.toMissingHtml
"""
                            ]
                        ]
                    ]
                ]
            ]
        ]



-- SNACKBAR


viewSnackbarInfo : { duration : Int, iconWithColor : Maybe ( Int, Color ) } -> Html Msg
viewSnackbarInfo settings =
    Section.section []
        [ Container.container []
            [ Title.title1 "Snackbar"
            , Content.content []
                [ Html.p []
                    [ Html.text "From: "
                    , Html.a [ Attributes.href "https://material.io/components/snackbars#usage" ] [ Html.text "Material Design - Snackbars" ]
                    ]
                , Html.blockquote []
                    [ Html.text "Snackbars inform users of a process that an app has performed or will perform. They appear temporarily, towards the bottom of the screen. They shouldn’t interrupt the user experience, and they don’t require user input to disappear."
                    ]
                ]
            , Form.field []
                [ Form.label "Duration"
                , Form.control False
                    [ Input.number GotSnackbarDuration (String.fromInt settings.duration)
                        |> Input.toHtml
                    ]
                ]
            , Form.field []
                [ Form.label "Icon and color"
                , Form.control False
                    [ viewSnackbarIcons settings.iconWithColor ]
                ]
            , case settings.iconWithColor of
                Nothing ->
                    Html.text ""

                Just ( iconIndex, color ) ->
                    Form.field
                        []
                        [ Form.label "Color"
                        , Form.control False (List.map (viewColorRadioButton ClickedSnackbarColor color) (greys ++ colors))
                        ]
            , Form.field []
                [ Form.label "Add snackbar"
                , Form.control False
                    [ Buttons.button [ Buttons.Color Colors.Primary ] (Just AddSnackbar) [ Html.text "Add snackbar" ] ]
                ]
            , Content.content []
                [ Html.pre []
                    [ Html.code []
                        [ Html.text ("""Snackbar.add
    snackbarConfig
    model.snackbar
    (Snackbar.create
        { label = "A short text label"
        , message = Html.text "A longer Html message"
        }
        |> Snackbar.withDuration """ ++ String.fromInt settings.duration)
                        , case settings.iconWithColor of
                            Nothing ->
                                Html.text ""

                            Just ( iconIndex, color ) ->
                                Html.text ("\n        |> Snackbar.withIcon SE.UI.Icon.V2." ++ (find iconIndex allIcons |> Maybe.map Tuple.first |> Maybe.withDefault "") ++ " SE.UI.Colors." ++ Debug.toString color)
                        , Html.text "\n    )"
                        ]
                    ]
                ]
            ]
        ]


viewSnackbarIcons : Maybe ( Int, Color ) -> Html Msg
viewSnackbarIcons maybeIconWithColor =
    styled Html.div [ Css.displayFlex, Css.flexWrap Css.wrap ] [] (List.indexedMap (viewSnackbarIcon maybeIconWithColor) allIcons)


viewSnackbarIcon : Maybe ( Int, Color ) -> Int -> ( String, Icon ) -> Html Msg
viewSnackbarIcon maybeIconWithColor index ( label, icon ) =
    let
        activeIndex =
            maybeIconWithColor |> Maybe.map Tuple.first |> Maybe.withDefault -1

        activeColor =
            maybeIconWithColor |> Maybe.map Tuple.second |> Maybe.withDefault Colors.Black

        backgroundColor =
            Colors.toHsla
                (if activeIndex == index then
                    activeColor

                 else
                    Colors.White
                )
    in
    styled div
        [ Colors.backgroundColor backgroundColor
        , Colors.color (backgroundColor |> Colors.invert)
        , Css.cursor Css.pointer
        ]
        [ Attributes.title label, Events.onClick (GotSnackbarIcon index) ]
        [ icon
            |> Icon.toHtml
        ]



-- LOGO


viewLogo : Html Msg
viewLogo =
    Section.section []
        [ Container.container []
            [ Title.title1 "Logos"
            , Content.content []
                [ Html.p []
                    [ Html.text "Special-Elektroniks logo comes in either white text (for dark background) and black text (for light background)."
                    ]
                ]
            , Columns.columns
                [ Columns.defaultColumn
                    [ styled div
                        [ Colors.backgroundColor Colors.lightest
                        , Css.padding (Css.pct 20)
                        ]
                        []
                        [ Logo.onWhite ]
                    , Content.content []
                        [ Html.code []
                            [ Html.text "SE.UI.Logo.onWhite"
                            ]
                        ]
                    ]
                , Columns.defaultColumn
                    [ styled div
                        [ Colors.backgroundColor Colors.darkest
                        , Css.padding (Css.pct 20)
                        ]
                        []
                        [ Logo.onBlack
                        ]
                    , Content.content []
                        [ Html.code []
                            [ Html.text "SE.UI.Logo.onBlack"
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewCrestronLogo : CrestronModel -> Html Msg
viewCrestronLogo { color, variant } =
    let
        { fn, code, bg } =
            case ( color, variant ) of
                ( Blue, Standard ) ->
                    { fn = Crestron.blue, code = "SE.UI.Logos.Crestron.blue", bg = Colors.lightest }

                ( Black, Standard ) ->
                    { fn = Crestron.black, code = "SE.UI.Logos.Crestron.black", bg = Colors.lightest }

                ( White, Standard ) ->
                    { fn = Crestron.white, code = "SE.UI.Logos.Crestron.white", bg = Colors.darkest }

                ( Blue, Swirl ) ->
                    { fn = Crestron.blueSwirl, code = "SE.UI.Logos.Crestron.blueSwirl", bg = Colors.lightest }

                ( Black, Swirl ) ->
                    { fn = Crestron.blackSwirl, code = "SE.UI.Logos.Crestron.blackSwirl", bg = Colors.lightest }

                ( White, Swirl ) ->
                    { fn = Crestron.whiteSwirl, code = "SE.UI.Logos.Crestron.whiteSwirl", bg = Colors.darkest }

                ( Blue, Stack ) ->
                    { fn = Crestron.blueStack, code = "SE.UI.Logos.Crestron.blueStack", bg = Colors.lightest }

                ( Black, Stack ) ->
                    { fn = Crestron.blackStack, code = "SE.UI.Logos.Crestron.blackStack", bg = Colors.lightest }

                ( White, Stack ) ->
                    { fn = Crestron.whiteStack, code = "SE.UI.Logos.Crestron.whiteStack", bg = Colors.darkest }
    in
    Section.section []
        [ Container.container []
            [ Title.title1 "Crestron Logos"
            , Content.content []
                [ Html.p []
                    [ Html.text "The Crestron logo comes in three color and three variants"
                    ]
                ]
            , Form.field []
                [ Form.label "Colors"
                , Form.control False
                    (List.map (viewCrestronColor color) allCrestronColors)
                ]
            , Form.field []
                [ Form.label "Variants"
                , Form.control False
                    (List.map (viewCrestronVariant variant) allCrestronVariants)
                ]
            , Columns.columns
                [ Columns.defaultColumn
                    [ styled div
                        [ Colors.backgroundColor bg
                        , Css.padding (Css.pct 20)
                        ]
                        []
                        [ fn ]
                    , Content.content []
                        [ Html.code []
                            [ Html.text code
                            ]
                        ]
                    ]
                ]
            ]
        ]


allCrestronColors : List ( CrestronColor, String )
allCrestronColors =
    [ ( Blue, "Blue" )
    , ( Black, "Black" )
    , ( White, "White" )
    ]


allCrestronVariants : List ( CrestronVariant, String )
allCrestronVariants =
    [ ( Standard, "Standard" )
    , ( Stack, "Stack" )
    , ( Swirl, "Swirl" )
    ]


viewCrestronColor : CrestronColor -> ( CrestronColor, String ) -> Html Msg
viewCrestronColor activeColor ( color, label ) =
    Input.radio (GotCrestronMsg (ToggledColor color)) label (activeColor == color)
        |> Input.toHtml


viewCrestronVariant : CrestronVariant -> ( CrestronVariant, String ) -> Html Msg
viewCrestronVariant activeVariant ( variant, label ) =
    Input.radio (GotCrestronMsg (ToggledVariant variant)) label (activeVariant == variant)
        |> Input.toHtml


viewPanasonicLogo : PanasonicModel -> Html Msg
viewPanasonicLogo { color, isMonochrome } =
    let
        { fn, code, bg } =
            case color of
                OnBlack ->
                    { fn = Panasonic.onBlack, code = "SE.UI.Logos.Panasonic.onBlack", bg = Colors.darkest }

                OnWhite ->
                    { fn = Panasonic.onWhite, code = "SE.UI.Logos.Panasonic.onWhite", bg = Colors.lightest }

        isMonochromeCode =
            if isMonochrome then
                "True"

            else
                "False"
    in
    Section.section []
        [ Container.container []
            [ Title.title1 "Panasonic Logos"
            , Content.content []
                [ Html.p []
                    [ Html.text "The Panasonic logo comes in a color mode and a monochrome mode and for black (dark) backgrounds and white (light) backgrounds."
                    ]
                ]
            , Form.field []
                [ Form.label "Colors"
                , Form.control False
                    (List.map (viewPanasonicColor color) allPanasonicColors)
                ]
            , Form.field []
                [ Form.label "Monochrome"
                , Form.control False
                    [ Input.checkbox
                        (GotPanasonicMsg ToggledMonochrome)
                        "Monochrome"
                        isMonochrome
                        |> Input.toHtml
                    ]
                ]
            , Columns.columns
                [ Columns.defaultColumn
                    [ styled div
                        [ Colors.backgroundColor bg
                        , Css.padding (Css.pct 20)
                        ]
                        []
                        [ fn isMonochrome ]
                    , Content.content []
                        [ Html.code []
                            [ Html.text (code ++ " " ++ isMonochromeCode)
                            ]
                        ]
                    ]
                ]
            ]
        ]


allPanasonicColors : List ( PanasonicColor, String )
allPanasonicColors =
    [ ( OnWhite, "OnWhite" )
    , ( OnBlack, "OnBlack" )
    ]


viewPanasonicColor : PanasonicColor -> ( PanasonicColor, String ) -> Html Msg
viewPanasonicColor activeColor ( color, label ) =
    Input.radio (GotPanasonicMsg (ToggledPanasonicColor color)) label (activeColor == color)
        |> Input.toHtml


viewTypography : Html Msg
viewTypography =
    Section.section []
        [ Container.container []
            [ Title.title1 "Typography"
            , Content.content
                []
                [ Html.p []
                    [ Html.text "We support the same "
                    , Html.code [] [ Html.text "content" ]
                    , Html.text " as Bulma. Use it wherever you have html content from a wysiwyg-editor that you can (and should not) style yourself."
                    ]
                , Html.h1 [] [ Html.text "H1 Title - This is a H1 title 44.79px/58.2px (mobile: 28.83px/37.5px)" ]
                , Html.h2 [] [ Html.text "H2 Title - This is a H2 title 37.32px/48.5px (mobile: 25.63px/33.3px)" ]
                , Html.h3 [] [ Html.text "H3 Title - This is a H3 title 31.1px/40.4px (mobile: 22.78px/29.6px)" ]
                , Html.h4 [] [ Html.text "H4 Title - This is a H4 title 25.92px/33.7px (mobile: 20.25px/26.3px)" ]
                , Html.h5 [] [ Html.text "H5 Title - This is a H5 title 21.6px/28.1px (mobile: 18px/23.4px)" ]
                , Html.h6 [] [ Html.text "H6 Title - This is a H6 title 18px/23.4px (mobile: 16px/20.8px)" ]
                , Html.p [] [ Html.text "Body Standard 18px/27px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , styled Html.p [ Font.bodySizeEm -1 ] [] [ Html.text "Body Medium 16px/24px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -1 ] [] [ Html.text \"Text content\" ]" ]
                , styled Html.p [ Font.bodySizeEm -2 ] [] [ Html.text "Body Small 14px/21px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -2 ] [] [ Html.text \"Text content\" ]" ]
                , styled Html.p [ Font.bodySizeEm -2, Css.lineHeight (Css.num 1.28571428571) ] [] [ Html.text "Body Small less line-height 14px/18px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -2, Css.lineHeight (Css.num 1.28571428571) ] [] [ Html.text \"Text content\" ]" ]
                , styled Html.p [ Font.bodySizeEm -3 ] [] [ Html.text "Small info text 12px/18px" ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -3 ] [] [ Html.text \"Text content\" ]" ]
                , Html.ul []
                    [ Html.li [] [ Html.text "List item 1" ]
                    , Html.li [] [ Html.text "List item 2" ]
                    , Html.li [] [ Html.text "List item 3" ]
                    ]
                , Html.p []
                    [ styled Html.a
                        Font.textButtonStyles
                        []
                        [ Html.text "Visa mer"
                        , Icon.angleDown |> Icon.withSize Control.Small |> Icon.toHtml
                        ]
                    ]
                , Html.p [] [ Html.code [] [ Html.text "styled Html.a Font.textButtonStyles [] [ Html.text \"Visa mer\" , Icon.angleDown Control.Small ]" ] ]
                ]
            ]
        , Container.container [ Container.Small ]
            [ Content.content
                []
                [ Html.p []
                    [ Html.text "We support the same "
                    , Html.code [] [ Html.text "content" ]
                    , Html.text " as Bulma. Use it wherever you have html content from a wysiwyg-editor that you can (and should not) style yourself."
                    ]
                , Html.h1 [] [ Html.text "H1 Title - This is a H1 title 44.79px/58.2px (mobile: 28.83px/37.5px)" ]
                , Html.h2 [] [ Html.text "H2 Title - This is a H2 title 37.32px/48.5px (mobile: 25.63px/33.3px)" ]
                , Html.h3 [] [ Html.text "H3 Title - This is a H3 title 31.1px/40.4px (mobile: 22.78px/29.6px)" ]
                , Html.h4 [] [ Html.text "H4 Title - This is a H4 title 25.92px/33.7px (mobile: 20.25px/26.3px)" ]
                , Html.h5 [] [ Html.text "H5 Title - This is a H5 title 21.6px/28.1px (mobile: 18px/23.4px)" ]
                , Html.h6 [] [ Html.text "H6 Title - This is a H6 title 18px/23.4px (mobile: 16px/20.8px)" ]
                , Html.p [] [ Html.text "Body Standard 18px/27px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , styled Html.p [ Font.bodySizeEm -1 ] [] [ Html.text "Body Medium 16px/24px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -1 ] [] [ Html.text \"Text content\" ]" ]
                , styled Html.p [ Font.bodySizeEm -2 ] [] [ Html.text "Body Small 14px/21px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -2 ] [] [ Html.text \"Text content\" ]" ]
                , styled Html.p [ Font.bodySizeEm -2, Css.lineHeight (Css.num 1.28571428571) ] [] [ Html.text "Body Small less line-height 14px/18px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -2, Css.lineHeight (Css.num 1.28571428571) ] [] [ Html.text \"Text content\" ]" ]
                , styled Html.p [ Font.bodySizeEm -3 ] [] [ Html.text "Small info text 12px/18px" ]
                , Html.code [] [ Html.text "styled Html.p [ Font.bodySizeEm -3 ] [] [ Html.text \"Text content\" ]" ]
                , Html.ul []
                    [ Html.li [] [ Html.text "List item 1" ]
                    , Html.li [] [ Html.text "List item 2" ]
                    , Html.li [] [ Html.text "List item 3" ]
                    ]
                ]
            ]
        ]


viewColumns : ColumnsModel -> Html Msg
viewColumns model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Columns"
            , Content.content
                []
                [ Html.p []
                    [ Html.text "Columns description" ]
                ]
            , Buttons.buttons []
                [ Buttons.button [] (Just (GotColumnsMsg AddColumn)) [ Html.text "Add column " ]
                , Buttons.button [] (Just (GotColumnsMsg SubtractColumn)) [ Html.text "Remove column " ]
                ]
            , Columns.columns (List.map viewColumn (List.range 1 model.count))
            ]
        ]


viewColumn index =
    Columns.defaultColumn
        [ styled div
            [ Colors.backgroundColor Colors.background
            , Css.borderRadius (Css.rem 0.5)
            , Css.padding (Css.rem 1)
            ]
            []
            [ Html.text ("Column " ++ String.fromInt index) ]
        ]


greys : List ( String, Colors.Color )
greys =
    [ ( "White", Colors.White )
    , ( "Lightest", Colors.Lightest )
    , ( "Lighter", Colors.Lighter )
    , ( "Light", Colors.Light )
    , ( "Base", Colors.Base )
    , ( "Dark", Colors.Dark )
    , ( "Darker", Colors.Darker )
    , ( "Darkest", Colors.Darkest )
    , ( "Black", Colors.Black )
    ]


colors : List ( String, Colors.Color )
colors =
    [ ( "Primary", Colors.Primary )
    , ( "Link", Colors.Link )
    , ( "Buy", Colors.Buy )
    , ( "Danger", Colors.Danger )
    , ( "Bargain", Colors.Bargain )
    , ( "DarkGreen", Colors.DarkGreen )
    , ( "LightBlue", Colors.LightBlue )
    ]


viewColors : Html Msg
viewColors =
    Section.section []
        [ Container.container []
            [ Title.title1 "Colors"
            , Title.title3 "Grays"
            , Columns.multilineColumns
                (List.map (\c -> Columns.column [ ( Columns.All, Columns.OneThird ) ] [ viewColorBox c ]) greys)
            , Title.title3 "Others"
            , Columns.multilineColumns
                (List.map (\c -> Columns.column [ ( Columns.All, Columns.OneThird ) ] [ viewColorBox c ]) colors)
            ]
        ]


viewColorBox : ( String, Colors.Color ) -> Html Msg
viewColorBox ( label, color ) =
    styled Html.div
        [ Css.displayFlex
        , Css.alignItems Css.center
        ]
        []
        [ styled div
            [ Css.width (Css.rem 3)
            , Css.height (Css.rem 3)
            , Colors.backgroundColor (color |> Colors.toHsla)
            , Css.boxShadow6 Css.inset Css.zero (Css.px 2) (Css.px 4) Css.zero (Css.rgba 0 0 0 0.06)
            , Css.borderRadius (Css.rem 0.5)
            ]
            []
            []
        , styled div
            [ Css.marginLeft (Css.rem 0.5)
            ]
            []
            [ Html.text label ]
        ]


allOtherMods : List ( Buttons.Modifier, String )
allOtherMods =
    [ ( Buttons.Text, "Text" )
    , ( Buttons.Size Control.Regular, "Size Control.Regular" )
    , ( Buttons.Size Control.Small, "Size Control.Small" )
    , ( Buttons.Size Control.Medium, "Size Control.Medium" )
    , ( Buttons.Size Control.Large, "Size Control.Large" )
    , ( Buttons.Fullwidth, "Fullwidth" )
    , ( Buttons.Loading, "Loading" )
    ]


allButtonColors : List ( Buttons.Modifier, String )
allButtonColors =
    [ ( Buttons.Color Colors.Primary, "Primary" )
    , ( Buttons.Color Colors.Link, "Link" )
    , ( Buttons.Color Colors.Buy, "Buy" )
    , ( Buttons.Color Colors.Bargain, "Bargin" )
    , ( Buttons.Color Colors.Danger, "Danger" )
    , ( Buttons.Color Colors.DarkGreen, "DarkGreen" )
    , ( Buttons.Color Colors.LightBlue, "LightBlue" )
    ]


allButtonGreys : List ( Buttons.Modifier, String )
allButtonGreys =
    [ ( Buttons.Color Colors.White, "White" )
    , ( Buttons.Color Colors.Lightest, "Lightest" )
    , ( Buttons.Color Colors.Lighter, "Lighter" )
    , ( Buttons.Color Colors.Light, "Light" )
    , ( Buttons.Color Colors.Base, "Base" )
    , ( Buttons.Color Colors.Dark, "Dark" )
    , ( Buttons.Color Colors.Darker, "Darker" )
    , ( Buttons.Color Colors.Darkest, "Darkest" )
    , ( Buttons.Color Colors.Black, "Black" )
    ]


viewButtons : ButtonModel -> Html Msg
viewButtons model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Buttons"
            , Form.field []
                [ Form.label "Greys"
                , Form.control False
                    (List.map (viewButtonModifier model.mods) allButtonGreys)
                ]
            , Form.field []
                [ Form.label "Colors"
                , Form.control False
                    (List.map (viewButtonModifier model.mods) allButtonColors)
                ]
            , Form.field []
                [ Form.label "Others"
                , Form.control False
                    (List.map (viewButtonModifier model.mods) allOtherMods)
                ]
            , Buttons.buttons []
                [ Buttons.button model.mods (Just ClickedButton) [ Icon.cart |> Icon.withSize Control.Medium |> Icon.toHtml, Html.span [] [ Html.text "Add to cart" ] ]
                ]
            , Html.pre []
                [ Html.code []
                    [ Html.text ("""SE.UI.Buttons.button
    [ """ ++ (List.map modToString model.mods |> String.join "\n    , ") ++ """
    ]
    (Just ClickedButton)
    [ Icon.cart Control.Regular, Html.text "Add to cart" ]""")
                    ]
                ]
            , Title.title1 "Button Groups"
            , Buttons.buttons [ Buttons.Attached, Buttons.Centered ]
                [ Buttons.button [ Buttons.Color Colors.Lighter ] (Just NoOp) [ Html.text "Visa alla" ]
                , Buttons.button [] (Just NoOp) [ Html.text "Produktnyheter" ]
                , Buttons.button [] (Just NoOp) [ Html.text "Pressreleaser" ]
                , Buttons.button [] (Just NoOp) [ Html.text "Om Special-Elektronik" ]
                ]
            , Content.content []
                [ Html.pre []
                    [ Html.code []
                        [ Html.text "SE.UI.Buttons.buttons [ Buttons.Attached, Buttons.Centered ]\n    [ Buttons.button [ Buttons.Color Colors.Lighter ] (Just NoOp) [ Html.text \"Visa alla\" ]\n    , Buttons.button [] (Just NoOp) [ Html.text \"Produktnyheter\" ]\n    , Buttons.button [] (Just NoOp) [ Html.text \"Pressreleaser\" ]\n    , Buttons.button [] (Just NoOp) [ Html.text \"Om Special-Elektronik\" ]\n    ]"
                        ]
                    ]
                ]
            ]
        ]


modToString : Buttons.Modifier -> String
modToString mod =
    case mod of
        Buttons.Color Colors.Primary ->
            "Buttons.Color Colors.Primary"

        Buttons.Color Colors.Link ->
            "Buttons.Color Colors.Link"

        Buttons.Color Colors.Buy ->
            "Buttons.Color Colors.Buy"

        Buttons.Color Colors.Bargain ->
            "Buttons.Color Colors.Bargain"

        Buttons.Color Colors.Danger ->
            "Buttons.Color Colors.Danger"

        Buttons.Color Colors.White ->
            "Buttons.Color Colors.White"

        Buttons.Color Colors.Lightest ->
            "Buttons.Color Colors.Lightest"

        Buttons.Color Colors.Lighter ->
            "Buttons.Color Colors.Lighter"

        Buttons.Color Colors.Light ->
            "Buttons.Color Colors.Light"

        Buttons.Color Colors.Base ->
            "Buttons.Color Colors.Base"

        Buttons.Color Colors.Dark ->
            "Buttons.Color Colors.Dark"

        Buttons.Color Colors.Darker ->
            "Buttons.Color Colors.Darker"

        Buttons.Color Colors.Darkest ->
            "Buttons.Color Colors.Darkest"

        Buttons.Color Colors.Black ->
            "Buttons.Color Colors.Black"

        Buttons.Color Colors.DarkGreen ->
            "Buttons.Color Colors.DarkGreen"

        Buttons.Color Colors.LightBlue ->
            "Buttons.Color Colors.LightBlue"

        Buttons.Text ->
            "Buttons.Text"

        Buttons.Size Control.Regular ->
            "Buttons.Size Control.Regular"

        Buttons.Size Control.Small ->
            "Buttons.Size Control.Small"

        Buttons.Size Control.Medium ->
            "Buttons.Size Control.Medium"

        Buttons.Size Control.Large ->
            "Buttons.Size Control.Large"

        Buttons.Fullwidth ->
            "Buttons.Fullwidth"

        Buttons.Loading ->
            "Buttons.Loading"


viewButtonModifier : List Buttons.Modifier -> ( Buttons.Modifier, String ) -> Html Msg
viewButtonModifier activeMods ( mod, label ) =
    Input.checkbox (GotButtonsMsg (ToggledModifier mod)) label (List.member mod activeMods)
        |> Input.toHtml


viewSection : Html Msg
viewSection =
    Section.section []
        [ Container.container []
            [ Title.title1 "Section"
            , Html.p [] [ Html.text "Creates a styled section html tag in line with ", Html.a [ Attributes.href "https://bulma.io/documentation/layout/section/" ] [ Html.text "Bulmas section" ], Html.text "." ]
            , Html.code []
                [ Html.text "section [] [ Html.text \"I'm the text inside the section!\" ]"
                ]
            ]
        ]


viewContainer : Html Msg
viewContainer =
    Section.section []
        [ Container.container []
            [ Title.title1 "Container"
            , Html.p [] [ Html.text "Bulmas container tag, but max-width is set to 1680px for all devices\nsee ", Html.a [ Attributes.href "https://bulma.io/documentation/layout/container" ] [ Html.text "https://bulma.io/documentation/layout/container" ], Html.text "." ]
            , Html.code []
                [ Html.text "section [] [ Html.text \"I'm the text inside the container!\" ]"
                ]
            ]
        ]


viewLevel : Model -> Html Msg
viewLevel model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Level"
            , Level.level
                [ Level.item
                    [ Form.field []
                        [ Form.label "Select element"
                        , Form.control False
                            [ Input.select GotInput
                                [ { label = "Option 1", value = "option 1" }
                                , { label = "Option 2", value = "option 2" }
                                , { label = "Option 3", value = "option 3" }
                                ]
                                model.input
                                |> Input.withPlaceholder "Placeholder"
                                |> Input.toHtml
                            ]
                        ]
                    ]
                ]
                [ Level.item
                    [ Form.field []
                        [ Form.label "Select element"
                        , Form.control False
                            [ Input.select GotInput
                                [ { label = "Option 1", value = "option 1" }
                                , { label = "Option 2", value = "option 2" }
                                , { label = "Option 3", value = "option 3" }
                                ]
                                model.input
                                |> Input.withPlaceholder "Placeholder"
                                |> Input.toHtml
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewForm : Model -> Html Msg
viewForm model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Form"
            , Html.form []
                [ Form.field []
                    [ Form.label "Small label"
                    , Form.control False
                        [ Input.text GotInput model.input
                            |> Input.withPlaceholder "Placeholder"
                            |> Input.withName "small"
                            |> Input.toHtml
                        ]
                    ]
                , Form.field []
                    [ Form.label "Select element"
                    , Form.control False
                        [ Input.select GotInput
                            [ { label = "Option 1", value = "option 1" }
                            , { label = "Option 2", value = "option 2" }
                            , { label = "Option 3", value = "option 3" }
                            ]
                            model.input
                            |> Input.withPlaceholder "Placeholder"
                            |> Input.toHtml
                        ]
                    ]
                ]
            , Title.title3 "Dropdown"
            , viewDropdown model.showDropdown
            , Title.title3 "Inputs in level"
            , Level.level
                [ Level.item [ styled Html.p [ Font.bodySizeRem -1 ] [] [ Html.text "Visa: " ] ]
                , Level.item [ Buttons.button [ Buttons.Text ] (Just NoOp) [ Html.text "Mina ordrar" ] ]
                , Level.item [ Buttons.button [ Buttons.Color Colors.Primary ] (Just NoOp) [ Html.text "Alla ordrar" ] ]
                ]
                []
            ]
        ]


viewDropdown : Bool -> Html Msg
viewDropdown isOpen =
    let
        icon =
            Icon.angleDown
                |> (if isOpen then
                        Icon.withTransform Icon.FlipY

                    else
                        identity
                   )
    in
    Dropdown.dropdown "example-dropdown"
        ClosedDropdown
        isOpen
        (Dropdown.button [] (Just ToggledDropdown) [ Html.text "Dropdown menu", icon |> Icon.toHtml ])
        [ Dropdown.link "https://google.com" [ Html.text "Google.com" ]
        , Dropdown.msgLink AddSnackbar [ Html.text "Add Snackbar" ]
        , Dropdown.hr
        , Dropdown.content [ Html.text "Any content you like can go into the dropdown." ]
        ]


viewNotification : NotificationModel -> Html Msg
viewNotification model =
    let
        fn =
            colorToNotification model.color

        ( isCustom, customColor ) =
            case model.color of
                Custom color_ ->
                    ( True, color_ )

                _ ->
                    -- Lightest = Fallback color that will never be used.
                    ( False, Colors.Lightest )

        maybeMsg =
            if model.deleteable then
                ( "(Just (GotNotificationMsg Delete))", Just NoOp )

            else
                ( "Nothing", Nothing )
    in
    Section.section []
        [ Container.container []
            [ Title.title1 "Notification"
            , Form.field []
                [ Form.label "Modifiers"
                , Form.control False (List.map (viewNotificationColor model.color) (allNotificationColors Colors.Lightest))
                ]
            , viewIf isCustom
                (Form.field
                    []
                    [ Form.label "Custom color"
                    , Form.control False (List.map (viewColorRadioButton (GotNotificationMsg << ClickedCustomColor) customColor) (greys ++ colors))
                    ]
                )
            , Form.field []
                [ Form.control False
                    [ Input.checkbox (GotNotificationMsg ToggledDeleteable) "Deleteable?" model.deleteable
                        |> Input.toHtml
                    ]
                ]
            , Tuple.second fn (Tuple.second maybeMsg) [ Html.text "This is a notification with a short message." ]
            , Html.code []
                [ Html.text ("SE.UI.Notification." ++ Tuple.first fn ++ " " ++ Tuple.first maybeMsg ++ " [ Html.text \"This is a notification with a short message.\" ]")
                ]
            ]
        ]


viewNotificationColor : NotificationColor -> ( String, NotificationColor ) -> Html Msg
viewNotificationColor activeColor ( label, color ) =
    let
        isSame =
            case ( activeColor, color ) of
                ( Custom _, Custom _ ) ->
                    True

                _ ->
                    activeColor == color
    in
    Input.radio (GotNotificationMsg (ClickedColor color)) label isSame
        |> Input.toHtml


viewColorRadioButton : (Colors.Color -> msg) -> Colors.Color -> ( String, Colors.Color ) -> Html msg
viewColorRadioButton msg activeColor ( label, color ) =
    Input.radio (msg color) label (activeColor == color)
        |> Input.toHtml


allNotificationColors : Colors.Color -> List ( String, NotificationColor )
allNotificationColors customColor =
    [ ( "Regular", Regular )
    , ( "Primary", Primary )
    , ( "Link", Link )
    , ( "Danger", Danger )
    , ( "Custom", Custom customColor )
    ]


viewModal : Bool -> Html Msg
viewModal visible =
    Section.section []
        [ Container.container []
            [ Title.title1 "Modal"
            , Content.content []
                [ Html.p [] [ Html.text "A modal to show longer information text without leave the page, an high res image or anything else." ]
                , Buttons.button [ Buttons.Color Colors.Primary ] (Just ToggledModal) [ Html.text "Launch modal example" ]
                , viewIf visible
                    (Modal.modal ToggledModal
                        [ styled Html.div
                            [ Css.padding (Css.em 2)
                            , Colors.backgroundColor Colors.white
                            ]
                            []
                            [ Title.title5 "Detta är en info popup. T.ex. för Kem-skatt eller BID-priser"
                            , Content.content
                                []
                                [ Html.p []
                                    [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget."
                                    ]
                                , Html.p []
                                    [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget."
                                    ]
                                ]
                            ]
                        ]
                    )
                ]
            ]
        ]


viewIcons : IconsModel -> Html Msg
viewIcons model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Icons"
            , Content.content []
                [ Html.p [] [ Html.text "For now we use some of the free icons from Font Awesome, we bundle the icons we need in Elm and then inline them into the html." ]
                , Html.p [] [ Html.text "The icons have be displayed in 4 different sizes: Regular, Small, Medium, Large" ]
                ]
            , Form.field []
                [ Form.label "Sizes"
                , Form.control False (List.map (viewIconsSize model.size) allControlSizes)
                ]
            , Form.field []
                [ Form.label "Transforms"
                , Form.control False (List.map (viewIconsTransform model.transform) allIconTransforms)
                ]
            , styled Html.div
                [ Css.displayFlex
                , Css.flexWrap Css.wrap
                , Css.alignItems Css.center
                ]
                []
                (List.indexedMap (viewIcon model) allIcons)
            , Html.code []
                [ Html.text "SE.UI.Icon.V2.angleDown |> SE.UI.Icon.V2.toHtml"
                ]
            ]
        ]


viewIconsSize : Control.Size -> ( Control.Size, String ) -> Html Msg
viewIconsSize =
    viewOption (GotIconsMsg << ToggledSize)


viewIcon : IconsModel -> Int -> ( String, Icon.Icon ) -> Html Msg
viewIcon model index ( label, icon ) =
    let
        ( backgroundColor, currentIcon ) =
            if Maybe.withDefault -1 model.activeId == index then
                ( Colors.dark
                , icon
                    |> Icon.withSize model.size
                    -- |> Icon.withContainerSize model.containerSize
                    |> (Maybe.map Icon.withTransform model.transform |> Maybe.withDefault identity)
                )

            else
                ( Colors.white, icon )
    in
    styled div
        [ Colors.backgroundColor backgroundColor
        , Colors.color (backgroundColor |> Colors.invert)
        , Css.cursor Css.pointer
        ]
        [ Attributes.title label, Events.onClick (GotIconsMsg (SelectedIndex index)) ]
        [ currentIcon
            |> Icon.toHtml
        ]


allIcons : List ( String, Icon.Icon )
allIcons =
    [ ( "angleDown", Icon.angleDown )
    , ( "ban", Icon.ban )
    , ( "bargain", Icon.bargain )
    , ( "bid", Icon.bid )
    , ( "box", Icon.box )
    , ( "boxes", Icon.boxes )
    , ( "calendar", Icon.calendar )
    , ( "campaign", Icon.campaign )
    , ( "cart", Icon.cart )
    , ( "category", Icon.category )
    , ( "checkCircle", Icon.checkCircle )
    , ( "clock", Icon.clock )
    , ( "dolly", Icon.dolly )
    , ( "envelope", Icon.envelope )
    , ( "ethernet", Icon.ethernet )
    , ( "eye", Icon.eye )
    , ( "facebook", Icon.facebook )
    , ( "file", Icon.file )
    , ( "history", Icon.history )
    , ( "home", Icon.home )
    , ( "images", Icon.images )
    , ( "laptop", Icon.laptop )
    , ( "lightbulb", Icon.lightbulb )
    , ( "linkedin", Icon.linkedin )
    , ( "mapMarker", Icon.mapMarker )
    , ( "new", Icon.new )
    , ( "notification", Icon.notification )
    , ( "pdf", Icon.pdf )
    , ( "percentage", Icon.percentage )
    , ( "phone", Icon.phone )
    , ( "playCircle", Icon.playCircle )
    , ( "satelliteDish", Icon.satelliteDish )
    , ( "search", Icon.search )
    , ( "slidersH", Icon.slidersH )
    , ( "star", Icon.star )
    , ( "sync", Icon.sync )
    , ( "table", Icon.table )
    , ( "th", Icon.th )
    , ( "thLarge", Icon.thLarge )
    , ( "thList", Icon.thList )
    , ( "trash", Icon.trash )
    , ( "truck", Icon.truck )
    , ( "tv", Icon.tv )
    , ( "user", Icon.user )
    , ( "wifi", Icon.wifi )
    ]


allIconTransforms : List ( String, Icon.Transform )
allIconTransforms =
    [ ( "Rotate 90deg", Icon.Rotate 90 )
    , ( "FlipX", Icon.FlipX )
    , ( "FlipY", Icon.FlipY )
    , ( "Spin", Icon.Spin )
    ]


viewIconsTransform : Maybe Icon.Transform -> ( String, Icon.Transform ) -> Html Msg
viewIconsTransform activeValue ( label, value ) =
    let
        isActive =
            case activeValue of
                Nothing ->
                    False

                Just currentValue ->
                    currentValue == value
    in
    Input.radio (GotIconsMsg (SelectedTransform value)) label isActive
        |> Input.toHtml



-- viewIconV2 : Html Msg
-- viewIconV2 =
--     Section.section []
--         [ Container.container []
--             [ Title.title1 "Icons version 2"
--             , Content.content []
--                 [ Html.p []
--                     [ Html.text "Better icons"
--                     ]
--                 ]
--             -- , Form.field []
--             --     [ Buttons.button [ Buttons.Color Colors.DarkGreen ] (Just ToggleNavbarBrand) [ Html.text "Toggle brand" ]
--             --     ]
--             , Html.div []
--                 [ IconV2.angleDown
--                     |> IconV2.withContainerSize Control.Large
--                     |> IconV2.withSize Control.Large
--                     -- |> IconV2.withTransform IconV2.Spin
--                     |> IconV2.toHtml
--                 ]
--             , styled Html.div
--                 [ Css.property "background-image" ("url(\"" ++ (IconV2.angleDown |> IconV2.toDataUri) ++ "\"), linear-gradient(to bottom, hsla(0, 0%, 96%, 1) 0%,hsla(0, 0%, 96%, 1) 100%)")
--                 , Css.property "background-repeat" "no-repeat, repeat"
--                 , Css.property "background-position" "right 0.75em top 50%, 0, 0"
--                 , Css.property "background-size" "0.75em auto, 100%"
--                 ]
--                 []
--                 [ Html.text "Här har vi en ikon som bakgrund"
--                 ]
--             , Html.code [] [ Html.text "Code is coming" ]
--             ]
--         ]


viewCard : Html Msg
viewCard =
    Section.section []
        [ Container.container []
            [ Title.title1 "Card"
            , Content.content []
                [ Html.p [] [ Html.text "The card component originates from Bulmas equivalent without the footer and image header. We also have a sub title available." ]
                ]
            , Card.content
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
            , Content.content []
                [ Html.pre []
                    [ Html.code []
                        [ Html.text "Card.content\n    [ Content.content []\n        [ Html.p []\n            [ Html.text \"This is where the content goes. It can be any content you like.\"\n            ]\n        ]\n    ]\n    |> Card.withTitle \"This is a title\"\n    |> Card.withSubTitle \"This is a subtitle\"\n    |> Card.withBoxShadow\n    |> Card.toHtml"
                        ]
                    ]
                ]
            ]
        ]


viewTable : TableModel -> Html Msg
viewTable model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Table"
            , Form.field []
                [ Form.label "Modifiers"
                , Form.control False (List.map (viewTableModifier model.mods) allTableModifiers)
                ]
            , Content.content []
                [ Html.p [] [ Html.text "The table component originates from Bulmas equivalent." ]
                ]
            ]
        , styled Html.div
            [ Utils.block
            , Colors.backgroundColor Colors.lightBlue
            , Css.padding (Css.px 16)
            ]
            []
            [ Table.body []
                [ Html.tr []
                    [ Html.th [] [ Html.text "This is a header cell." ]
                    , Html.td [] [ Html.text "This is text in a cell." ]
                    , Html.td [] [ Html.text "This is text in a cell." ]
                    ]
                , Html.tr []
                    [ Html.td [] [ Html.text "This is a header cell." ]
                    , Html.th [] [ Html.text "This is text in a cell." ]
                    , Html.td [] [ Html.text "This is text in a cell." ]
                    ]
                ]
                |> Table.withHead
                    [ Html.th [] [ Html.text "This is a header cell." ]
                    , Html.th [] [ Html.text "This is a header cell." ]
                    , Html.th [] [ Html.text "This is a header cell." ]
                    ]
                |> Table.withModifiers model.mods
                |> Table.toHtml
            ]
        , Content.content []
            [ Html.pre []
                [ Html.code []
                    [ Html.text "Table.body []\n            [ Html.tr []\n                [ Html.td [] [ Html.text \"This is text in a cell.\" ]\n                , Html.td [] [ Html.text \"This is text in a cell.\" ]\n                , Html.td [] [ Html.text \"This is text in a cell.\" ]\n                ]\n            , Html.tr []\n                [ Html.td [] [ Html.text \"This is text in a cell.\" ]\n                , Html.td [] [ Html.text \"This is text in a cell.\" ]\n                , Html.td [] [ Html.text \"This is text in a cell.\" ]\n                ]\n            ]\n            |> Table.withModifiers "
                    , Html.text ("[ " ++ (List.map tableModToString model.mods |> String.join ", ") ++ " ]")
                    , Html.text "\n            |> Table.toHtml"
                    ]
                ]
            ]
        , Notification.link Nothing
            [ Html.strong [] [ Html.text "Note" ]
            , Html.text ": There is also a "
            , Html.code [] [ Html.text "keyedBody" ]
            , Html.text " function if you need the rows to be "
            , Html.a [ Attributes.href "https://guide.elm-lang.org/optimization/keyed.html" ] [ Html.text "keyed" ]
            , Html.text "."
            ]
        ]


viewTableModifier : List Table.Modifier -> ( Table.Modifier, String ) -> Html Msg
viewTableModifier activeMods ( mod, label ) =
    Input.checkbox (GotTableMsg (ToggledTableModifier mod)) label (List.member mod activeMods)
        |> Input.toHtml


allTableModifiers : List ( Table.Modifier, String )
allTableModifiers =
    [ ( Table.Fullwidth, "Table.Fullwidth" )
    , ( Table.Hoverable, "Table.Hoverable" )
    ]


tableModToString : Table.Modifier -> String
tableModToString mod =
    case mod of
        Table.Fullwidth ->
            "Table.Fullwidth"

        Table.Hoverable ->
            "Table.Hoverable"


viewTabs : TabsModel -> Html Msg
viewTabs model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Tabs V2"
            , Form.field []
                [ Form.label "Sizes"
                , Form.control False (List.map (viewTabsSize model.size) allControlSizes)
                ]
            , Form.field []
                [ Form.label "Styles"
                , Form.control False (List.map (viewTabsStyle model.style) allTabsStyles)
                ]
            , Form.field []
                [ Form.label "Alignment"
                , Form.control False (List.map (viewTabsAlignment model.alignment) allAlignments)
                ]
            , Form.field []
                [ Form.label "Fullwidth"
                , Form.control False
                    [ Input.checkbox
                        (GotTabsMsg ToggledTabsFullwidth)
                        "Fullwidth"
                        model.isFullwidth
                        |> Input.toHtml
                    ]
                ]
            , Content.content []
                [ Html.p [] [ Html.text "The tabs component originates from Bulmas equivalent. The first version of Tabs is deprecated and should not be used." ]
                ]
            ]
        , styled Html.div
            [ Utils.block
            , Css.padding (Css.px 16)
            , Colors.backgroundColor Colors.lightBlue
            ]
            []
            [ Tabs.create
                [ Tabs.link True "#" [ Html.text "One" ]
                , Tabs.link False "#" [ Html.text "Two" ]
                , Tabs.button False NoOp [ Html.text "Three" ]
                ]
                |> tabsModifiersToCode model
                |> Tabs.toHtml
            ]
        , Content.content []
            [ Html.pre []
                [ Html.code []
                    [ Html.text ""
                    , Html.text """
    SE.UI.Tabs.V2.create [
        Tabs.link True "#" [ Html.text "One" ]
        , Tabs.link False "#" [ Html.text "Two" ]
        , Tabs.link False "#" [ Html.text "Three" ]
        ]
        """
                    , Html.text (tabsModifiersToCodeString model)
                    , Html.text """
        |> Tabs.toHtml
        """
                    ]
                ]
            ]
        ]


viewTabsSize : Control.Size -> ( Control.Size, String ) -> Html Msg
viewTabsSize =
    viewOption (GotTabsMsg << ToggledTabsSize)


allTabsStyles : List ( TabsStyle, String )
allTabsStyles =
    [ ( Unstyled, "Unstyled" )
    , ( Toggled, "Toggled" )
    , ( Boxed, "Boxed" )
    ]


viewTabsStyle : TabsStyle -> ( TabsStyle, String ) -> Html Msg
viewTabsStyle =
    viewOption (GotTabsMsg << ToggledTabsStyle)


viewTabsAlignment : Alignment -> ( Alignment, String ) -> Html Msg
viewTabsAlignment =
    viewOption (GotTabsMsg << ToggledTabsAlignment)


tabsModifiersToCodeString : TabsModel -> String
tabsModifiersToCodeString model =
    [ controlSizeToFuncCall model.size
    , tabsStyleToFuncCall model.style
    , alignmentToFuncCall model.alignment
    , if model.isFullwidth then
        "isFullwidth"

      else
        ""
    ]
        |> List.filter (not << String.isEmpty)
        |> List.foldl (\v acc -> acc ++ "|> SE.UI.Tabs.V2." ++ v ++ "\n") ""


tabsStyleToFuncCall : TabsStyle -> String
tabsStyleToFuncCall style =
    case style of
        Unstyled ->
            ""

        Toggled ->
            "isToggled"

        Boxed ->
            "isBoxed"


tabsModifiersToCode : TabsModel -> Tabs msg -> Tabs msg
tabsModifiersToCode model tabs =
    tabs
        |> (case model.size of
                Control.Small ->
                    Tabs.isSmall

                Control.Medium ->
                    Tabs.isMedium

                Control.Large ->
                    Tabs.isLarge

                _ ->
                    identity
           )
        |> (case model.style of
                Toggled ->
                    Tabs.isToggled

                Boxed ->
                    Tabs.isBoxed

                _ ->
                    identity
           )
        |> (case model.alignment of
                Alignment.Centered ->
                    Tabs.isCentered

                Alignment.Right ->
                    Tabs.isRight

                _ ->
                    identity
           )
        |> (if model.isFullwidth then
                Tabs.isFullwidth

            else
                identity
           )


viewPagination : PaginationModel -> Html Msg
viewPagination model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Pagination V2"
            , Form.field []
                [ Form.label "Sizes"
                , Form.control False (List.map (viewPaginationSize model.size) allControlSizes)
                ]
            , Form.field []
                [ Form.label "Alignment"
                , Form.control False (List.map (viewPaginationAlignment model.alignment) allAlignments)
                ]
            , Content.content []
                [ Html.p [] [ Html.text "The Pagination component originates from Bulmas equivalent. The first version of Pagination is deprecated and should not be used." ]
                ]
            ]
        , styled Html.div
            [ Utils.block
            , Css.padding (Css.px 16)
            , Colors.backgroundColor Colors.lightBlue
            ]
            []
            [ Pagination.create
                { lastPage = model.lastPage
                , currentPage = model.currentPage
                , nextPageLabel = "Next"
                , previousPageLabel = "Previous"
                , msg = GotPaginationMsg << ChangedPage
                }
                |> paginationModifiersToCode model
                |> Pagination.toHtml
            ]
        , Content.content []
            [ Html.pre []
                [ Html.code []
                    [ Html.text
                        ("""
    SE.UI.Pagination.create
        { lastPage = """ ++ String.fromInt model.lastPage ++ """
        , currentPage = """ ++ String.fromInt model.currentPage ++ """
        , nextPageLabel = "Next"
        , previousPageLabel = "Previous"
        , msg = ChangedPage
        }
        """)
                    , Html.text (paginationModifiersToCodeString model)
                    , Html.text """
        |> SE.UI.Pagination.toHtml
        """
                    ]
                ]
            ]
        ]


viewPaginationSize : Control.Size -> ( Control.Size, String ) -> Html Msg
viewPaginationSize =
    viewOption (GotPaginationMsg << ToggledPaginationSize)


viewPaginationAlignment : Alignment -> ( Alignment, String ) -> Html Msg
viewPaginationAlignment =
    viewOption (GotPaginationMsg << ToggledPaginationAlignment)


viewOption : (a -> Msg) -> a -> ( a, String ) -> Html Msg
viewOption msg activeValue ( value, label ) =
    Input.radio (msg value) label (activeValue == value)
        |> Input.toHtml


paginationModifiersToCodeString : PaginationModel -> String
paginationModifiersToCodeString model =
    [ controlSizeToFuncCall model.size
    , alignmentToFuncCall model.alignment
    ]
        |> List.filter (not << String.isEmpty)
        |> List.foldl (\v acc -> acc ++ "|> SE.UI.Pagination.V2." ++ v ++ "\n") ""


paginationModifiersToCode : PaginationModel -> Pagination msg -> Pagination msg
paginationModifiersToCode model pagination =
    pagination
        |> (case model.size of
                Control.Small ->
                    Pagination.isSmall

                Control.Medium ->
                    Pagination.isMedium

                Control.Large ->
                    Pagination.isLarge

                _ ->
                    identity
           )
        |> (case model.alignment of
                Alignment.Centered ->
                    Pagination.isCentered

                Alignment.Right ->
                    Pagination.isRight

                _ ->
                    identity
           )


allControlSizes : List ( Control.Size, String )
allControlSizes =
    [ ( Control.Regular, "Regular" )
    , ( Control.Small, "Small" )
    , ( Control.Medium, "Medium" )
    , ( Control.Large, "Large" )
    ]


controlSizeToFuncCall : Control.Size -> String
controlSizeToFuncCall size =
    case size of
        Control.Regular ->
            ""

        Control.Small ->
            "isSmall"

        Control.Medium ->
            "isMedium"

        Control.Large ->
            "isLarge"


allAlignments : List ( Alignment, String )
allAlignments =
    [ ( Alignment.Left, "Left" )
    , ( Alignment.Centered, "Centered" )
    , ( Alignment.Right, "Right" )
    ]


alignmentToFuncCall : Alignment -> String
alignmentToFuncCall alignment =
    case alignment of
        Alignment.Left ->
            ""

        Alignment.Centered ->
            "isCentered"

        Alignment.Right ->
            "isRight"


viewIf : Bool -> Html msg -> Html msg
viewIf predicate html =
    if predicate then
        html

    else
        Html.text ""



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , update = update
        , init = always initialModel
        , subscriptions = always Sub.none
        }


find : Int -> List a -> Maybe a
find index items =
    List.foldl
        (\a ( b, currentIndex ) ->
            if currentIndex == index then
                ( Just a, currentIndex + 1 )

            else
                ( b, currentIndex + 1 )
        )
        ( Nothing, 0 )
        items
        |> Tuple.first
