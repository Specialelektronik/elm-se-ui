module SE.Framework exposing (main)

import Browser
import Css exposing (absolute, block, calc, column, em, fixed, hover, int, minus, px, relative, rem, rgba, vh, zero)
import Css.Global exposing (descendants)
import Css.Transitions
import Html.Styled as Html exposing (Html, a, article, aside, div, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes as Attributes exposing (align, colspan, href, id)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Breadcrumb as Breadcrumb
import SE.Framework.Buttons as Buttons
import SE.Framework.Colors as Colors
import SE.Framework.Columns as Columns
import SE.Framework.Container as Container
import SE.Framework.Content as Content
import SE.Framework.Control as Control
import SE.Framework.Form as Form
import SE.Framework.Icon as Icon
import SE.Framework.Image as Image
import SE.Framework.Level as Level
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
    , yourOrderNo : String
    , goodsLabeling : String
    , message : String
    , requestedDeliveryDate : String
    , view : ProductView
    , products : List Product
    }


type Status
    = Regular
    | Campaign
    | New
    | Bargain


type ProductView
    = Gallery
    | List
    | Table


type alias Product =
    { name : String
    , product_code : String
    , manufacturer : String
    , manufacturer_product_code : String
    , attributes : List String
    , unit : String
    , in_stock : Int
    , list_price : Int
    , discount : Float
    , chemical_tax : Int
    , status : Status
    }


initialModel : Model
initialModel =
    { count = 1
    , yourOrderNo = ""
    , goodsLabeling = ""
    , message = ""
    , requestedDeliveryDate = ""
    , view = Gallery
    , products =
        [ { name = "QM75N UHD"
          , product_code = "LH75QMREBGCXEN"
          , manufacturer = "Samsung"
          , manufacturer_product_code = "LH75QMREBGCXEN"
          , attributes =
                [ "75\""
                , "E-LED"
                , "3840*2160 (4K UHD)"
                , "500 nits"
                ]
          , unit = "st"
          , in_stock = 10
          , list_price = 31935
          , discount = 0.34
          , chemical_tax = 164
          , status = Regular
          }
        , { name = "QM75N UHD"
          , product_code = "LH75QMREBGCXEN"
          , manufacturer = "Samsung"
          , manufacturer_product_code = "LH75QMREBGCXEN"
          , attributes =
                [ "75\""
                , "E-LED"
                , "3840*2160 (4K UHD)"
                , "500 nits"
                ]
          , unit = "st"
          , in_stock = 10
          , list_price = 31935
          , discount = 0.34
          , chemical_tax = 164
          , status = New
          }
        , { name = "QM75N UHD"
          , product_code = "LH75QMREBGCXEN"
          , manufacturer = "Samsung"
          , manufacturer_product_code = "LH75QMREBGCXEN"
          , attributes =
                [ "75\""
                , "E-LED"
                , "3840*2160 (4K UHD)"
                , "500 nits"
                ]
          , unit = "st"
          , in_stock = 10
          , list_price = 31935
          , discount = 0.34
          , chemical_tax = 164
          , status = Campaign
          }
        , { name = "QM75N UHD"
          , product_code = "LH75QMREBGCXEN"
          , manufacturer = "Samsung"
          , manufacturer_product_code = "LH75QMREBGCXEN"
          , attributes =
                [ "75\""
                , "E-LED"
                , "3840*2160 (4K UHD)"
                , "500 nits"
                ]
          , unit = "st"
          , in_stock = 1
          , list_price = 31935
          , discount = 0.34
          , chemical_tax = 164
          , status = Bargain
          }
        ]
    }



-- UPDATE


type Msg
    = NoOp
    | CountSet String
    | EnteredYourOrderNo String
    | EnteredGoodsLabeling String
    | EnteredMessage String
    | EnteredRequestedDeliveryDate String
    | ChangedProductView ProductView


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

        EnteredYourOrderNo newNo ->
            { model | yourOrderNo = newNo }

        EnteredGoodsLabeling newLabel ->
            { model | goodsLabeling = newLabel }

        EnteredMessage newMessage ->
            { model | message = newMessage }

        EnteredRequestedDeliveryDate newDate ->
            { model | requestedDeliveryDate = newDate }

        ChangedProductView newView ->
            { model | view = newView }



-- VIEW
-- view model =
--     styled div
--         [ Css.backgroundColor Colors.white ]
--         []
--         [ Buttons.iconButton Icon.cart [ Buttons.CallToAction ] (Just NoOp) "Köp"
--         ]


levelItem : ProductView -> ProductView -> (Control.Size -> Html Msg) -> Html Msg
levelItem toProductView currentProductView icon =
    let
        ( styles, attribs ) =
            case toProductView == currentProductView of
                True ->
                    ( [ Css.color Colors.link ], [] )

                False ->
                    ( [ Css.cursor Css.pointer ], [ onClick (ChangedProductView toProductView) ] )
    in
    styled span styles attribs [ icon Control.Medium ]


view : Model -> Html Msg
view model =
    styled div
        [ Css.displayFlex
        , descendants
            [ Css.Global.selector "article:not(#ProductList)"
                [ Css.pseudoClass "not(:target)"
                    [ Css.display Css.none
                    ]
                ]
            ]
        ]
        []
        [ viewSidebar
        , styled main_
            [ Css.flexGrow (int 1) ]
            []
            [ div []
                [ a [ href "#Product" ] [ text "Produkt" ]
                , a [ href "#Checkout" ] [ text "Checkout" ]
                , a [ href "#ProductList" ] [ text "Produktlista" ]
                ]
            , article [ id "Product" ]
                [ section []
                    [ Container.container []
                        [ viewProduct ]
                    ]
                ]
            , article
                [ id "Checkout" ]
                [ section []
                    [ Container.container []
                        [ viewCheckout model ]
                    ]
                ]
            , article [ id "ProductList" ]
                [ section []
                    [ Container.container []
                        [ viewProducts model
                        ]
                    ]
                ]
            ]
        ]


viewProducts : Model -> Html Msg
viewProducts model =
    let
        viewFn =
            case model.view of
                Gallery ->
                    viewProductsGallery

                List ->
                    viewProductsList

                Table ->
                    viewProductsTable
    in
    Columns.columns
        [ Columns.column [ ( Columns.Desktop, Columns.OneFifth ) ] [ viewCategoriesAndFilters ]
        , Columns.column []
            [ --      Breadcrumb.breadcrumb
              --     [ Breadcrumb.link "#av-teknik" [ text "AV-teknik" ]
              --     , Breadcrumb.link "#ljud-bild" [ text "Ljud & Bild" ]
              --     , Breadcrumb.activeLink "#Displayer" [ text "Displayer" ]
              --     ]
              -- ,
              Title.title1 "Displayer"
            , Level.level []
                [ Level.item [ levelItem Gallery model.view Icon.th ]
                , Level.item [ levelItem List model.view Icon.thList ]
                , Level.item [ levelItem Table model.view Icon.table ]
                ]
            , viewFn model.products
            ]
        ]


viewCategoriesAndFilters : Html Msg
viewCategoriesAndFilters =
    styled div
        [ Utils.block
        , Css.backgroundColor Colors.white
        , Css.padding (rem 0.75)
        ]
        []
        [ Title.title4 "AV-teknik"
        , styled ul
            [ Utils.block
            , Css.lineHeight (rem 1.875)
            , descendants
                [ Css.Global.selector "ul li"
                    [ Css.marginLeft (rem 1.25)
                    ]
                ]
            ]
            []
            [ Html.li []
                [ Html.strong [] [ text "Ljud & Bild (43)" ]
                , ul []
                    [ Html.li [] [ text "Aktivitetsbaserat lärande (260)" ]
                    , Html.li [] [ text "Blu-Ray / DVD-spelare (45)" ]
                    , Html.li [] [ text "D-BOX (45)" ]
                    , Html.li [] [ text "Digital Signage (45)" ]
                    , Html.li []
                        [ Html.strong [] [ text "Displayer (45)" ]
                        , ul []
                            [ Html.li [] [ text "Hotell-TV (45)" ]
                            , Html.li [] [ text "Konsument-TV (45)" ]
                            , Html.li [] [ text "LFD Large Format Display (45)" ]
                            , Html.li [] [ text "Spegel-TV (45)" ]
                            , Html.li [] [ text "Tillbehör (45)" ]
                            ]
                        ]
                    , Html.li [] [ text "Dokumentkameror (45)" ]
                    , Html.li [] [ text "Högtalare (45)" ]
                    , Html.li [] [ text "Kaleidescape (45)" ]
                    , Html.li [] [ text "Kameror och videoproduktion (45)" ]
                    , Html.li [] [ text "Konferenssystem (45)" ]
                    , Html.li [] [ text "Ljudinstallation (45)" ]
                    , Html.li [] [ text "Mikrofoner (45)" ]
                    , Html.li [] [ text "Projektionsdukar (45)" ]
                    , Html.li [] [ text "Projektorer (45)" ]
                    , Html.li [] [ text "Signalhantering (45)" ]
                    , Html.li [] [ text "Streaming och inspelning (45)" ]
                    , Html.li [] [ text "Trådlös bildpresentation (45)" ]
                    , Html.li [] [ text "Unified Communications (45)" ]
                    , Html.li [] [ text "Videoprocessorer (45)" ]
                    ]
                ]
            , Html.li [] [ text "Installation (45)" ]
            , Html.li [] [ text "Övrigt (45)" ]
            , Html.li [] [ text "Crestron Styrsystem (45)" ]
            ]
        , Title.title4 "Fabrikat"
        , Title.title4 "Filter"
        ]


productItemStyles : List Css.Style
productItemStyles =
    [ Utils.block
    , Css.position relative
    , Css.padding4 (rem 0.375) (rem 0.75) (rem 0.75) (rem 0.75)
    , Css.backgroundColor Colors.white
    , Css.cursor Css.pointer
    , Css.Transitions.transition
        [ Css.Transitions.boxShadow 250
        ]
    , Css.property "box-shadow" "0 2px 3px rgba(34, 41, 47, 0.1), 0 0 0 1px rgba(34, 41, 47, 0.1)"
    , hover
        [ Css.property "box-shadow" "0 2px 15px rgba(34, 41, 47, 0.1), 0 0 0 1px rgba(34, 41, 47, 0.1)"
        ]
    ]


viewProductsList : List Product -> Html Msg
viewProductsList products =
    div [] (List.map viewProductsListItem products)


viewProductsListItem : Product -> Html Msg
viewProductsListItem product =
    styled div
        (productItemStyles
            ++ [ Css.displayFlex
               , Css.justifyContent Css.spaceBetween
               ]
        )
        []
        [ styled div
            [ Css.width Css.auto
            , Css.minHeight (rem 7.5)
            , Css.marginRight (rem 1.5)
            ]
            []
            [ Image.image ( 186, 124 )
                [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN.jpg" 1
                ]
            ]
        , viewProductsGalleryItemPrice product.status product.list_price product.discount product.chemical_tax
        , div []
            [ Html.p []
                [ Html.strong [] [ text <| product.manufacturer ++ " " ++ product.name ]
                ]
            , styled span
                [ Css.color Colors.primary ]
                []
                [ text product.product_code
                ]
            ]
        , div []
            [ Content.content
                []
                [ styled ul [ Css.color Colors.dark ] [] (List.map (\a -> li [] [ text a ]) product.attributes) ]
            ]
        , styled div
            [ Css.alignSelf Css.center ]
            []
            [ a []
                [ text "Produktblad"
                ]
            ]
        , styled div
            [ Css.alignSelf Css.center, Css.marginLeft (rem 1.5) ]
            []
            [ Html.strong []
                [ text <|
                    String.fromInt product.in_stock
                        ++ " "
                        ++ product.unit
                ]
            , span [] [ text " i lager" ]
            ]
        , styled div [ Css.alignSelf Css.flexEnd, Css.marginLeft (rem 1.5) ] [] [ Buttons.iconButton Icon.cart [ Buttons.CallToAction ] (Just NoOp) "Lägg i varukorg" ]
        ]


viewProductsTable : List Product -> Html Msg
viewProductsTable products =
    styled div
        [ Utils.block
        , Css.position relative
        , Css.padding4 (rem 0.375) (rem 0.75) (rem 0.75) (rem 0.75)
        , Css.backgroundColor Colors.white
        , Css.property "box-shadow" "0 2px 3px rgba(34, 41, 47, 0.1), 0 0 0 1px rgba(34, 41, 47, 0.1)"
        ]
        []
        [ Table.table [ Table.Fullwidth, Table.Hoverable ]
            (Table.head
                [ Table.cell [] (text "Tillverkare")
                , Table.cell [] (text "Benämning")
                , Table.cell [] (text "Artikelnummer")
                , Table.cell [] (text "Tillverkarens artikelnummer")
                , Table.rightCell [] (text "Lagersaldo")
                , Table.rightCell [] (text "Pris")
                , Table.rightCell [] (text "")
                ]
            )
            (Table.foot [])
            (Table.body (List.map viewProductsTableRow products))
        ]


viewProductsTableRow product =
    Table.row
        [ Table.cell [] (text product.manufacturer)
        , Table.cell [] (text product.name)
        , Table.cell [] (text product.product_code)
        , Table.cell [] (text product.manufacturer_product_code)
        , Table.rightCell []
            (text <|
                String.fromInt product.in_stock
                    ++ " "
                    ++ product.unit
            )
        , Table.rightCell [] (viewProductsTableRowPrice product.status product.list_price product.discount product.chemical_tax)
        , Table.rightCell [] (Buttons.iconButton Icon.cart [ Buttons.CallToAction ] (Just NoOp) "Lägg i varukorg")
        ]


viewProductsGallery : List Product -> Html Msg
viewProductsGallery products =
    Columns.multilineColumns
        (List.map
            (\p ->
                Columns.column [ ( Columns.FullHD, Columns.OneQuarter ), ( Columns.Extended, Columns.OneThird ), ( Columns.Desktop, Columns.Half ), ( Columns.Mobile, Columns.Full ) ]
                    [ viewProductsGalleryItem p ]
            )
            products
        )


viewProductsGalleryItem : Product -> Html Msg
viewProductsGalleryItem product =
    styled div
        productItemStyles
        []
        [ Image.image ( 327, 218 )
            [ Image.source "https://specialelektronik.se/images/produkter/LH75QMREBGCXEN.jpg" 1
            ]
        , viewProductsGalleryItemPrice product.status product.list_price product.discount product.chemical_tax
        , Html.strong
            []
            [ text <| product.manufacturer ++ " " ++ product.name ]
        , styled div
            [ Utils.block
            , Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            ]
            []
            [ styled span [ Css.color Colors.primary ] [] [ text product.product_code ]
            , a []
                [ text "Produktblad"
                ]
            ]
        , Content.content
            []
            [ styled ul [ Css.color Colors.dark ] [] (List.map (\a -> li [] [ text a ]) product.attributes) ]
        , styled div
            [ Utils.block
            , Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            , Css.alignItems Css.center
            ]
            []
            [ styled div
                [ Css.color Colors.darker
                ]
                []
                [ Html.strong []
                    [ text <|
                        String.fromInt product.in_stock
                            ++ " "
                            ++ product.unit
                    ]
                , span [] [ text " i lager" ]
                ]
            , Buttons.iconButton Icon.cart [ Buttons.CallToAction ] (Just NoOp) "Lägg i varukorg"
            ]
        ]


viewProductsTableRowPrice : Status -> Int -> Float -> Int -> Html Msg
viewProductsTableRowPrice status listPrice discount chemicalTax =
    let
        hasChemicalTax =
            chemicalTax > 0

        attribs =
            if hasChemicalTax then
                [ Attributes.title ("Kemikalieskatt tillkommer med " ++ String.fromInt chemicalTax ++ "kr") ]

            else
                []

        chemicalTaxMarker =
            if hasChemicalTax then
                "*"

            else
                ""
    in
    Html.p attribs
        [ styled span
            [ Css.fontWeight Css.bold ]
            []
            [ text <| String.fromInt (round <| toFloat listPrice * (1 - discount)) ++ " kr" ++ chemicalTaxMarker ]
        , Html.br [] []
        , styled span
            [ Css.fontSize (rem 0.875) ]
            []
            [ text <| "Rabatt: " ++ String.fromFloat (100 * discount) ++ "%"
            ]
        ]


viewProductsGalleryItemPrice : Status -> Int -> Float -> Int -> Html Msg
viewProductsGalleryItemPrice status listPrice discount chemicalTax =
    let
        hasChemicalTax =
            chemicalTax > 0

        attribs =
            if hasChemicalTax then
                [ Attributes.title ("Kemikalieskatt tillkommer med " ++ String.fromInt chemicalTax ++ "kr") ]

            else
                []

        chemicalTaxMarker =
            if hasChemicalTax then
                "*"

            else
                ""

        ( statusTag, statusStyle ) =
            case status of
                Regular ->
                    ( text ""
                    , [ Css.backgroundColor (rgba 255 255 255 0.8)
                      ]
                    )

                New ->
                    ( span [] [ text "NYHET" ]
                    , [ Css.backgroundColor Colors.primary
                      , Css.color Colors.white
                      ]
                    )

                Campaign ->
                    ( span [] [ text "KAMPANJ" ]
                    , [ Css.backgroundColor Colors.black
                      , Css.color Colors.white
                      ]
                    )

                Bargain ->
                    ( styled span [ Css.fontWeight Css.bold ] [] [ text "FYND" ]
                    , [ Css.backgroundColor Colors.danger
                      , Css.color Colors.white
                      ]
                    )
    in
    styled div
        [ Css.position absolute
        , Css.top (rem -0.375)
        , Css.left (rem 0.75)
        , Css.width (calc (Css.pct 100) minus (rem 1.5))
        , Css.displayFlex
        , Css.justifyContent Css.spaceBetween
        , descendants
            [ Css.Global.typeSelector "span"
                [ Css.padding2 (rem 0) (rem 0.375)
                , Css.marginBottom (rem 0.5)
                , Css.batch statusStyle
                ]
            ]
        ]
        []
        [ styled div [] [] [ statusTag ]
        , styled div
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.alignItems Css.flexEnd
            , Css.fontWeight Css.bold
            ]
            attribs
            [ styled span
                [ Css.fontSize (rem 1.25)
                , Css.fontWeight Css.bold
                ]
                []
                [ text <| String.fromInt (round <| toFloat listPrice * (1 - discount)) ++ " kr" ++ chemicalTaxMarker ]
            , span
                attribs
                [ text <| String.fromFloat (100 * discount) ++ "%"
                ]
            ]
        ]


noImage : Html Msg
noImage =
    styled div [ Utils.block, Css.backgroundColor Colors.lightest, Css.color Colors.light, Css.padding (Css.pct 25) ] [] [ Image.noImage ]


viewCheckout : Model -> Html Msg
viewCheckout model =
    div []
        [ Title.title1 "Varukorg"
        , Columns.columns
            [ Columns.column [ ( Columns.Desktop, Columns.TwoThirds ) ]
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
                                        [ Buttons.staticButton [] "st"
                                        ]
                                    ]
                                )
                            , Table.rightCell [] (text <| String.fromInt (23951 * model.count))
                            , Table.rightCell [] (Icon.trash Control.Regular)
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
                                        [ Buttons.staticButton [] "st"
                                        ]
                                    ]
                                )
                            , Table.rightCell [] (text <| String.fromInt (23951 * model.count))
                            , Table.rightCell [] (Icon.trash Control.Regular)
                            ]
                        ]
                    )
                , styled Html.p
                    [ Css.textAlign Css.right
                    ]
                    []
                    [ Html.a [ onClick NoOp ] [ text "Töm varukorgen" ] ]
                ]
            , Columns.defaultColumn
                [ styled div
                    [ Css.backgroundColor Colors.black
                    , Css.color Colors.white
                    , Css.padding2 (em 1.25) (em 1.5)
                    ]
                    []
                    [ Title.title5 "Sammanställning"
                    , div []
                        [ styled div
                            [ Css.displayFlex
                            , Css.justifyContent Css.spaceBetween
                            ]
                            []
                            [ div []
                                [ text "Summa produkter"
                                ]
                            , div
                                []
                                [ text (String.fromInt (23951 * model.count * 2))
                                ]
                            ]
                        , styled div
                            [ Css.displayFlex
                            , Css.justifyContent Css.spaceBetween
                            ]
                            []
                            [ div []
                                [ text "Kemikalieskatt"
                                ]
                            , styled div
                                []
                                []
                                [ text (String.fromInt (164 * model.count * 2))
                                ]
                            ]
                        , styled div
                            [ Css.displayFlex
                            , Css.justifyContent Css.spaceBetween
                            ]
                            []
                            [ div []
                                [ text "Beräknad fraktkostnad*"
                                ]
                            , styled div
                                []
                                []
                                [ text (String.fromInt (130 * model.count * 2))
                                ]
                            ]
                        , styled div
                            [ Css.displayFlex
                            , Css.justifyContent Css.spaceBetween
                            ]
                            []
                            [ div []
                                [ Html.strong [] [ text "TOTALT" ]
                                ]
                            , styled div
                                []
                                []
                                [ Html.strong [] [ text (String.fromInt ((23951 + 164 + 130) * model.count * 2)) ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , Title.title5 "Fakturaadress"
        , Content.content []
            [ Html.p []
                [ Html.strong [] [ text "SPECIAL-ELEKTRONIK I KARLSTAD AB" ]
                , Html.br [] []
                , text "BOX 8065"
                , Html.br [] []
                , text "650 08 KARLSTAD"
                ]
            ]
        , Title.title5 "Leveransadress"
        , Form.field []
            [ ul []
                [ li []
                    [ Form.radio "SPECIAL-ELEKTRONIK I KARLSTAD AB, GRANLIDSVÄGEN 85, 653 51 KARLSTAD" True NoOp
                    ]
                , li []
                    [ Form.radio "SPECIAL-ELEKTRONIK AB, BLOMSTERVÄGEN 19, 343 35 ÄLMHULT" False NoOp
                    ]
                ]
            ]
        , Title.title5 "Övrigt"
        , Form.field []
            [ Form.label "Ert ordernummer"
            , Form.control False
                [ Form.input
                    { value = model.yourOrderNo
                    , placeholder = "Ert ordernummer"
                    , modifiers = []
                    , onInput = EnteredYourOrderNo
                    }
                ]
            ]
        , Form.field []
            [ Form.label "Godsmärke"
            , Form.control False
                [ Form.input
                    { value = model.goodsLabeling
                    , placeholder = "Godsmärke"
                    , modifiers = []
                    , onInput = EnteredGoodsLabeling
                    }
                ]
            ]
        , Form.field []
            [ Form.label "Önskat leveransdatum"
            , Form.control False
                [ Form.date
                    { value = model.requestedDeliveryDate
                    , placeholder = "Så snart som möjligt"
                    , modifiers = []
                    , onInput = EnteredRequestedDeliveryDate
                    , min = "2019-05-22"
                    , max = "2020-05-22"
                    }
                ]
            ]
        , Form.field []
            [ Form.label "Meddelande"
            , Form.control False
                [ Form.input
                    { value = model.message
                    , placeholder = "Meddelande"
                    , modifiers = []
                    , onInput = EnteredMessage
                    }
                ]
            ]
        , Buttons.button [ Buttons.CallToAction, Buttons.Fullwidth ] (Just NoOp) [ text "Skicka order" ]
        ]


viewProduct : Html Msg
viewProduct =
    styled div
        [ Css.backgroundColor Colors.white
        , Css.padding (rem 0.75)
        , Css.property "box-shadow" "0 2px 3px rgba(34, 41, 47, 0.1), 0 0 0 1px rgba(34, 41, 47, 0.1)"
        ]
        []
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
                        [ Icon.pdf Control.Regular
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
                                [ Buttons.staticButton [ Buttons.Size Control.Large ] "st"
                                ]
                            ]
                        ]
                    , Columns.defaultColumn
                        [ Form.field
                            []
                            [ Buttons.button [ Buttons.CallToAction, Buttons.Fullwidth, Buttons.Size Control.Large ]
                                (Just NoOp)
                                [ Icon.cart Control.Medium
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
            [ Icon.bid Control.Regular ]
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
