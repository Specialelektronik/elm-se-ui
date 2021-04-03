module SE.UI.Icon.V2 exposing
    ( Icon, toHtml, toDataUri, withContainerSize, withSize
    , Transform(..), withTransform
    , angleDown, ban, bargain, bid, box, boxes, calendar, campaign, cart, category, checkCircle, clock, dolly, envelope, ethernet, eye, facebook, file, history, home, images, instagram, laptop, lightbulb, linkedin, mapMarker, new, notification, pdf, percentage, phone, playCircle, satelliteDish, search, slidersH, star, table, th, thLarge, thList, trash, truck, tv, user, wifi, youtube
    , tick, circle
    )

{-| Version 2 of Icons, mimics Bulma Icon element set.

We use more or less the same styles for the icon container but We use plain inline svgs for icons instead of FontAwesome. This gives us the flexibility and speed that we want (FontAwesome is a 500kb js file to begin with).

<https://bulma.io/documentation/elements/icon/>

Version 2 uses withStar-pattern to allow transformation and support both icon containers and all icons as DataUris (to use as Css backgrounds)

@docs Icon, toHtml, toDataUri, withContainerSize, withSize


# Transformations

@docs Transform, withTransform


# Available icons

@docs angleDown, ban, bargain, bid, box, boxes, calendar, campaign, cart, category, checkCircle, clock, dolly, envelope, ethernet, eye, facebook, file, history, home, images, instagram, laptop, lightbulb, linkedin, mapMarker, new, notification, pdf, percentage, phone, playCircle, satelliteDish, search, slidersH, star, table, th, thLarge, thList, trash, truck, tv, user, wifi, youtube


# Special purpose icons

@docs tick, circle

-}

import Css exposing (Style)
import Css.Animations
import Css.Global
import Html.Styled as Html exposing (Html, styled)
import Html.Styled.Attributes exposing (attribute)
import SE.UI.Control as Control
import Svg.Styled as Svg exposing (Attribute, Svg)
import Svg.Styled.Attributes exposing (d, height, viewBox, width)


{-| The internal type for an Icon, exposed in order to support type annotations outside of this module
-}
type Icon
    = Icon Internals


type alias Internals =
    { size : Control.Size
    , containerSize : Control.Size
    , transforms : List Transform
    , viewBoxAndPaths : ( Int, Int, List String )
    }


{-| Transformations alternatives
-}
type Transform
    = Rotate Float
    | FlipX
    | FlipY
    | Spin


initInternals : ( Int, Int, List String ) -> Internals
initInternals =
    Internals Control.Regular Control.Regular []


{-| Checkbox background, as a css background
-}
tick : String
tick =
    "data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='M5.707 7.293a1 1 0 0 0-1.414 1.414l2 2a1 1 0 0 0 1.414 0l4-4a1 1 0 0 0-1.414-1.414L7 8.586 5.707 7.293z'/%3e%3c/svg%3e"


{-| Radio button background, as a css background
-}
circle : String
circle =
    "data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3ccircle cx='8' cy='8' r='3'/%3e%3c/svg%3e"


{-| <https://fontawesome.com/icons/angle-down?style=solid>
-}
angleDown : Icon
angleDown =
    Icon (initInternals ( 320, 512, [ "M143 352.3L7 216.3c-9.4-9.4-9.4-24.6 0-33.9l22.6-22.6c9.4-9.4 24.6-9.4 33.9 0l96.4 96.4 96.4-96.4c9.4-9.4 24.6-9.4 33.9 0l22.6 22.6c9.4 9.4 9.4 24.6 0 33.9l-136 136c-9.2 9.4-24.4 9.4-33.8 0z" ] ))


{-| <https://fontawesome.com/icons/ban?style=solid>
-}
ban : Icon
ban =
    Icon (initInternals ( 512, 512, [ "M256 8C119.034 8 8 119.033 8 256s111.034 248 248 248 248-111.034 248-248S392.967 8 256 8zm130.108 117.892c65.448 65.448 70 165.481 20.677 235.637L150.47 105.216c70.204-49.356 170.226-44.735 235.638 20.676zM125.892 386.108c-65.448-65.448-70-165.481-20.677-235.637L361.53 406.784c-70.203 49.356-170.226 44.736-235.638-20.676z" ] ))


{-| <https://fontawesome.com/icons/piggy-bank?style=solid>
-}
bargain : Icon
bargain =
    Icon (initInternals ( 576, 512, [ "M560 224h-29.5c-8.8-20-21.6-37.7-37.4-52.5L512 96h-32c-29.4 0-55.4 13.5-73 34.3-7.6-1.1-15.1-2.3-23-2.3H256c-77.4 0-141.9 55-156.8 128H56c-14.8 0-26.5-13.5-23.5-28.8C34.7 215.8 45.4 208 57 208h1c3.3 0 6-2.7 6-6v-20c0-3.3-2.7-6-6-6-28.5 0-53.9 20.4-57.5 48.6C-3.9 258.8 22.7 288 56 288h40c0 52.2 25.4 98.1 64 127.3V496c0 8.8 7.2 16 16 16h64c8.8 0 16-7.2 16-16v-48h128v48c0 8.8 7.2 16 16 16h64c8.8 0 16-7.2 16-16v-80.7c11.8-8.9 22.3-19.4 31.3-31.3H560c8.8 0 16-7.2 16-16V240c0-8.8-7.2-16-16-16zm-128 64c-8.8 0-16-7.2-16-16s7.2-16 16-16 16 7.2 16 16-7.2 16-16 16zM256 96h128c5.4 0 10.7.4 15.9.8 0-.3.1-.5.1-.8 0-53-43-96-96-96s-96 43-96 96c0 2.1.5 4.1.6 6.2 15.2-3.9 31-6.2 47.4-6.2z" ] ))


{-| <https://fontawesome.com/icons/gavel?style=solid>
-}
bid : Icon
bid =
    Icon (initInternals ( 512, 512, [ "M504.971 199.362l-22.627-22.627c-9.373-9.373-24.569-9.373-33.941 0l-5.657 5.657L329.608 69.255l5.657-5.657c9.373-9.373 9.373-24.569 0-33.941L312.638 7.029c-9.373-9.373-24.569-9.373-33.941 0L154.246 131.48c-9.373 9.373-9.373 24.569 0 33.941l22.627 22.627c9.373 9.373 24.569 9.373 33.941 0l5.657-5.657 39.598 39.598-81.04 81.04-5.657-5.657c-12.497-12.497-32.758-12.497-45.255 0L9.373 412.118c-12.497 12.497-12.497 32.758 0 45.255l45.255 45.255c12.497 12.497 32.758 12.497 45.255 0l114.745-114.745c12.497-12.497 12.497-32.758 0-45.255l-5.657-5.657 81.04-81.04 39.598 39.598-5.657 5.657c-9.373 9.373-9.373 24.569 0 33.941l22.627 22.627c9.373 9.373 24.569 9.373 33.941 0l124.451-124.451c9.372-9.372 9.372-24.568 0-33.941z" ] ))


{-| <https://fontawesome.com/icons/box?style=solid>
-}
box : Icon
box =
    Icon (initInternals ( 512, 512, [ "M509.5 184.6L458.9 32.8C452.4 13.2 434.1 0 413.4 0H272v192h238.7c-.4-2.5-.4-5-1.2-7.4zM240 0H98.6c-20.7 0-39 13.2-45.5 32.8L2.5 184.6c-.8 2.4-.8 4.9-1.2 7.4H240V0zM0 224v240c0 26.5 21.5 48 48 48h416c26.5 0 48-21.5 48-48V224H0" ] ))


{-| <https://fontawesome.com/icons/boxes?style=solid>
-}
boxes : Icon
boxes =
    Icon (initInternals ( 576, 512, [ "M560 288h-80v96l-32-21.3-32 21.3v-96h-80c-8.8 0-16 7.2-16 16v192c0 8.8 7.2 16 16 16h224c8.8 0 16-7.2 16-16V304c0-8.8-7.2-16-16-16zm-384-64h224c8.8 0 16-7.2 16-16V16c0-8.8-7.2-16-16-16h-80v96l-32-21.3L256 96V0h-80c-8.8 0-16 7.2-16 16v192c0 8.8 7.2 16 16 16zm64 64h-80v96l-32-21.3L96 384v-96H16c-8.8 0-16 7.2-16 16v192c0 8.8 7.2 16 16 16h224c8.8 0 16-7.2 16-16V304c0-8.8-7.2-16-16-16z" ] ))


{-| <https://fontawesome.com/icons/calendar-alt?style=regular>
-}
calendar : Icon
calendar =
    Icon (initInternals ( 448, 512, [ "M148 288h-40c-6.6 0-12-5.4-12-12v-40c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12zm108-12v-40c0-6.6-5.4-12-12-12h-40c-6.6 0-12 5.4-12 12v40c0 6.6 5.4 12 12 12h40c6.6 0 12-5.4 12-12zm96 0v-40c0-6.6-5.4-12-12-12h-40c-6.6 0-12 5.4-12 12v40c0 6.6 5.4 12 12 12h40c6.6 0 12-5.4 12-12zm-96 96v-40c0-6.6-5.4-12-12-12h-40c-6.6 0-12 5.4-12 12v40c0 6.6 5.4 12 12 12h40c6.6 0 12-5.4 12-12zm-96 0v-40c0-6.6-5.4-12-12-12h-40c-6.6 0-12 5.4-12 12v40c0 6.6 5.4 12 12 12h40c6.6 0 12-5.4 12-12zm192 0v-40c0-6.6-5.4-12-12-12h-40c-6.6 0-12 5.4-12 12v40c0 6.6 5.4 12 12 12h40c6.6 0 12-5.4 12-12zm96-260v352c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V112c0-26.5 21.5-48 48-48h48V12c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v52h128V12c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v52h48c26.5 0 48 21.5 48 48zm-48 346V160H48v298c0 3.3 2.7 6 6 6h340c3.3 0 6-2.7 6-6z" ] ))


{-| <https://fontawesome.com/icons/tag?style=solid>
-}
campaign : Icon
campaign =
    Icon (initInternals ( 512, 512, [ "M0 252.118V48C0 21.49 21.49 0 48 0h204.118a48 48 0 0 1 33.941 14.059l211.882 211.882c18.745 18.745 18.745 49.137 0 67.882L293.823 497.941c-18.745 18.745-49.137 18.745-67.882 0L14.059 286.059A48 48 0 0 1 0 252.118zM112 64c-26.51 0-48 21.49-48 48s21.49 48 48 48 48-21.49 48-48-21.49-48-48-48z" ] ))


{-| <https://fontawesome.com/icons/shopping-cart?style=solid>
-}
cart : Icon
cart =
    Icon (initInternals ( 576, 512, [ "M528.12 301.319l47.273-208C578.806 78.301 567.391 64 551.99 64H159.208l-9.166-44.81C147.758 8.021 137.93 0 126.529 0H24C10.745 0 0 10.745 0 24v16c0 13.255 10.745 24 24 24h69.883l70.248 343.435C147.325 417.1 136 435.222 136 456c0 30.928 25.072 56 56 56s56-25.072 56-56c0-15.674-6.447-29.835-16.824-40h209.647C430.447 426.165 424 440.326 424 456c0 30.928 25.072 56 56 56s56-25.072 56-56c0-22.172-12.888-41.332-31.579-50.405l5.517-24.276c3.413-15.018-8.002-29.319-23.403-29.319H218.117l-6.545-32h293.145c11.206 0 20.92-7.754 23.403-18.681z" ] ))


{-| <https://fontawesome.com/icons/sitemap?style=solid>
-}
category : Icon
category =
    Icon (initInternals ( 640, 512, [ "M128 352H32c-17.67 0-32 14.33-32 32v96c0 17.67 14.33 32 32 32h96c17.67 0 32-14.33 32-32v-96c0-17.67-14.33-32-32-32zm-24-80h192v48h48v-48h192v48h48v-57.59c0-21.17-17.23-38.41-38.41-38.41H344v-64h40c17.67 0 32-14.33 32-32V32c0-17.67-14.33-32-32-32H256c-17.67 0-32 14.33-32 32v96c0 17.67 14.33 32 32 32h40v64H94.41C73.23 224 56 241.23 56 262.41V320h48v-48zm264 80h-96c-17.67 0-32 14.33-32 32v96c0 17.67 14.33 32 32 32h96c17.67 0 32-14.33 32-32v-96c0-17.67-14.33-32-32-32zm240 0h-96c-17.67 0-32 14.33-32 32v96c0 17.67 14.33 32 32 32h96c17.67 0 32-14.33 32-32v-96c0-17.67-14.33-32-32-32z" ] ))


{-| <https://fontawesome.com/icons/check-circle?style=regular>
-}
checkCircle : Icon
checkCircle =
    Icon (initInternals ( 512, 512, [ "M256 8C119.033 8 8 119.033 8 256s111.033 248 248 248 248-111.033 248-248S392.967 8 256 8zm0 48c110.532 0 200 89.451 200 200 0 110.532-89.451 200-200 200-110.532 0-200-89.451-200-200 0-110.532 89.451-200 200-200m140.204 130.267l-22.536-22.718c-4.667-4.705-12.265-4.736-16.97-.068L215.346 303.697l-59.792-60.277c-4.667-4.705-12.265-4.736-16.97-.069l-22.719 22.536c-4.705 4.667-4.736 12.265-.068 16.971l90.781 91.516c4.667 4.705 12.265 4.736 16.97.068l172.589-171.204c4.704-4.668 4.734-12.266.067-16.971z" ] ))


{-| <https://fontawesome.com/icons/clock?style=solid>
-}
clock : Icon
clock =
    Icon (initInternals ( 512, 512, [ "M256,8C119,8,8,119,8,256S119,504,256,504,504,393,504,256,393,8,256,8Zm92.49,313h0l-20,25a16,16,0,0,1-22.49,2.5h0l-67-49.72a40,40,0,0,1-15-31.23V112a16,16,0,0,1,16-16h32a16,16,0,0,1,16,16V256l58,42.5A16,16,0,0,1,348.49,321Z" ] ))


{-| <https://fontawesome.com/icons/dolly?style=solid>
-}
dolly : Icon
dolly =
    Icon (initInternals ( 576, 512, [ "M294.2 277.7c18 5 34.7 13.4 49.5 24.7l161.5-53.8c8.4-2.8 12.9-11.9 10.1-20.2L454.9 47.2c-2.8-8.4-11.9-12.9-20.2-10.1l-61.1 20.4 33.1 99.4L346 177l-33.1-99.4-61.6 20.5c-8.4 2.8-12.9 11.9-10.1 20.2l53 159.4zm281 48.7L565 296c-2.8-8.4-11.9-12.9-20.2-10.1l-213.5 71.2c-17.2-22-43.6-36.4-73.5-37L158.4 21.9C154 8.8 141.8 0 128 0H16C7.2 0 0 7.2 0 16v32c0 8.8 7.2 16 16 16h88.9l92.2 276.7c-26.1 20.4-41.7 53.6-36 90.5 6.1 39.4 37.9 72.3 77.3 79.2 60.2 10.7 112.3-34.8 113.4-92.6l213.3-71.2c8.3-2.8 12.9-11.8 10.1-20.2zM256 464c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48z" ] ))


{-| <https://fontawesome.com/icons/envelope?style=regular>
-}
envelope : Icon
envelope =
    Icon (initInternals ( 512, 512, [ "M464 64H48C21.49 64 0 85.49 0 112v288c0 26.51 21.49 48 48 48h416c26.51 0 48-21.49 48-48V112c0-26.51-21.49-48-48-48zm0 48v40.805c-22.422 18.259-58.168 46.651-134.587 106.49-16.841 13.247-50.201 45.072-73.413 44.701-23.208.375-56.579-31.459-73.413-44.701C106.18 199.465 70.425 171.067 48 152.805V112h416zM48 400V214.398c22.914 18.251 55.409 43.862 104.938 82.646 21.857 17.205 60.134 55.186 103.062 54.955 42.717.231 80.509-37.199 103.053-54.947 49.528-38.783 82.032-64.401 104.947-82.653V400H48z" ] ))


{-| <https://fontawesome.com/icons/ethernet?style=solid>
-}
ethernet : Icon
ethernet =
    Icon (initInternals ( 512, 512, [ "M496 192h-48v-48c0-8.8-7.2-16-16-16h-48V80c0-8.8-7.2-16-16-16H144c-8.8 0-16 7.2-16 16v48H80c-8.8 0-16 7.2-16 16v48H16c-8.8 0-16 7.2-16 16v224c0 8.8 7.2 16 16 16h80V320h32v128h64V320h32v128h64V320h32v128h64V320h32v128h80c8.8 0 16-7.2 16-16V208c0-8.8-7.2-16-16-16z" ] ))


{-| <https://fontawesome.com/icons/eye?style=regular>
-}
eye : Icon
eye =
    Icon (initInternals ( 576, 512, [ "M572.52 241.4C518.29 135.59 410.93 64 288 64S57.68 135.64 3.48 241.41a32.35 32.35 0 0 0 0 29.19C57.71 376.41 165.07 448 288 448s230.32-71.64 284.52-177.41a32.35 32.35 0 0 0 0-29.19zM288 400a144 144 0 1 1 144-144 143.93 143.93 0 0 1-144 144zm0-240a95.31 95.31 0 0 0-25.31 3.79 47.85 47.85 0 0 1-66.9 66.9A95.78 95.78 0 1 0 288 160z" ] ))


{-| <https://fontawesome.com/icons/facebook-square?style=brands>
-}
facebook : Icon
facebook =
    Icon (initInternals ( 35, 40, [ "M34.32 9.42L19 .57a2 2 0 00-2 0L1.68 9.42a2 2 0 00-1 1.73v17.69a2 2 0 001 1.73L17 39.42a2 2 0 002 0l15.32-8.85a2 2 0 001-1.73V11.15a2 2 0 00-1-1.73zM22.82 14h-1.41a1.8 1.8 0 00-1.44.53 1.84 1.84 0 00-.42 1.23v2.11h3.13l-.5 3.27h-2.63V29H16v-7.88h-2.82v-3.27H16v-2.46a5 5 0 01.56-2.39A3.41 3.41 0 0118 11.52a4.67 4.67 0 012.29-.52 10.08 10.08 0 011.19.07 6.46 6.46 0 011 .1h.36z" ] ))


{-| <https://fontawesome.com/icons/file-alt?style=solid>
-}
file : Icon
file =
    Icon (initInternals ( 384, 512, [ "M224 136V0H24C10.7 0 0 10.7 0 24v464c0 13.3 10.7 24 24 24h336c13.3 0 24-10.7 24-24V160H248c-13.2 0-24-10.8-24-24zm64 236c0 6.6-5.4 12-12 12H108c-6.6 0-12-5.4-12-12v-8c0-6.6 5.4-12 12-12h168c6.6 0 12 5.4 12 12v8zm0-64c0 6.6-5.4 12-12 12H108c-6.6 0-12-5.4-12-12v-8c0-6.6 5.4-12 12-12h168c6.6 0 12 5.4 12 12v8zm0-72v8c0 6.6-5.4 12-12 12H108c-6.6 0-12-5.4-12-12v-8c0-6.6 5.4-12 12-12h168c6.6 0 12 5.4 12 12zm96-114.1v6.1H256V0h6.1c6.4 0 12.5 2.5 17 7l97.9 98c4.5 4.5 7 10.6 7 16.9z" ] ))


{-| <https://fontawesome.com/icons/history?style=solid>
-}
history : Icon
history =
    Icon (initInternals ( 512, 512, [ "M504 255.531c.253 136.64-111.18 248.372-247.82 248.468-59.015.042-113.223-20.53-155.822-54.911-11.077-8.94-11.905-25.541-1.839-35.607l11.267-11.267c8.609-8.609 22.353-9.551 31.891-1.984C173.062 425.135 212.781 440 256 440c101.705 0 184-82.311 184-184 0-101.705-82.311-184-184-184-48.814 0-93.149 18.969-126.068 49.932l50.754 50.754c10.08 10.08 2.941 27.314-11.313 27.314H24c-8.837 0-16-7.163-16-16V38.627c0-14.254 17.234-21.393 27.314-11.314l49.372 49.372C129.209 34.136 189.552 8 256 8c136.81 0 247.747 110.78 248 247.531zm-180.912 78.784l9.823-12.63c8.138-10.463 6.253-25.542-4.21-33.679L288 256.349V152c0-13.255-10.745-24-24-24h-16c-13.255 0-24 10.745-24 24v135.651l65.409 50.874c10.463 8.137 25.541 6.253 33.679-4.21z" ] ))


{-| <https://fontawesome.com/icons/home?style=solid>
-}
home : Icon
home =
    Icon (initInternals ( 576, 512, [ "M280.37 148.26L96 300.11V464a16 16 0 0 0 16 16l112.06-.29a16 16 0 0 0 15.92-16V368a16 16 0 0 1 16-16h64a16 16 0 0 1 16 16v95.64a16 16 0 0 0 16 16.05L464 480a16 16 0 0 0 16-16V300L295.67 148.26a12.19 12.19 0 0 0-15.3 0zM571.6 251.47L488 182.56V44.05a12 12 0 0 0-12-12h-56a12 12 0 0 0-12 12v72.61L318.47 43a48 48 0 0 0-61 0L4.34 251.47a12 12 0 0 0-1.6 16.9l25.5 31A12 12 0 0 0 45.15 301l235.22-193.74a12.19 12.19 0 0 1 15.3 0L530.9 301a12 12 0 0 0 16.9-1.6l25.5-31a12 12 0 0 0-1.7-16.93z" ] ))


{-| <https://fontawesome.com/icons/images?style=solid>
-}
images : Icon
images =
    Icon (initInternals ( 576, 512, [ "M480 416v16c0 26.51-21.49 48-48 48H48c-26.51 0-48-21.49-48-48V176c0-26.51 21.49-48 48-48h16v208c0 44.112 35.888 80 80 80h336zm96-80V80c0-26.51-21.49-48-48-48H144c-26.51 0-48 21.49-48 48v256c0 26.51 21.49 48 48 48h384c26.51 0 48-21.49 48-48zM256 128c0 26.51-21.49 48-48 48s-48-21.49-48-48 21.49-48 48-48 48 21.49 48 48zm-96 144l55.515-55.515c4.686-4.686 12.284-4.686 16.971 0L272 256l135.515-135.515c4.686-4.686 12.284-4.686 16.971 0L512 208v112H160v-48z" ] ))


{-| <https://fontawesome.com/icons/instagram?style=brands>
Like all social media icons, they are mounted on a hexagon shape
-}
instagram : Icon
instagram =
    Icon (initInternals ( 35, 40, [ "M20.09 19.69a2.77 2.77 0 11-2.77-2.77 2.77 2.77 0 012.77 2.77z", "M23.8 14.79a2.85 2.85 0 00-1.58-1.58c-1.09-.43-3.69-.33-4.9-.33s-3.8-.1-4.89.33a2.85 2.85 0 00-1.58 1.58c-.43 1.09-.34 3.69-.34 4.9s-.1 3.8.34 4.89a2.79 2.79 0 001.58 1.58c1.09.43 3.68.34 4.89.34s3.8.1 4.9-.34a2.79 2.79 0 001.58-1.58c.43-1.08.33-3.68.33-4.89s.1-3.8-.33-4.9zm-6.48 9.16a4.26 4.26 0 114.26-4.26 4.25 4.25 0 01-4.26 4.26zm4.43-7.7a1 1 0 010-2 1 1 0 110 2z", "M33.64 9.11L18.32.27a2 2 0 00-2 0L1 9.11a2 2 0 00-1 1.73v17.69a2 2 0 001 1.74l15.32 8.84a2 2 0 002 0l15.32-8.84a2 2 0 001-1.74V10.84a2 2 0 00-1-1.73zm-8.07 14a5 5 0 01-1.34 3.48 4.93 4.93 0 01-3.48 1.35c-1.37.07-5.49.07-6.86 0a5 5 0 01-3.48-1.35 4.92 4.92 0 01-1.34-3.48c-.08-1.37-.08-5.48 0-6.85a5 5 0 011.34-3.48 5 5 0 013.48-1.34c1.37-.08 5.49-.08 6.86 0a5 5 0 013.48 1.34 4.94 4.94 0 011.34 3.48c.08 1.43.08 5.48 0 6.85z" ] ))


{-| <https://fontawesome.com/icons/laptop?style=solid>
-}
laptop : Icon
laptop =
    Icon (initInternals ( 640, 512, [ "M624 416H381.54c-.74 19.81-14.71 32-32.74 32H288c-18.69 0-33.02-17.47-32.77-32H16c-8.8 0-16 7.2-16 16v16c0 35.2 28.8 64 64 64h512c35.2 0 64-28.8 64-64v-16c0-8.8-7.2-16-16-16zM576 48c0-26.4-21.6-48-48-48H112C85.6 0 64 21.6 64 48v336h512V48zm-64 272H128V64h384v256z" ] ))


{-| <https://fontawesome.com/icons/lightbulb?style=solid>
-}
lightbulb : Icon
lightbulb =
    Icon (initInternals ( 352, 512, [ "M176 80c-52.94 0-96 43.06-96 96 0 8.84 7.16 16 16 16s16-7.16 16-16c0-35.3 28.72-64 64-64 8.84 0 16-7.16 16-16s-7.16-16-16-16zM96.06 459.17c0 3.15.93 6.22 2.68 8.84l24.51 36.84c2.97 4.46 7.97 7.14 13.32 7.14h78.85c5.36 0 10.36-2.68 13.32-7.14l24.51-36.84c1.74-2.62 2.67-5.7 2.68-8.84l.05-43.18H96.02l.04 43.18zM176 0C73.72 0 0 82.97 0 176c0 44.37 16.45 84.85 43.56 115.78 16.64 18.99 42.74 58.8 52.42 92.16v.06h48v-.12c-.01-4.77-.72-9.51-2.15-14.07-5.59-17.81-22.82-64.77-62.17-109.67-20.54-23.43-31.52-53.15-31.61-84.14-.2-73.64 59.67-128 127.95-128 70.58 0 128 57.42 128 128 0 30.97-11.24 60.85-31.65 84.14-39.11 44.61-56.42 91.47-62.1 109.46a47.507 47.507 0 0 0-2.22 14.3v.1h48v-.05c9.68-33.37 35.78-73.18 52.42-92.16C335.55 260.85 352 220.37 352 176 352 78.8 273.2 0 176 0z" ] ))


{-| <https://fontawesome.com/icons/linkedin-square?style=brands>
-}
linkedin : Icon
linkedin =
    Icon (initInternals ( 35, 40, [ "M33.64 9.11L18.32.26a2 2 0 00-2 0L1 9.11a2 2 0 00-1 1.73v17.69a2 2 0 001 1.73l15.32 8.85a2 2 0 002 0l15.32-8.85a2 2 0 001-1.73V10.84a2 2 0 00-1-1.73zM12.96 27.54H9.69V17.03h3.27zm-1.64-11.92a1.91 1.91 0 01-1.88-1.93 1.89 1.89 0 013.77 0 1.92 1.92 0 01-1.89 1.93zm13.87 11.92h-3.26v-5.09c0-1.24 0-2.78-1.73-2.78s-1.88 1.3-1.88 2.67v5.2H15V17.03h3.13v1.44a3.52 3.52 0 013.1-1.69c3.3 0 3.93 2.18 3.93 5z" ] ))


{-| <https://fontawesome.com/icons/map-marker-alt?style=solid>
-}
mapMarker : Icon
mapMarker =
    Icon (initInternals ( 384, 512, [ "M172.268 501.67C26.97 291.031 0 269.413 0 192 0 85.961 85.961 0 192 0s192 85.961 192 192c0 77.413-26.97 99.031-172.268 309.67-9.535 13.774-29.93 13.773-39.464 0zM192 272c44.183 0 80-35.817 80-80s-35.817-80-80-80-80 35.817-80 80 35.817 80 80 80z" ] ))


{-| <https://fontawesome.com/icons/notification?style=solid>
-}
notification : Icon
notification =
    Icon (initInternals ( 448, 512, [ "M224 512c35.32 0 63.97-28.65 63.97-64H160.03c0 35.35 28.65 64 63.97 64zm215.39-149.71c-19.32-20.76-55.47-51.99-55.47-154.29 0-77.7-54.48-139.9-127.94-155.16V32c0-17.67-14.32-32-31.98-32s-31.98 14.33-31.98 32v20.84C118.56 68.1 64.08 130.3 64.08 208c0 102.3-36.15 133.53-55.47 154.29-6 6.45-8.66 14.16-8.61 21.71.11 16.4 12.98 32 32.1 32h383.8c19.12 0 32-15.6 32.1-32 .05-7.55-2.61-15.27-8.61-21.71z" ] ))


{-| <https://fontawesome.com/icons/certificate?style=solid>
-}
new : Icon
new =
    Icon (initInternals ( 512, 512, [ "M458.622 255.92l45.985-45.005c13.708-12.977 7.316-36.039-10.664-40.339l-62.65-15.99 17.661-62.015c4.991-17.838-11.829-34.663-29.661-29.671l-61.994 17.667-15.984-62.671C337.085.197 313.765-6.276 300.99 7.228L256 53.57 211.011 7.229c-12.63-13.351-36.047-7.234-40.325 10.668l-15.984 62.671-61.995-17.667C74.87 57.907 58.056 74.738 63.046 92.572l17.661 62.015-62.65 15.99C.069 174.878-6.31 197.944 7.392 210.915l45.985 45.005-45.985 45.004c-13.708 12.977-7.316 36.039 10.664 40.339l62.65 15.99-17.661 62.015c-4.991 17.838 11.829 34.663 29.661 29.671l61.994-17.667 15.984 62.671c4.439 18.575 27.696 24.018 40.325 10.668L256 458.61l44.989 46.001c12.5 13.488 35.987 7.486 40.325-10.668l15.984-62.671 61.994 17.667c17.836 4.994 34.651-11.837 29.661-29.671l-17.661-62.015 62.65-15.99c17.987-4.302 24.366-27.367 10.664-40.339l-45.984-45.004z" ] ))


{-| <https://fontawesome.com/icons/file-pdf?style=solid>
-}
pdf : Icon
pdf =
    Icon (initInternals ( 384, 512, [ "M181.9 256.1c-5-16-4.9-46.9-2-46.9 8.4 0 7.6 36.9 2 46.9zm-1.7 47.2c-7.7 20.2-17.3 43.3-28.4 62.7 18.3-7 39-17.2 62.9-21.9-12.7-9.6-24.9-23.4-34.5-40.8zM86.1 428.1c0 .8 13.2-5.4 34.9-40.2-6.7 6.3-29.1 24.5-34.9 40.2zM248 160h136v328c0 13.3-10.7 24-24 24H24c-13.3 0-24-10.7-24-24V24C0 10.7 10.7 0 24 0h200v136c0 13.2 10.8 24 24 24zm-8 171.8c-20-12.2-33.3-29-42.7-53.8 4.5-18.5 11.6-46.6 6.2-64.2-4.7-29.4-42.4-26.5-47.8-6.8-5 18.3-.4 44.1 8.1 77-11.6 27.6-28.7 64.6-40.8 85.8-.1 0-.1.1-.2.1-27.1 13.9-73.6 44.5-54.5 68 5.6 6.9 16 10 21.5 10 17.9 0 35.7-18 61.1-61.8 25.8-8.5 54.1-19.1 79-23.2 21.7 11.8 47.1 19.5 64 19.5 29.2 0 31.2-32 19.7-43.4-13.9-13.6-54.3-9.7-73.6-7.2zM377 105L279 7c-4.5-4.5-10.6-7-17-7h-6v128h128v-6.1c0-6.3-2.5-12.4-7-16.9zm-74.1 255.3c4.1-2.7-2.5-11.9-42.8-9 37.1 15.8 42.8 9 42.8 9z" ] ))


{-| <https://fontawesome.com/icons/percentage?style=solid>
-}
percentage : Icon
percentage =
    Icon (initInternals ( 384, 512, [ "M109.25 173.25c24.99-24.99 24.99-65.52 0-90.51-24.99-24.99-65.52-24.99-90.51 0-24.99 24.99-24.99 65.52 0 90.51 25 25 65.52 25 90.51 0zm256 165.49c-24.99-24.99-65.52-24.99-90.51 0-24.99 24.99-24.99 65.52 0 90.51 24.99 24.99 65.52 24.99 90.51 0 25-24.99 25-65.51 0-90.51zm-1.94-231.43l-22.62-22.62c-12.5-12.5-32.76-12.5-45.25 0L20.69 359.44c-12.5 12.5-12.5 32.76 0 45.25l22.62 22.62c12.5 12.5 32.76 12.5 45.25 0l274.75-274.75c12.5-12.49 12.5-32.75 0-45.25z" ] ))


{-| <https://fontawesome.com/icons/phone?style=solid>
-}
phone : Icon
phone =
    Icon (initInternals ( 512, 512, [ "M493.4 24.6l-104-24c-11.3-2.6-22.9 3.3-27.5 13.9l-48 112c-4.2 9.8-1.4 21.3 6.9 28l60.6 49.6c-36 76.7-98.9 140.5-177.2 177.2l-49.6-60.6c-6.8-8.3-18.2-11.1-28-6.9l-112 48C3.9 366.5-2 378.1.6 389.4l24 104C27.1 504.2 36.7 512 48 512c256.1 0 464-207.5 464-464 0-11.2-7.7-20.9-18.6-23.4z" ] ))


{-| <https://fontawesome.com/icons/play-circle?style=solid>
-}
playCircle : Icon
playCircle =
    Icon (initInternals ( 512, 512, [ "M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zm115.7 272l-176 101c-15.8 8.8-35.7-2.5-35.7-21V152c0-18.4 19.8-29.8 35.7-21l176 107c16.4 9.2 16.4 32.9 0 42z" ] ))


{-| <https://fontawesome.com/icons/satellite-dish?style=solid>
-}
satelliteDish : Icon
satelliteDish =
    Icon (initInternals ( 512, 512, [ "M188.8 345.9l27.4-27.4c2.6.7 5 1.6 7.8 1.6 17.7 0 32-14.3 32-32s-14.3-32-32-32-32 14.3-32 32c0 2.8.9 5.2 1.6 7.8l-27.4 27.4L49.4 206.5c-7.3-7.3-20.1-6.1-25 3-41.8 77.8-29.9 176.7 35.7 242.3 65.6 65.6 164.6 77.5 242.3 35.7 9.2-4.9 10.4-17.7 3-25L188.8 345.9zM209 0c-9.2-.5-17 6.8-17 16v31.6c0 8.5 6.6 15.5 15 15.9 129.4 7 233.4 112 240.9 241.5.5 8.4 7.5 15 15.9 15h32.1c9.2 0 16.5-7.8 16-17C503.4 139.8 372.2 8.6 209 0zm.3 96c-9.3-.7-17.3 6.7-17.3 16.1v32.1c0 8.4 6.5 15.3 14.8 15.9 76.8 6.3 138 68.2 144.9 145.2.8 8.3 7.6 14.7 15.9 14.7h32.2c9.3 0 16.8-8 16.1-17.3-8.4-110.1-96.5-198.2-206.6-206.7z" ] ))


{-| <https://fontawesome.com/icons/search?style=solid>
-}
search : Icon
search =
    Icon (initInternals ( 512, 512, [ "M505 442.7L405.3 343c-4.5-4.5-10.6-7-17-7H372c27.6-35.3 44-79.7 44-128C416 93.1 322.9 0 208 0S0 93.1 0 208s93.1 208 208 208c48.3 0 92.7-16.4 128-44v16.3c0 6.4 2.5 12.5 7 17l99.7 99.7c9.4 9.4 24.6 9.4 33.9 0l28.3-28.3c9.4-9.4 9.4-24.6.1-34zM208 336c-70.7 0-128-57.2-128-128 0-70.7 57.2-128 128-128 70.7 0 128 57.2 128 128 0 70.7-57.2 128-128 128z" ] ))


{-| <https://fontawesome.com/icons/sliders-h?style=solid>
-}
slidersH : Icon
slidersH =
    Icon (initInternals ( 512, 512, [ "M496 384H160v-16c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v16H16c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h80v16c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-16h336c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm0-160h-80v-16c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v16H16c-8.8 0-16 7.2-16 16v32c0 8.8 7.2 16 16 16h336v16c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-16h80c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zm0-160H288V48c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v16H16C7.2 64 0 71.2 0 80v32c0 8.8 7.2 16 16 16h208v16c0 8.8 7.2 16 16 16h32c8.8 0 16-7.2 16-16v-16h208c8.8 0 16-7.2 16-16V80c0-8.8-7.2-16-16-16z" ] ))


{-| <https://fontawesome.com/icons/star?style=solid>
-}
star : Icon
star =
    Icon (initInternals ( 576, 512, [ "M528.1 171.5L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6zM388.6 312.3l23.7 138.4L288 385.4l-124.3 65.3 23.7-138.4-100.6-98 139-20.2 62.2-126 62.2 126 139 20.2-100.6 98z" ] ))


{-| Custom icon to mediate a tight product view table
-}
table : Icon
table =
    Icon (initInternals ( 448, 512, [ "M495.5 120h-479C7.4 120 0 112.5 0 103.4V48.5C0 39.4 7.4 32 16.5 32h478.9c9.1 0 16.5 7.4 16.5 16.5v54.9c.1 9.1-7.3 16.6-16.4 16.6zM495.5 240h-479C7.4 240 0 232.5 0 223.4v-54.9c0-9.1 7.4-16.5 16.5-16.5h478.9c9.1 0 16.5 7.4 16.5 16.5v54.9c.1 9.1-7.3 16.6-16.4 16.6zM495.5 360h-479C7.4 360 0 352.6 0 343.5v-54.9c0-9.1 7.4-16.5 16.5-16.5h478.9c9.1 0 16.5 7.4 16.5 16.5v54.9c.1 9.1-7.3 16.5-16.4 16.5zM495.5 480h-479C7.4 480 0 472.6 0 463.5v-54.9c0-9.1 7.4-16.5 16.5-16.5h478.9c9.1 0 16.5 7.4 16.5 16.5v54.9c.1 9.1-7.3 16.5-16.4 16.5z" ] ))


{-| <https://fontawesome.com/icons/th?style=solid>
-}
th : Icon
th =
    Icon (initInternals ( 512, 512, [ "M149.333 56v80c0 13.255-10.745 24-24 24H24c-13.255 0-24-10.745-24-24V56c0-13.255 10.745-24 24-24h101.333c13.255 0 24 10.745 24 24zm181.334 240v-80c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24h101.333c13.256 0 24.001-10.745 24.001-24zm32-240v80c0 13.255 10.745 24 24 24H488c13.255 0 24-10.745 24-24V56c0-13.255-10.745-24-24-24H386.667c-13.255 0-24 10.745-24 24zm-32 80V56c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24h101.333c13.256 0 24.001-10.745 24.001-24zm-205.334 56H24c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24zM0 376v80c0 13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H24c-13.255 0-24 10.745-24 24zm386.667-56H488c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H386.667c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24zm0 160H488c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H386.667c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24zM181.333 376v80c0 13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 10.745-24 24z" ] ))


{-| <https://fontawesome.com/icons/th-large?style=solid>
-}
thLarge : Icon
thLarge =
    Icon (initInternals ( 512, 512, [ "M296 32h192c13.255 0 24 10.745 24 24v160c0 13.255-10.745 24-24 24H296c-13.255 0-24-10.745-24-24V56c0-13.255 10.745-24 24-24zm-80 0H24C10.745 32 0 42.745 0 56v160c0 13.255 10.745 24 24 24h192c13.255 0 24-10.745 24-24V56c0-13.255-10.745-24-24-24zM0 296v160c0 13.255 10.745 24 24 24h192c13.255 0 24-10.745 24-24V296c0-13.255-10.745-24-24-24H24c-13.255 0-24 10.745-24 24zm296 184h192c13.255 0 24-10.745 24-24V296c0-13.255-10.745-24-24-24H296c-13.255 0-24 10.745-24 24v160c0 13.255 10.745 24 24 24z" ] ))


{-| <https://fontawesome.com/icons/th-list?style=solid>
-}
thList : Icon
thList =
    Icon (initInternals ( 512, 512, [ "M149.333 216v80c0 13.255-10.745 24-24 24H24c-13.255 0-24-10.745-24-24v-80c0-13.255 10.745-24 24-24h101.333c13.255 0 24 10.745 24 24zM0 376v80c0 13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H24c-13.255 0-24 10.745-24 24zM125.333 32H24C10.745 32 0 42.745 0 56v80c0 13.255 10.745 24 24 24h101.333c13.255 0 24-10.745 24-24V56c0-13.255-10.745-24-24-24zm80 448H488c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24zm-24-424v80c0 13.255 10.745 24 24 24H488c13.255 0 24-10.745 24-24V56c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 10.745-24 24zm24 264H488c13.255 0 24-10.745 24-24v-80c0-13.255-10.745-24-24-24H205.333c-13.255 0-24 10.745-24 24v80c0 13.255 10.745 24 24 24z" ] ))


{-| <https://fontawesome.com/icons/trash-alt?style=solid>
-}
trash : Icon
trash =
    Icon (initInternals ( 448, 512, [ "M32 464a48 48 0 0 0 48 48h288a48 48 0 0 0 48-48V128H32zm272-256a16 16 0 0 1 32 0v224a16 16 0 0 1-32 0zm-96 0a16 16 0 0 1 32 0v224a16 16 0 0 1-32 0zm-96 0a16 16 0 0 1 32 0v224a16 16 0 0 1-32 0zM432 32H312l-9.4-18.7A24 24 0 0 0 281.1 0H166.8a23.72 23.72 0 0 0-21.4 13.3L136 32H16A16 16 0 0 0 0 48v32a16 16 0 0 0 16 16h416a16 16 0 0 0 16-16V48a16 16 0 0 0-16-16z" ] ))


{-| <https://fontawesome.com/icons/truck?style=solid>
-}
truck : Icon
truck =
    Icon (initInternals ( 640, 512, [ "M624 352h-16V243.9c0-12.7-5.1-24.9-14.1-33.9L494 110.1c-9-9-21.2-14.1-33.9-14.1H416V48c0-26.5-21.5-48-48-48H48C21.5 0 0 21.5 0 48v320c0 26.5 21.5 48 48 48h16c0 53 43 96 96 96s96-43 96-96h128c0 53 43 96 96 96s96-43 96-96h48c8.8 0 16-7.2 16-16v-32c0-8.8-7.2-16-16-16zM160 464c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48zm320 0c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48zm80-208H416V144h44.1l99.9 99.9V256z" ] ))


{-| <https://fontawesome.com/icons/tv?style=solid>
-}
tv : Icon
tv =
    Icon (initInternals ( 640, 512, [ "M592 0H48C21.5 0 0 21.5 0 48v320c0 26.5 21.5 48 48 48h245.1v32h-160c-17.7 0-32 14.3-32 32s14.3 32 32 32h384c17.7 0 32-14.3 32-32s-14.3-32-32-32h-160v-32H592c26.5 0 48-21.5 48-48V48c0-26.5-21.5-48-48-48zm-16 352H64V64h512v288z" ] ))


{-| <https://fontawesome.com/icons/user?style=solid>
-}
user : Icon
user =
    Icon (initInternals ( 448, 512, [ "M224 256c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z" ] ))


{-| <https://fontawesome.com/icons/wifi?style=solid>
-}
wifi : Icon
wifi =
    Icon (initInternals ( 640, 512, [ "M634.91 154.88C457.74-8.99 182.19-8.93 5.09 154.88c-6.66 6.16-6.79 16.59-.35 22.98l34.24 33.97c6.14 6.1 16.02 6.23 22.4.38 145.92-133.68 371.3-133.71 517.25 0 6.38 5.85 16.26 5.71 22.4-.38l34.24-33.97c6.43-6.39 6.3-16.82-.36-22.98zM320 352c-35.35 0-64 28.65-64 64s28.65 64 64 64 64-28.65 64-64-28.65-64-64-64zm202.67-83.59c-115.26-101.93-290.21-101.82-405.34 0-6.9 6.1-7.12 16.69-.57 23.15l34.44 33.99c6 5.92 15.66 6.32 22.05.8 83.95-72.57 209.74-72.41 293.49 0 6.39 5.52 16.05 5.13 22.05-.8l34.44-33.99c6.56-6.46 6.33-17.06-.56-23.15z" ] ))


{-| <https://fontawesome.com/icons/youtube?style=brands>
Like all social media icons, they are mounted on a hexagon shape
-}
youtube : Icon
youtube =
    Icon (initInternals ( 35, 40, [ "M15.29 16.75l5.18 2.95-5.18 2.94v-5.89z", "M33.64 9.11L18.32.26a2 2 0 00-2 0L1 9.11a2 2 0 00-1 1.73v17.69a2 2 0 001 1.73l15.32 8.85a2 2 0 002 0l15.32-8.85a2 2 0 001-1.73V10.84a2 2 0 00-1-1.73zM26.81 24.5a2.45 2.45 0 01-1.75 1.73c-1.55.46-7.74.46-7.74.46s-6.19 0-7.74-.42a2.45 2.45 0 01-1.75-1.73 26.4 26.4 0 01-.41-4.85 26.4 26.4 0 01.41-4.8 2.49 2.49 0 011.75-1.76c1.55-.44 7.74-.44 7.74-.44s6.19 0 7.74.42a2.49 2.49 0 011.75 1.76 26.4 26.4 0 01.41 4.82 26.4 26.4 0 01-.41 4.81z" ] ))


{-| Turn an icon into Html with a container, just like Bulma

    angleDown |> toHtml == "<span class='icon'><svg>...</svg></span>"

-}
toHtml : Icon -> Html msg
toHtml (Icon internals) =
    let
        s =
            iconSize internals.size

        ( w, h, paths ) =
            internals.viewBoxAndPaths
    in
    styled Html.span
        (containerStyles internals.transforms)
        [ Html.Styled.Attributes.classList [ ( "icon", True ), ( sizeToClass internals.containerSize, True ) ] ]
        [ Svg.svg [ attribute "aria-hidden" "true", width s, height s, viewBoxtoHtml ( w, h ) ] (List.map pathToSvg paths) ]


pathToSvg : String -> Svg msg
pathToSvg str =
    Svg.path [ d str ] []


{-| Turn an icon into a data uri string, mostly to embed as a css background

    angleDown |> toDataUri == "data:image/svg+xml,%3Csvg..."

    Css.property "background-image" ("url(\"" ++ (angleDown |> toDataUri) ++ "\"), linear-gradient(to bottom, hsla(0, 0%, 96%, 1) 0%,hsla(0, 0%, 96%, 1) 100%)")

-}
toDataUri : Icon -> String
toDataUri (Icon internals) =
    let
        ( w, h, paths ) =
            internals.viewBoxAndPaths
    in
    "data:image/svg+xml,%3Csvg viewBox='0 0 " ++ String.fromInt w ++ " " ++ String.fromInt h ++ "' fill='currentColor' xmlns='http://www.w3.org/2000/svg'%3E" ++ (List.map pathtoDataUri paths |> String.join "") ++ "%3C/svg%3E"


pathtoDataUri : String -> String
pathtoDataUri path =
    "%3cpath d='" ++ path ++ "'/%3e"


{-| Change the container size, does not affect the icon's size
-}
withContainerSize : Control.Size -> Icon -> Icon
withContainerSize size (Icon internals) =
    Icon { internals | containerSize = size }


{-| Change the icon _and_ container size
-}
withSize : Control.Size -> Icon -> Icon
withSize size (Icon internals) =
    Icon { internals | size = size, containerSize = size }


{-| Apply a transformation to the icon
-}
withTransform : Transform -> Icon -> Icon
withTransform transform (Icon internals) =
    Icon { internals | transforms = transform :: internals.transforms }


sizeToClass : Control.Size -> String
sizeToClass size =
    case size of
        Control.Regular ->
            ""

        Control.Small ->
            "is-small"

        Control.Medium ->
            "is-medium"

        Control.Large ->
            "is-large"


iconSize : Control.Size -> String
iconSize size =
    case size of
        Control.Regular ->
            "16"

        Control.Small ->
            "12"

        Control.Medium ->
            "24"

        Control.Large ->
            "36"


viewBoxtoHtml : ( Int, Int ) -> Attribute msg
viewBoxtoHtml ( w, h ) =
    viewBox ("0 0 " ++ String.fromInt w ++ " " ++ String.fromInt h)


containerStyles : List Transform -> List Style
containerStyles transforms =
    [ Css.alignItems Css.center
    , Css.display Css.inlineFlex
    , Css.justifyContent Css.center
    , Css.width (Css.rem 1.5)
    , Css.height (Css.rem 1.5)
    , Css.Global.withClass "is-small"
        [ Css.width (Css.rem 1)
        , Css.height (Css.rem 1)
        ]
    , Css.Global.withClass "is-medium"
        [ Css.width (Css.rem 2)
        , Css.height (Css.rem 2)
        ]
    , Css.Global.withClass "is-large"
        [ Css.width (Css.rem 3)
        , Css.height (Css.rem 3)
        ]
    , Css.Global.descendants
        [ Css.Global.typeSelector "svg"
            (Css.fill Css.currentColor :: List.concatMap transformToStyle transforms)
        ]
    ]


transformToStyle : Transform -> List Style
transformToStyle transform =
    case transform of
        Rotate deg ->
            [ Css.transform (Css.rotate (Css.deg deg))
            ]

        FlipX ->
            [ Css.transform (Css.scaleX -1)
            ]

        FlipY ->
            [ Css.transform (Css.scaleY -1)
            ]

        Spin ->
            [ Css.animationDuration (Css.sec 1)
            , Css.property "animation-iteration-count" "infinite"
            , Css.property "animation-timing-function" "linear"
            , Css.animationName
                (Css.Animations.keyframes
                    [ ( 0, [ Css.Animations.transform [ Css.rotate (Css.deg 0) ] ] )
                    , ( 100, [ Css.Animations.transform [ Css.rotate (Css.deg 360) ] ] )
                    ]
                )
            ]
