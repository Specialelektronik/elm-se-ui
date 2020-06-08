module SE.UI.Navbar exposing (Config, Item(..), Link, MegaItem, Model, Msg, backdrop, defaultModel, update, view)

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
import SE.UI.Colors as Colors
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



-- VIEW


view : Config msg -> (List Style -> Html msg) -> Model -> Html msg
view config searchFn model =
    let
        global =
            Css.Global.global
                [ Css.Global.body
                    [ Css.marginTop (Css.px (75 + 3 + 51)) -- 75px brand, 3px LED, 40px search bar
                    ]
                , Css.Global.html
                    [ if model.isOpen then
                        Css.important (Css.overflow Css.hidden)

                      else
                        Css.batch []
                    ]
                ]
    in
    styled Html.header
        (headerStyles model.isOpen)
        []
        [ global
        , viewBrand config model.isOpen
        , viewLED
        , viewSearch searchFn
        , viewMegaNav config model
        , viewMainNav config model
        , viewRibbon config.ribbon model.isOpen
        , viewSocialMedia config.socialMedia model.isOpen
        ]


viewMainNav : Config msg -> Model -> Html msg
viewMainNav config model =
    styled Html.nav
        (menuBlockStyles
            ++ [ Css.order (Css.int 5)
               , Colors.backgroundColor Colors.white
               , Utils.desktop [ Css.order (Css.int 4) ]
               ]
        )
        [ Attributes.classList [ ( "is-open", model.isOpen ) ] ]
        [ Html.ul
            []
            (List.indexedMap (viewItem mainItemStyles config model.activeDropdownId) config.mainNav)
        ]


backdrop : Config msg -> Model -> Html msg
backdrop config { activeDropdownId } =
    if String.left 4 activeDropdownId == "mega" then
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


viewMegaNav : Config msg -> Model -> Html msg
viewMegaNav config model =
    styled Html.nav
        (menuBlockStyles
            ++ [ Css.order (Css.int 4)
               , Colors.backgroundColor Colors.white
               , Utils.desktop
                    [ Css.order (Css.int 6)
                    , Css.flexGrow (Css.int 1)
                    ]
               ]
        )
        [ Attributes.classList [ ( "is-open", model.isOpen ) ] ]
        [ Container.container []
            [ Html.ul
                []
                (List.indexedMap (viewMegaItem mainItemStyles config model) config.megaNav)
            ]
        ]


viewRibbon : List (Link msg) -> Bool -> Html msg
viewRibbon links isOpen =
    styled Html.nav
        (ribbonStyles
            ++ menuBlockStyles
            ++ [ Utils.desktop
                    [ Css.order (Css.int 1)
                    , Css.width (Css.pct 100)
                    , Css.flexShrink (Css.int 0)
                    ]
               ]
        )
        [ Attributes.classList [ ( "is-open", isOpen ) ] ]
        [ Html.ul [] (List.map (viewLinkHelper ribbonItemStyles >> List.singleton >> Html.li []) links) ]


viewSocialMedia : List (SocialMedia msg) -> Bool -> Html msg
viewSocialMedia items isOpen =
    styled Html.nav
        (menuBlockStyles
            ++ hiddenDesktop
            ++ [ Css.padding (Css.rem 1.33333333), Css.displayFlex, Css.justifyContent Css.center, Css.order (Css.int 6), Css.flexGrow (Css.num 1) ]
        )
        [ Attributes.classList [ ( "is-open", isOpen ) ] ]
        (List.map viewSocialMediaItem items)


viewSocialMediaItem : SocialMedia msg -> Html msg
viewSocialMediaItem item =
    styled Html.a [ Colors.color Colors.darker ] [ Attributes.href item.url ] [ item.icon Control.Large ]


linkToLevelItem link =
    Level.item
        [ viewLinkHelper
            [ Font.bodySizeEm -2
            , Css.padding2 (Css.em 0.6) (Css.em 0.66666667)
            , Css.displayFlex
            , Css.alignItems Css.center
            ]
            link
        ]


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


viewBrand : Config msg -> Bool -> Html msg
viewBrand config isOpen =
    styled Html.div
        brandStyles
        [ Attributes.classList [ ( "is-open", isOpen ) ] ]
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


viewLED : Html msg
viewLED =
    styled Html.div
        [ Colors.backgroundColor Colors.primary
        , Css.height (Css.px 3)
        , Css.order (Css.int 2)
        , Css.flexShrink (Css.int 0)
        , Utils.desktop
            [ Css.order (Css.int 5)
            , Css.width (Css.pct 100)
            ]
        ]
        []
        []


viewSearch : (List Style -> Html msg) -> Html msg
viewSearch searchFn =
    styled Html.div
        searchStyles
        []
        [ searchFn [] ]



-- VIEW MENU
-- viewMenu : Bool -> List (Html msg) -> List (Html msg) -> Html msg
-- viewMenu isOpen startItems endItems =
--     styled Html.div
--         (menuStyles isOpen)
--         [ Attributes.class "menu" ]
--         [ styled Html.div startStyles [ Attributes.class "start" ] startItems
--         , styled Html.div endStyles [ Attributes.class "end" ] endItems
--         ]


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


searchStyles : List Style
searchStyles =
    [ Css.batch baseItemStyles
    , Css.padding Css.zero
    , Css.order (Css.int 3)
    , Colors.backgroundColor Colors.white
    , Utils.desktop
        [ Css.order (Css.int 3)
        , Css.flexGrow (Css.int 1)
        ]
    ]



-- VIEW ITEMS
-- viewItems : Config msg -> String -> List (Item msg) -> List (Html msg)
-- viewItems config activeId items =
--     List.indexedMap (viewItem config activeId) items


viewItem : (Bool -> List Style) -> Config msg -> String -> Int -> Item msg -> Html msg
viewItem styles config activeId index item =
    Html.li []
        [ case item of
            LinkItem link ->
                viewLinkHelper (styles False) link

            DropdownItem rec ->
                let
                    id =
                        "mainNav-" ++ String.fromInt index

                    isActive =
                        id == activeId
                in
                Dropdown.dropdown
                    id
                    (config.transform ClosedDropdown)
                    isActive
                    (Dropdown.customButton (viewDropdownButton (styles isActive) config isActive id rec.label))
                    rec.items

            CustomItem kids ->
                styled Html.div baseItemStyles [] kids
        ]


viewMegaItem : (Bool -> List Style) -> Config msg -> Model -> Int -> MegaItem msg -> Html msg
viewMegaItem styles config model index item =
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

        element =
            if model.isOpen then
                styled Html.a
                    (styles isActive)
                    [ item.href ]
                    [ Html.text item.label
                    ]

            else
                styled Html.div
                    (styles isActive)
                    [ Events.onClick (config.transform (ToggledDropdown id)) ]
                    [ Html.span [] [ Html.text item.label ]
                    , icon Control.Small
                    ]
    in
    styled Html.li
        [ Utils.desktop [ Css.displayFlex ] ]
        []
        [ element
        , styled Html.div
            [ Css.pseudoClass "not([hidden])"
                [ Css.position Css.absolute
                , Css.left Css.zero
                , Css.right Css.zero
                , Colors.backgroundColor Colors.white
                , Css.padding (Css.rem 1.33333333)
                , Css.marginTop (Css.px 48)
                , Css.justifyContent Css.spaceBetween
                ]
            ]
            [ Attributes.hidden (not isActive) ]
            [ item.content
            , Html.div [] [ Html.a [ item.href ] [ Html.text ("Visa allt i " ++ item.label) ] ]
            ]
        ]


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



-- STYLES
-- HEADER STYLES


headerStyles : Bool -> List Style
headerStyles isOpen =
    [ Css.position Css.fixed
    , Css.top Css.zero
    , Css.width (Css.pct 100)
    , Css.zIndex (Css.int 10)
    , Css.displayFlex
    , Css.maxWidth (Css.pct 100)
    , Css.height (Css.px (75 + 3 + 51))
    , Css.flexDirection Css.column
    , Utils.mobile
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
    , Utils.desktop
        [ Css.flexDirection Css.row
        , Css.flexWrap Css.wrap
        , Css.important (Css.height Css.auto)
        , Css.Global.descendants
            [ Css.Global.typeSelector "nav"
                [ Css.Global.children
                    [ Css.Global.typeSelector "ul"
                        [ Css.displayFlex
                        , Css.height (Css.pct 100)
                        , Css.Global.children
                            [ Css.Global.typeSelector "li"
                                [ Css.displayFlex
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    , Css.batch
        (if isOpen then
            [ Css.height (Css.vh 100)
            , Colors.backgroundColor Colors.white
            , Css.overflowX Css.auto
            ]

         else
            []
        )
    ]


ribbonStyles : List Style
ribbonStyles =
    [ Css.order (Css.int 5)
    , Utils.desktop
        [ Css.order (Css.int 1)
        , Css.display Css.block
        , Colors.backgroundColor Colors.darkest
        , Css.Global.descendants
            [ Css.Global.typeSelector
                "ul"
                [ Css.justifyContent Css.flexEnd
                ]
            ]
        ]
    ]



-- navbarStyles : List Style
-- navbarStyles =
--     [ Css.minHeight (Css.px 75)
--     , Css.position Css.relative
--     , Css.zIndex (Css.int 30)
--     , Utils.desktop
--         [ Css.alignItems Css.stretch
--         , Css.displayFlex
--         ]
--     ]


brandStyles : List Style
brandStyles =
    [ Css.alignItems Css.stretch
    , Css.displayFlex
    , Css.flexShrink Css.zero
    , Css.minHeight (Css.px 75)
    , Css.justifyContent Css.spaceBetween
    , Css.alignItems Css.center
    , Css.lineHeight (Css.num 1.5)
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
    , Css.order (Css.int 1)
    , Utils.desktop
        [ Css.order (Css.int 2)
        ]
    ]



-- MENU STYLES
-- menuStyles : Bool -> List Style
-- menuStyles isOpen =
--     let
--         displayState =
--             if not isOpen then
--                 "none"
--             else
--                 "block"
--     in
--     [ Css.property "display" displayState
--     , Utils.desktop
--         [ Css.alignItems Css.stretch
--         , Css.displayFlex
--         , Css.flexGrow (Css.int 1)
--         , Css.flexShrink Css.zero
--         ]
--     , Utils.mobile
--         [ Css.Global.descendants
--             [ Css.Global.class "dropdown"
--                 [ Css.displayFlex
--                 , Css.justifyContent Css.spaceBetween
--                 , Css.Global.children
--                     [ Css.Global.typeSelector "div"
--                         []
--                     ]
--                 ]
--             ]
--         ]
--     ]
-- startStyles : List Style
-- startStyles =
--     [ Utils.desktop
--         [ Css.alignItems Css.stretch
--         , Css.displayFlex
--         , Css.justifyContent Css.flexStart
--         , Css.marginRight Css.auto
--         , Css.flexGrow (Css.int 1)
--         ]
--     ]
-- endStyles : List Style
-- endStyles =
--     [ Utils.desktop
--         [ Css.alignItems Css.stretch
--         , Css.displayFlex
--         , Css.justifyContent Css.flexEnd
--         , Css.marginLeft Css.auto
--         ]
--     ]
-- ITEM STYLES


itemAndLinkStyles : List Style
itemAndLinkStyles =
    [ Colors.color Colors.text
    , Css.displayFlex
    , Css.justifyContent Css.spaceBetween
    , Css.alignItems Css.center
    , Css.lineHeight (Css.num 1.5)
    , Css.padding2 (Css.px 12) (Css.px 12)
    , Css.position Css.relative
    , Font.bodySizeRem -2
    , Utils.mobile
        [ Css.width (Css.pct 100)
        , Css.border3 (Css.px 1) Css.solid (Colors.border |> Colors.toCss)
        ]
    , Css.Global.descendants
        [ Css.Global.selector ".icon:only-child"
            [ Css.marginLeft (Css.rem -0.25)
            , Css.marginRight (Css.rem -0.25)
            ]
        , Css.Global.typeSelector "svg"
            [ Css.height (Css.px 40)
            ]
        ]
    ]


baseItemStyles : List Style
baseItemStyles =
    [ Css.displayFlex
    , Css.justifyContent Css.spaceBetween
    , Css.alignItems Css.center
    , Css.lineHeight (Css.num 1.5)
    , Css.padding (Css.px 12)
    , Css.position Css.relative
    , Css.borderBottom3 (Css.px 1) Css.solid (Colors.border |> Colors.toCss)
    , Utils.desktop
        [ Css.borderBottom Css.zero
        ]
    , Css.Global.descendants
        [ Css.Global.selector ".icon:only-child"
            [ Css.marginLeft (Css.rem -0.25)
            , Css.marginRight (Css.rem -0.25)
            ]
        , Css.Global.typeSelector "svg"
            [ Css.height (Css.px 40)
            ]
        ]
    ]


ribbonItemStyles : List Style
ribbonItemStyles =
    [ Css.batch baseItemStyles
    , Css.paddingTop (Css.px 12)
    , Css.paddingBottom (Css.px 12)
    , Css.fontWeight Css.bold
    , Colors.color Colors.text
    , Utils.desktop
        [ Css.important (Css.letterSpacing (Css.px 0))
        , Css.important (Css.textTransform Css.none)
        , Css.fontWeight Css.normal
        , Colors.color Colors.white
        , Css.hover
            [ Colors.color (Colors.white |> Colors.hover)
            ]
        ]
    , Utils.desktop
        [ Font.bodySizeRem -3
        ]
    ]


itemStyles : List Style
itemStyles =
    [ Css.flexGrow Css.zero
    , Css.flexShrink Css.zero
    ]


mainItemStyles : Bool -> List Style
mainItemStyles isActive =
    [ Css.batch baseItemStyles
    , Css.cursor Css.pointer
    , Css.fontWeight Css.bold
    , Colors.color Colors.text
    , Utils.desktop
        [ Css.letterSpacing (Css.px 1)
        , Css.textTransform Css.uppercase
        , Css.borderBottom Css.zero
        ]
    , Css.focus
        [ Colors.backgroundColor Colors.background
        , Colors.color Colors.primary
        ]
    , Css.pseudoClass "focus-within"
        [ Colors.backgroundColor Colors.background
        , Colors.color Colors.primary
        ]
    , Css.hover
        [ Colors.backgroundColor Colors.background
        , Colors.color Colors.primary
        ]
    , Css.batch
        (if isActive then
            [ Colors.backgroundColor Colors.background
            , Colors.color Colors.primary
            ]

         else
            []
        )
    ]


blockStyles : List Style
blockStyles =
    [ Colors.backgroundColor Colors.background
    , Css.padding (Css.rem 0.75)
    ]


menuBlockStyles : List Style
menuBlockStyles =
    [ Css.Transitions.transition
        [ Css.Transitions.transform3 128 0 Css.Transitions.easeOut
        ]
    , Css.transform (Css.translateX (Css.pct 100))
    , Css.Global.withClass "is-open"
        [ Css.transform (Css.translateX Css.zero)
        ]
    , Css.firstOfType
        [ Css.marginTop (Css.px -48)
        ]

    -- Remove mobile design
    , Utils.desktop
        [ Css.Transitions.transition []
        , Css.transform Css.none
        , Css.firstOfType
            [ Css.marginTop Css.zero
            ]
        ]
    ]


hiddenDesktop : List Style
hiddenDesktop =
    [ Utils.desktop
        [ Css.display Css.none
        ]
    ]
