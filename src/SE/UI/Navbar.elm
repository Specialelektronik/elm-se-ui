module SE.UI.Navbar exposing (Config, Item(..), Link, MegaItem, Model, Msg, defaultModel, update, view)

{-| A highly customized version of Bulmas navbar component

ribbon first/second
Brand
Search
Links
Dropdowns
LED On/Off

-}

import Css exposing (Style)
import Css.Global
import Css.Transitions
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import SE.UI.Colors as Colors exposing (active)
import SE.UI.Container as Container
import SE.UI.Control as Control
import SE.UI.Dropdown as Dropdown
import SE.UI.Font as Font
import SE.UI.Icon as Icon
import SE.UI.Level as Level
import SE.UI.Logo as Logo
import SE.UI.Utils as Utils


{-| Navbar config holds the static content that cannot change in the UI. Everything else needs to go in the model.

Ribbon: Takes to lists of links, the first one will be displayed left aligned and the second one right aligned.

-}
type alias Config msg =
    { ribbon : List (Link msg)
    , mainNav : List (Item msg)
    , megaNav : List (MegaItem msg)
    , socialMedia : List (SocialMedia msg)
    , transform : Msg -> msg
    }


type alias Model =
    { isOpen : Bool
    , activeDropdownId : String
    }


defaultModel : Model
defaultModel =
    { isOpen = False
    , activeDropdownId = ""
    }


type Item msg
    = LinkItem (Link msg)
    | DropdownItem (Dropdown msg)
    | CustomItem (List (Html msg))


type alias Link msg =
    { href : Attribute msg
    , label : String
    , icon : Maybe (Control.Size -> Html msg)
    }


type alias Dropdown msg =
    { label : String
    , items : List (Dropdown.Item msg)
    }


type alias MegaItem msg =
    { label : String
    , href : Html.Attribute msg
    , content : Html msg
    }


type alias SocialMedia msg =
    { url : String
    , icon : Control.Size -> Html msg
    }



-- UPDATE


type Msg
    = ToggledMenu
    | ClosedDropdown
    | ToggledDropdown String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggledMenu ->
            { model | isOpen = not model.isOpen }

        ClosedDropdown ->
            let
                _ =
                    Debug.log "Close Dropdown" ""
            in
            { model | activeDropdownId = "" }

        ToggledDropdown id ->
            let
                newId =
                    if model.activeDropdownId == id then
                        ""

                    else
                        id
            in
            { model | activeDropdownId = newId }


isMegaOpen : String -> Bool
isMegaOpen activeDropdownId =
    String.left 4 activeDropdownId == "mega"



-- VIEW


view : Config msg -> (List Style -> Html msg) -> Model -> Html msg
view config searchFn model =
    styled Html.header
        (navContainerStyles model.activeDropdownId)
        []
        [ global
        , backdrop config model
        , viewMobile config searchFn model
        , viewDesktop config searchFn model
        ]


navContainerStyles : String -> List Style
navContainerStyles activeDropdownId =
    [ Css.position Css.fixed
    , Css.top Css.zero
    , Css.zIndex (Css.int 40)
    , Css.boxShadow4 Css.zero (Css.px 2) (Css.px 10) (Colors.black |> Colors.mapAlpha (always 0.08) |> Colors.toCss)
    , Css.left Css.zero
    , Css.right Css.zero
    , if isMegaOpen activeDropdownId then
        Css.bottom Css.zero

      else
        Css.batch []
    , Css.Global.withClass "headroom"
        [ Css.property "will-change" "transform"
        , Css.Transitions.transition
            [ Css.Transitions.transform3 200 0 Css.Transitions.easeInOut
            ]
        ]
    , Css.Global.withClass "headroom--pinned"
        [ Css.transform (Css.translateY (Css.pct 0))
        ]
    , Css.Global.withClass "headroom--unpinned"
        [ Css.transform (Css.translateY (Css.pct -100))
        ]
    ]


backdrop : Config msg -> Model -> Html msg
backdrop config { activeDropdownId } =
    if isMegaOpen activeDropdownId then
        styled Html.div
            [ Colors.backgroundColor (Colors.black |> Colors.mapAlpha (always 0.7))
            , Css.position Css.absolute
            , Css.left Css.zero
            , Css.top Css.zero
            , Css.right Css.zero
            , Css.bottom Css.zero
            ]
            [ Events.onClick (config.transform ClosedDropdown) ]
            [ Css.Global.global
                [ Css.Global.html
                    [ Css.important (Css.overflow Css.hidden)
                    ]
                ]
            ]

    else
        Html.text ""



-- VIEW SEARCH


viewMobileSearch : (List Style -> Html msg) -> Html msg
viewMobileSearch searchFn =
    styled Html.div
        mobileSearchStyles
        []
        [ searchFn [] ]


mobileSearchStyles : List Style
mobileSearchStyles =
    [ Css.padding Css.zero
    , Colors.backgroundColor Colors.white
    ]


viewDesktopSearch : (List Style -> Html msg) -> Html msg
viewDesktopSearch searchFn =
    styled Html.div
        [ Css.flexGrow (Css.int 1)
        , Css.displayFlex
        , Css.alignItems Css.center
        , Css.marginLeft (Css.px 12)
        ]
        []
        [ searchFn [] ]



-- VIEW MOBILE NAV


viewMobile : Config msg -> (List Style -> Html msg) -> Model -> Html msg
viewMobile config searchFn model =
    styled Html.div
        [ globalDropdownOverrideStyles
        , Css.displayFlex
        , Css.flexDirection Css.column
        , Css.height (Css.px 118)
        , Utils.desktop
            [ Css.display Css.none
            ]
        ]
        [ Attributes.class "navbar-mobile" ]
        [ viewBrand config model.isOpen
        , viewLED
        , viewMobileSearch searchFn
        , viewMobileNav config model
        ]


viewMobileNav : Config msg -> Model -> Html msg
viewMobileNav config model =
    -- 1. Merge all item to one list
    List.map megaItemToItem config.megaNav
        ++ config.mainNav
        -- 2. Turn each item into Html
        |> List.indexedMap (viewMobileItem config model.activeDropdownId)
        |> (\htmls -> htmls ++ [ viewSocialMedia config.socialMedia ])
        -- 3. Insert into list item
        |> List.map (List.singleton >> Html.li [])
        |> Html.ul []
        |> List.singleton
        |> styled Html.nav mobileNavStyles [ Attributes.classList [ ( "is-open", model.isOpen ) ] ]


viewMobileItem : Config msg -> String -> Int -> Item msg -> Html msg
viewMobileItem =
    viewItem mobileBasicItemStyles


mobileBasicItemStyles : Bool -> List Style
mobileBasicItemStyles isActive =
    [ Colors.color Colors.text
    , Css.fontWeight Css.bold
    , Font.bodySizeRem -1
    , Css.padding (Css.rem 1)
    , Css.displayFlex
    , Css.justifyContent Css.spaceBetween
    , Css.borderBottom3 (Css.px 1) Css.solid (Colors.border |> Colors.toCss)
    , Css.position Css.relative
    ]


mobileNavStyles : List Style
mobileNavStyles =
    [ Colors.backgroundColor Colors.white
    , Css.Transitions.transition
        [ Css.Transitions.transform3 128 0 Css.Transitions.easeOut
        , Css.Transitions.opacity3 128 0 Css.Transitions.easeOut
        ]
    , Css.transform (Css.translateX (Css.pct 100))
    , Css.opacity Css.zero
    , Css.Global.withClass "is-open"
        [ Css.transform (Css.translateX Css.zero)
        , Css.opacity (Css.int 1)
        ]
    , Css.marginTop (Css.px -48)
    , Css.boxShadow5 Css.zero Css.zero (Css.px 10) (Css.px 0) (Colors.black |> Colors.mapAlpha (always 0.15) |> Colors.toCss)
    , Css.Global.descendants
        -- Override regular dropdown styles
        [ Css.Global.class "dropdown"
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.Global.children
                [ Css.Global.typeSelector "a"
                    [ Css.width (Css.pct 100)
                    ]

                -- dropdown content
                , Css.Global.typeSelector "div"
                    [ Css.position Css.relative
                    , Css.paddingTop Css.zero
                    , Css.important (Colors.backgroundColor Colors.background)
                    , Css.Global.children
                        -- dropdown row
                        [ Css.Global.typeSelector "div"
                            [ Colors.backgroundColor Colors.background
                            , Css.boxShadow Css.none
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]



-- VIEW SOCIAL MEDIA


viewSocialMedia : List (SocialMedia msg) -> Html msg
viewSocialMedia items =
    styled Html.nav
        [ Css.padding (Css.rem 1.33333333)
        , Css.displayFlex
        , Css.justifyContent Css.center
        , Css.flexGrow (Css.num 1)
        ]
        []
        (List.map viewSocialMediaItem items)


viewSocialMediaItem : SocialMedia msg -> Html msg
viewSocialMediaItem item =
    styled Html.a [ Colors.color Colors.darker ] [ Attributes.href item.url ] [ item.icon Control.Large ]



-- VIEW DESKTOP


viewDesktop : Config msg -> (List Style -> Html msg) -> Model -> Html msg
viewDesktop config searchFn model =
    styled Html.div
        [ Css.display Css.none
        , Colors.backgroundColor Colors.white
        , Css.position Css.relative
        , Utils.desktop
            [ Css.display Css.block
            ]
        ]
        [ Attributes.class "navbar-desktop" ]
        [ viewRibbon config.ribbon
        , styled Html.div
            [ Css.displayFlex
            , Css.maxWidth (Css.px 1920)
            , Css.margin2 Css.zero Css.auto
            , Css.padding2 Css.zero (Css.rem 2.66666667)
            ]
            []
            [ viewBrand config model.isOpen
            , viewDesktopSearch searchFn
            , viewMainNav config model
            ]
        , viewLED
        , viewMegaNav config model
        ]



-- VIEW RIBBON


viewRibbon : List (Link msg) -> Html msg
viewRibbon links =
    styled Html.div
        [ Colors.backgroundColor Colors.darkest ]
        []
        [ styled Html.nav
            ribbonStyles
            []
            (List.map (viewLinkHelper ribbonItemStyles) links)
        ]


ribbonStyles : List Style
ribbonStyles =
    [ Css.displayFlex
    , Css.justifyContent Css.flexEnd
    , Css.maxWidth (Css.px 1920)
    , Css.margin2 Css.zero Css.auto
    , Css.padding2 Css.zero (Css.rem 2.66666667)
    ]


ribbonItemStyles : List Style
ribbonItemStyles =
    [ Css.batch (desktopBasicItemStyles False)
    , Css.lineHeight (Css.num 2.66666667)
    , Font.bodySizeRem -3
    , Colors.color Colors.white
    , Css.hover
        [ Colors.color (Colors.white |> Colors.hover)
        ]
    ]



-- VIEW MAIN NAV


viewMainNav : Config msg -> Model -> Html msg
viewMainNav config model =
    styled Html.nav
        mainNavStyles
        []
        (List.indexedMap (viewDesktopItem config model.activeDropdownId) config.mainNav)


mainNavStyles : List Style
mainNavStyles =
    let
        linkStyles =
            [ Css.textTransform Css.uppercase
            , Colors.color Colors.text
            , Css.letterSpacing (Css.px 1)
            , Css.fontWeight Css.bold
            , Css.hover
                [ Colors.backgroundColor Colors.background
                , Colors.color Colors.primary
                ]
            ]
    in
    [ Css.displayFlex
    , Css.marginLeft (Css.px 12)
    , Css.Global.children
        [ Css.Global.typeSelector "a" linkStyles
        , Css.Global.selector ".dropdown"
            [ Css.Global.children [ Css.Global.typeSelector "a" linkStyles ]
            ]
        ]
    ]



-- VIEW DESKTOP ITEM


viewDesktopItem : Config msg -> String -> Int -> Item msg -> Html msg
viewDesktopItem =
    viewItem desktopBasicItemStyles


desktopBasicItemStyles : Bool -> List Style
desktopBasicItemStyles isActive =
    [ Css.paddingLeft (Css.px 12)
    , Css.paddingRight (Css.px 12)
    , Css.displayFlex
    , Css.alignItems Css.center
    ]



-- VIEW MEGA NAV


viewMegaNav : Config msg -> Model -> Html msg
viewMegaNav config model =
    styled Html.nav
        [ Colors.backgroundColor Colors.white
        , Css.borderBottom3 (Css.px 1) Css.solid (Colors.border |> Colors.toCss)
        , Css.flexGrow (Css.int 1)
        ]
        []
        [ Container.container []
            [ styled Html.ul
                [ Css.displayFlex ]
                []
                (List.indexedMap (viewMegaItem config model) config.megaNav)
            ]
        ]


viewMegaItem : Config msg -> Model -> Int -> MegaItem msg -> Html msg
viewMegaItem config model index item =
    let
        id =
            "megaNav-" ++ String.fromInt index

        isActive =
            id == model.activeDropdownId

        icon =
            if isActive then
                Icon.angleUp

            else
                Icon.angleDown
    in
    styled Html.li
        []
        []
        [ styled Html.div
            megaItemStyles
            [ Events.onClick (config.transform (ToggledDropdown id)) ]
            [ Html.span [] [ Html.text item.label ]
            , icon Control.Small
            ]
        , styled Html.div
            [ Css.pseudoClass "not([hidden])"
                [ Css.position Css.absolute
                , Css.left Css.zero
                , Css.right Css.zero
                , Colors.backgroundColor Colors.white
                , Css.padding (Css.rem 1.33333333)
                , Css.justifyContent Css.spaceBetween
                , Css.borderBottomLeftRadius Utils.radius
                , Css.borderBottomRightRadius Utils.radius
                ]
            ]
            [ Attributes.hidden (not isActive) ]
            [ item.content
            , Html.div [] [ Html.a [ item.href ] [ Html.text ("Visa allt i " ++ item.label) ] ]
            ]
        ]


megaItemStyles : List Style
megaItemStyles =
    [ Css.displayFlex
    , Font.bodySizeRem -2
    , Css.cursor Css.pointer
    , Css.padding2 (Css.px 14) (Css.px 14)
    , Css.textTransform Css.uppercase
    , Colors.color Colors.text
    , Css.letterSpacing (Css.px 1)
    , Css.fontWeight Css.bold
    , Css.hover
        [ Colors.backgroundColor Colors.background
        , Colors.color Colors.primary
        ]
    ]



-- VIEW BRAND


brandHeight =
    Css.px 75


viewBrand : Config msg -> Bool -> Html msg
viewBrand config isOpen =
    styled Html.div
        brandStyles
        [ Attributes.classList [ ( "navbar-brand", True ), ( "is-open", isOpen ) ] ]
        [ styled Html.a
            []
            [ Attributes.href "/" ]
            [ if isOpen then
                Logo.onBlack

              else
                Logo.onWhite
            ]
        , navbarBurger (config.transform ToggledMenu) isOpen
        ]


navbarBurger : msg -> Bool -> Html msg
navbarBurger toggledMenuMsg isOpen =
    styled Html.label
        [ Colors.color Colors.white
        , Colors.backgroundColor Colors.darker
        , Css.cursor Css.pointer
        , Css.display Css.block
        , Css.height (Css.px 75)
        , Css.position Css.relative
        , Css.width (Css.px 75)
        , Css.hover
            [ Colors.backgroundColor (Colors.darker |> Colors.hover)
            ]
        , Css.Global.descendants
            [ Css.Global.typeSelector "span"
                [ Css.backgroundColor Css.currentColor
                , Css.display Css.block
                , Css.height (Css.px 2)
                , Css.left (Css.calc (Css.pct 50) Css.minus (Css.px 12))
                , Css.position Css.absolute
                , Css.Transitions.transition
                    [ Css.Transitions.backgroundColor3 128 0 Css.Transitions.easeOut
                    , Css.Transitions.opacity3 128 0 Css.Transitions.easeOut
                    , Css.Transitions.transform3 128 0 Css.Transitions.easeOut
                    ]
                , Css.width (Css.px 24)
                , Css.nthChild "1"
                    [ Css.top (Css.calc (Css.pct 50) Css.minus (Css.px 8))
                    ]
                , Css.nthChild "2"
                    [ Css.top (Css.calc (Css.pct 50) Css.minus (Css.px 1))
                    ]
                , Css.nthChild "3"
                    [ Css.top (Css.calc (Css.pct 50) Css.plus (Css.px 6))
                    ]
                , Css.batch
                    (if isOpen then
                        [ Css.nthChild "1"
                            [ Css.transforms [ Css.translateY (Css.px 7), Css.rotate (Css.deg 45) ]
                            ]
                        , Css.nthChild "2"
                            [ Css.opacity Css.zero
                            ]
                        , Css.nthChild "3"
                            [ Css.transforms [ Css.translateY (Css.px -7), Css.rotate (Css.deg -45) ]
                            ]
                        ]

                     else
                        []
                    )
                ]
            ]
        , Utils.desktop
            [ Css.display Css.none
            ]
        ]
        [ Attributes.for "menu", Attributes.attribute "role" "button", Attributes.attribute "aria-label" "menu", Events.onClick toggledMenuMsg ]
        [ Html.span [ Attributes.attribute "aria-hidden" "true" ] []
        , Html.span [ Attributes.attribute "aria-hidden" "true" ] []
        , Html.span [ Attributes.attribute "aria-hidden" "true" ] []
        ]


brandStyles : List Style
brandStyles =
    [ Css.alignItems Css.stretch
    , Css.displayFlex
    , Css.flexShrink Css.zero
    , Css.minHeight brandHeight
    , Css.justifyContent Css.spaceBetween
    , Css.alignItems Css.center
    , Colors.backgroundColor Colors.white
    , Css.Transitions.transition
        [ Css.Transitions.backgroundColor3 128 0 Css.Transitions.easeOut
        ]
    , Css.Global.withClass "is-open"
        [ Colors.backgroundColor Colors.darker
        ]
    , Css.Global.descendants
        [ Css.Global.typeSelector "svg"
            [ Css.height (Css.px 40)
            , Css.margin2 (Css.px 12) (Css.px 12)
            ]
        ]
    ]



-- VIEW DROPDOWN


viewDropdownButton : List Style -> Config msg -> Bool -> String -> String -> Html msg
viewDropdownButton styles config isActive id label =
    let
        icon =
            if isActive then
                Icon.angleUp

            else
                Icon.angleDown
    in
    styled Html.a
        styles
        [ Events.onClick (config.transform (ToggledDropdown id)) ]
        [ Html.span [] [ Html.text label ], icon Control.Small ]



-- VIEW LED


ledHeight =
    Css.px 3


viewLED : Html msg
viewLED =
    styled Html.div
        [ Colors.backgroundColor Colors.primary
        , Css.height (Css.px 3)
        , Css.flexShrink Css.zero
        ]
        []
        []



-- VIEW ITEMS


viewItem : (Bool -> List Style) -> Config msg -> String -> Int -> Item msg -> Html msg
viewItem itemStyles config activeDropdownId index item =
    case item of
        LinkItem link ->
            viewLinkHelper (itemStyles False) link

        DropdownItem rec ->
            let
                id =
                    "mobileNav-" ++ String.fromInt index

                isActive =
                    id == activeDropdownId
            in
            Dropdown.dropdown
                id
                (config.transform ClosedDropdown)
                isActive
                (Dropdown.customButton (viewDropdownButton (itemStyles isActive) config isActive id rec.label))
                rec.items

        CustomItem kids ->
            styled Html.div
                [ Css.position Css.relative
                , Css.displayFlex
                , Css.alignItems Css.center
                , Css.marginLeft (Css.px 12)
                , Css.marginRight (Css.px 12)
                ]
                []
                kids


viewLinkHelper : List Style -> Link msg -> Html msg
viewLinkHelper styles link =
    let
        icon =
            case link.icon of
                Nothing ->
                    Html.text ""

                Just i ->
                    i Control.Regular
    in
    styled Html.a
        styles
        [ link.href ]
        [ icon, Html.span [] [ Html.text link.label ] ]



-- GLOBAL


global : Html msg
global =
    Css.Global.global
        [ Css.Global.body
            [ Css.marginTop
                (Css.calc brandHeight Css.plus ledHeight)
            ]

        -- , Css.Global.html
        --     [ if model.isOpen then
        --         Css.important (Css.overflow Css.hidden)
        --       else
        --         Css.batch []
        --     ]
        ]


globalDropdownOverrideStyles : Style
globalDropdownOverrideStyles =
    Utils.tablet
        [ Css.Global.descendants
            -- Override regular dropdown styles
            [ Css.Global.class "dropdown"
                [ Css.displayFlex
                , Css.flexDirection Css.column
                , Css.Global.children
                    [ Css.Global.typeSelector "a"
                        [ Css.width (Css.pct 100)
                        ]

                    -- dropdown content
                    , Css.Global.typeSelector "div"
                        [ Css.position Css.relative
                        , Css.paddingTop Css.zero
                        , Css.important (Colors.backgroundColor Colors.background)
                        , Css.Global.children
                            -- dropdown row
                            [ Css.Global.typeSelector "div"
                                [ Colors.backgroundColor Colors.background
                                , Css.boxShadow Css.none
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]



-- TRANSFORMATIONS


megaItemToItem : MegaItem msg -> Item msg
megaItemToItem { label, href } =
    LinkItem
        { href = href
        , label = label
        , icon = Nothing
        }
