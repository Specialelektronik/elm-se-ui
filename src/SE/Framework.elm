module SE.Framework exposing (main)

import Browser
import Css exposing (absolute, block, calc, column, em, fixed, hover, int, minus, px, relative, rem, rgba, vh, zero)
import Html.Styled as Html exposing (Html, a, article, aside, div, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes as Attributes exposing (align, colspan, href, id)
import Html.Styled.Events as Events
import SE.Framework.Buttons as Buttons
import SE.Framework.Colors as Colors
import SE.Framework.Columns as Columns
import SE.Framework.Container as Container
import SE.Framework.Content as Content
import SE.Framework.Control as Control
import SE.Framework.Date as Date
import SE.Framework.Form as Form
import SE.Framework.Icon as Icon
import SE.Framework.Image as Image
import SE.Framework.Logo as Logo
import SE.Framework.Logos.Crestron as Crestron
import SE.Framework.Logos.Dante as Dante
import SE.Framework.Section exposing (section)
import SE.Framework.Table as Table
import SE.Framework.Tag as Tag
import SE.Framework.Title as Title
import SE.Framework.Utils as Utils exposing (radius, smallRadius)



-- MODEL


type alias Model =
    { count : Int
    , date : String
    }


initialModel : Model
initialModel =
    { count = 1, date = "" }



-- UPDATE


type Msg
    = NoOp
    | CountSet String
    | EnteredDate String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        CountSet newCountString ->
            let
                newCount =
                    Maybe.withDefault model.count (String.toInt newCountString)
            in
            { model | count = newCount }

        EnteredDate d ->
            { model | date = d }



-- VIEW


view model =
    Html.input [ Attributes.value model.date, Events.onInput EnteredDate, Attributes.pattern "(?:19|20)(?:(?:[13579][26]|[02468][048])-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))|(?:[0-9]{2}-(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:29|30))|(?:(?:0[13578]|1[02])-31)))" ] []


views : Model -> Html Msg
views model =
    styled div
        [ Css.displayFlex ]
        []
        [ viewSidebar
        , styled main_
            [ Css.flexGrow (int 1) ]
            []
            [ --     article [ id "Buttons" ]
              --     [ section []
              --         [ Container.container []
              --             [ viewProduct ]
              --         ]
              --     ]
              -- ,
              article [ id "Checkout" ]
                [ section []
                    [ Container.container []
                        [ viewCheckout model ]
                    ]
                ]
            ]
        ]


viewCheckout : Model -> Html Msg
viewCheckout model =
    div []
        [ Title.title1 "Varukorg"
        , Columns.columns
            [ Columns.defaultColumn
                [ Table.table [ Table.Fullwidth, Table.Narrow ]
                    (Table.head
                        [ Table.cell [ colspan 2 ] (text "Produkt")
                        , Table.rightCell [] (text "Antal och pris")
                        , Table.rightCell [] (text "Totalpris")
                        , Table.rightCell [] (text "")
                        ]
                    )
                    (Table.foot
                        []
                    )
                    (Table.body
                        [ Table.row
                            [ Table.cell [ Attributes.width 150 ]
                                (Image.image ( 150, 150 )
                                    [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN.jpg" 1
                                    ]
                                )
                            , Table.cell []
                                (div []
                                    [ Html.p [] [ Html.strong [] [ text "Samsung QM75N UHD" ] ]
                                    , Html.p [] [ text "LH75QMREBGCXEN" ]
                                    ]
                                )
                            , Table.rightCell []
                                (Form.field [ Form.Attached ]
                                    [ Form.expandedControl False
                                        [ Form.number
                                            { value = String.fromInt model.count
                                            , placeholder = "Antal"
                                            , modifiers = []
                                            , onInput = CountSet
                                            , range = ( 1, 100 )
                                            , step = 1
                                            }
                                        ]
                                    , Form.control False
                                        [ Buttons.staticButton [] [ text "st" ]
                                        ]
                                    ]
                                )
                            , Table.rightCell [] (text <| String.fromInt (23951 * model.count))
                            , Table.rightCell [] (Icon.trash Icon.Regular)
                            ]
                        , Table.row
                            [ Table.cell [ Attributes.width 150 ]
                                (Image.image ( 150, 150 )
                                    [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN.jpg" 1
                                    ]
                                )
                            , Table.cell []
                                (div []
                                    [ Html.p [] [ Html.strong [] [ text "Samsung QM75N UHD" ] ]
                                    , Html.p [] [ text "LH75QMREBGCXEN" ]
                                    ]
                                )
                            , Table.rightCell []
                                (Form.field [ Form.Attached ]
                                    [ Form.expandedControl False
                                        [ Form.number
                                            { value = String.fromInt model.count
                                            , placeholder = "Antal"
                                            , modifiers = []
                                            , onInput = CountSet
                                            , range = ( 1, 100 )
                                            , step = 1
                                            }
                                        ]
                                    , Form.control False
                                        [ Buttons.staticButton [] [ text "st" ]
                                        ]
                                    ]
                                )
                            , Table.rightCell [] (text <| String.fromInt (23951 * model.count))
                            , Table.rightCell [] (Icon.trash Icon.Regular)
                            ]
                        ]
                    )
                ]
            , Columns.defaultColumn
                [ styled div
                    [ Css.backgroundColor Colors.black
                    , Css.color Colors.white
                    ]
                    []
                    [ Title.title3 "Sammanställning"
                    , Table.table []
                        (Table.head [])
                        (Table.foot [])
                        (Table.body
                            [ Table.row
                                [ Table.cell [] (text "one row")
                                ]
                            ]
                        )
                    ]
                ]
            ]
        ]


viewProduct : Html Msg
viewProduct =
    div []
        [ Columns.columns
            [ Columns.column []
                [ Columns.columns
                    [ Columns.column [ ( Columns.All, Columns.Narrow ) ]
                        [ Image.image ( 100, 100 )
                            [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN.jpg" 1
                            ]
                        , Image.image ( 100, 100 )
                            [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN_img2.jpg" 1
                            ]
                        , Image.image ( 100, 100 )
                            [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN_img3.jpg" 1
                            ]
                        , Image.image ( 100, 100 )
                            [ Image.source "video.c0ff7e88.jpg" 1
                            ]
                        ]
                    , Columns.defaultColumn
                        [ Image.image ( 1000, 667 )
                            [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN.jpg" 1
                            ]
                        ]
                    ]
                ]
            , Columns.column [ ( Columns.Extended, Columns.OneThird ) ]
                [ Title.title1 "Samsung QM75N UHD"
                , Table.table [ Table.Fullwidth, Table.Hoverable ]
                    (Table.head [])
                    (Table.foot [])
                    (Table.body
                        [ Table.row
                            [ Table.cell []
                                (Tag.tags
                                    [ Tag.Addons ]
                                    [ Tag.tag [ Tag.Darkest ] "Lagerstatus"
                                    , Tag.tag [ Tag.Success ] "10+"
                                    ]
                                )
                            , Table.cell [] (text "15 st fler förväntas sändningsklara 24 maj")
                            ]
                        , Table.row
                            [ Table.cell [] (Html.strong [] [ text "Artikelnummer" ])
                            , Table.cell [] (text "LH75QMREBGCXEN")
                            ]
                        , Table.row
                            [ Table.cell [] (Html.strong [] [ text "Tillverkarens artikelnummer" ])
                            , Table.cell [] (text "LH75QMREBGCXEN")
                            ]
                        , Table.row
                            [ Table.cell [] (Html.strong [] [ text "E-nummer" ])
                            , Table.cell [] (text "Endast vid E-nummer.")
                            ]
                        ]
                    )
                , Form.field []
                    [ a [ href "https://specialelektronik.se/dokument/produktblad/LH75QMREBGCXEN.pdf" ]
                        [ Icon.pdf Icon.Regular
                        , Html.strong
                            []
                            [ text "Produktblad" ]
                        ]
                    ]
                , Buttons.buttons []
                    [ Buttons.button [ Buttons.Link ] (Just NoOp) [ text "75\"" ]
                    , Buttons.button [] (Just NoOp) [ text "55\"" ]
                    ]
                , viewBidPrices
                , viewPrice 23951 31935 164
                , Columns.columns
                    [ Columns.defaultColumn
                        [ Form.field [ Form.Attached ]
                            [ Form.expandedControl False
                                [ Form.input
                                    { value = ""
                                    , placeholder = "Ange antal"
                                    , modifiers = [ Form.Size Control.Large ]
                                    , onInput = \_ -> NoOp
                                    }
                                ]
                            , Form.control False
                                [ Buttons.staticButton [ Buttons.Size Control.Large ] [ text "st" ]
                                ]
                            ]
                        ]
                    , Columns.defaultColumn
                        [ Form.field
                            []
                            [ Buttons.button [ Buttons.CallToAction, Buttons.Fullwidth, Buttons.Size Control.Large ]
                                (Just NoOp)
                                [ Icon.cart Icon.Medium
                                , span [] [ text "Lägg i varukorg" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , Columns.columns
            [ Columns.defaultColumn
                [ Table.table [ Table.Hoverable ]
                    (Table.head [])
                    (Table.foot [])
                    (Table.body
                        [ Table.row
                            [ Table.cell [] (Html.strong [] [ text "Storlek" ])
                            , Table.cell [] (text "75\"")
                            ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Typ" ]), Table.cell [] (text "E-LED") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Upplösning" ]), Table.cell [] (text "3840*2160 (4K UHD)") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Active Display Area(mm)" ]), Table.cell [] (text "1650.24 (H) x 928.26 (V)") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Ljusstyrka" ]), Table.cell [] (text "500 nits") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Kontrastratio" ]), Table.cell [] (text "6000:1") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Betraktningsvinkel (H/V)" ]), Table.cell [] (text "178/178") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Responstid" ]), Table.cell [] (text "8ms") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Display Colors" ]), Table.cell [] (text "16.7M(True Display) 1.07B(Ditherd 10bit)") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Color Gamut" ]), Table.cell [] (text "92% (DCI-P3, CIE 1976)") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Operation Hour" ]), Table.cell [] (text "24/7") ]
                        , Table.row [ Table.cell [] (Html.strong [] [ text "Haze" ]), Table.cell [] (text "44%") ]
                        ]
                    )
                ]
            , Columns.column [ ( Columns.Extended, Columns.TwoThirds ) ]
                [ Content.content []
                    [ Html.p [] [ text "Display any content in ultra-high definition with incredibly rich color on slim, efficient signage." ]
                    , ul []
                        [ li [] [ text "Engage customers with lifelike images through ultra high-definition resolution" ]
                        , li [] [ text "Deliver UHD-level picture quality even with lower resolution content through innovative UHD upscaling technology and unique picture-enhancing features" ]
                        , li [] [ text "Dynamic Crystal Color allows viewers to enjoy a wider spectrum of colors, up to one billion shades" ]
                        ]
                    ]
                , Title.title1 "Title 1"
                , Title.title2 "Title 2"
                , Title.title3 "Title 3"
                , Title.title4 "Title 4"
                , Title.title5 "Title 5"
                , Title.title6 "Title 6"
                ]
            ]
        ]


viewBidPrices : Html Msg
viewBidPrices =
    styled div
        [ Utils.block
        , Css.textAlign Css.right
        , Css.padding2 (em 1.25) (em 1.5)
        , Css.backgroundColor (Css.hsla 36 0.4 0.98 1)
        , Css.borderLeft3 (px 4) Css.solid Colors.callToAction
        , Css.borderRadius radius
        , Css.position relative
        ]
        []
        [ styled span
            [ Css.position absolute
            , Css.top (em 1.25)
            , Css.right (em 1.5)
            , Css.color Colors.callToAction
            ]
            []
            [ Icon.bid Icon.Regular ]
        , Table.table [ Table.Fullwidth ]
            (Table.head [ Table.cell [ colspan 3 ] (Title.title5 "BID-priser") ])
            (Table.foot [])
            (Table.body
                [ Table.row
                    [ Table.cell []
                        (Html.p []
                            [ Html.strong [] [ text "Handelsbanken - HQ" ]
                            , Html.br [] []
                            , text "A123456 (15st)"
                            , Html.br [] []
                            , span [ Attributes.title "Giltig t.o.m." ] [ text "2019-06-01" ]
                            ]
                        )
                    , Table.rightCell [] (Html.strong [] [ text "20 000 kr" ])
                    , Table.rightCell []
                        (Buttons.button
                            [ Buttons.CallToAction ]
                            (Just NoOp)
                            [ text "Lägg i varukorg" ]
                        )
                    ]
                , Table.row
                    [ Table.cell []
                        (Html.p []
                            [ Html.strong [] [ text "SEB - HQ" ]
                            , Html.br [] []
                            , text "A123456 (15st)"
                            , Html.br [] []
                            , span [ Attributes.title "Giltig t.o.m." ] [ text "2019-07-01" ]
                            ]
                        )
                    , Table.rightCell [] (Html.strong [] [ text "21 000 kr" ])
                    , Table.rightCell []
                        (Buttons.button
                            [ Buttons.CallToAction ]
                            (Just NoOp)
                            [ text "Lägg i varukorg" ]
                        )
                    ]
                ]
            )
        ]


viewPrice : Float -> Float -> Float -> Html Msg
viewPrice netPrice listPrice chemicalTax =
    let
        mutedStyles =
            [ Css.color Colors.dark
            ]
    in
    styled div
        [ Utils.block
        , Css.textAlign Css.right
        , Css.padding2 (em 1.25) (em 1.5)
        , Css.backgroundColor Colors.lightest
        , Css.borderLeft3 (px 4) Css.solid Colors.dark
        , Css.borderRadius radius
        ]
        []
        [ styled Html.p
            [ Css.fontSize (rem 2.25)
            , Css.fontWeight Css.bold
            ]
            []
            [ text "23 951 kr" ]
        , Html.p []
            [ styled span mutedStyles [] [ text "Listpris " ]
            , span [] [ text "31 935 kr" ]
            , styled span mutedStyles [] [ text " (-25 %) " ]
            , Html.br [] []
            , a [ href "#" ] [ text "Kemikalieskatt" ]
            , styled span mutedStyles [] [ text " tillkommer med " ]
            , span [] [ text "164 kr" ]
            ]
        ]


viewSidebar : Html Msg
viewSidebar =
    text ""



-- styled aside
--     [ Css.minHeight (vh 100)
--     , Css.flex3 zero zero (px 300)
--     , Css.position relative
--     , Css.backgroundColor Colors.primary
--     , Css.color Colors.white
--     ]
--     []
--     [ styled div
--         [ Css.position fixed
--         , Css.margin2 (rem 3) (rem 1.5)
--         , Css.width (calc (px 300) minus (rem 3))
--         , Css.displayFlex
--         , Css.flexDirection column
--         ]
--         []
--         [ sidebarMenu
--         ]
--     ]


sidebarMenu : Html Msg
sidebarMenu =
    ul []
        [ sidebarItem True "Breadcrumb" "Breadcrumb"
        , sidebarItem False "Buttons" "Buttons"
        ]



{- name = Name of the file
   Label = Label of the menu item
-}


sidebarItem : Bool -> String -> String -> Html Msg
sidebarItem isActive name label =
    styled li
        []
        []
        [ styled a
            [ Css.display block
            , Css.padding2 (em 0.5) (em 0.75)
            , Css.color Colors.white
            , Css.borderRadius smallRadius
            , hover
                [ Css.backgroundColor (rgba 0 0 0 0.2)
                , Css.color Colors.white
                ]
            , Css.batch <|
                if isActive then
                    [ Css.backgroundColor (rgba 0 0 0 0.1)
                    ]

                else
                    []
            ]
            [ href <| "#" ++ name ]
            [ text label ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view >> toUnstyled
        , update = update
        , init = initialModel
        }
