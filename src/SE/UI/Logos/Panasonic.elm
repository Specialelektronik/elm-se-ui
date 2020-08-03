module SE.UI.Logos.Panasonic exposing (onWhite, onBlack, IsMonochrome)

{-| Panasonic Business logos

All Panasonic Business logos are trademarks of Crestron Electronics, Inc. (<https://business.panasonic.se/terms-conditions>)

The logo comes in color (The "Business" byline is in blue) and monochrome

@docs onWhite, onBlack, IsMonochrome

-}

import Css
import Html.Styled exposing (Html)
import Svg.Styled as Svg exposing (styled)
import Svg.Styled.Attributes as Attributes exposing (class, d, fill, fillRule, height, viewBox, width, x, y)


{-| Use this logo on light backgrounds
-}
onWhite : IsMonochrome -> Html msg
onWhite isMonochrome =
    logo isMonochrome blackHex


{-| Use this logo on dark backgrounds
-}
onBlack : IsMonochrome -> Html msg
onBlack isMonochrome =
    logo isMonochrome whiteHex


{-| Type alias for Bool
-}
type alias IsMonochrome =
    Bool


blackHex : String
blackHex =
    "#000"


whiteHex : String
whiteHex =
    "#fff"


blueHex : String
blueHex =
    "#0068aa"


logo : IsMonochrome -> String -> Html msg
logo isMonochrome firstColor =
    let
        secondColor =
            if isMonochrome then
                firstColor

            else
                blueHex
    in
    Svg.svg [ viewBox "0 0 166.72 47.3" ]
        [ styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M164.89,22.65a8.75,8.75,0,0,1-4.77,2.65,12,12,0,0,1-3.73.18,8.86,8.86,0,0,1-4.57-1.79,9.55,9.55,0,0,1-2.67-3,8.35,8.35,0,0,1-1.06-3,9.74,9.74,0,0,1,.22-4.33,8.79,8.79,0,0,1,6.84-6.47,11.66,11.66,0,0,1,5.6.13A7.7,7.7,0,0,1,164.25,9a7.19,7.19,0,0,1,1.53,2,5.42,5.42,0,0,1,.62,2.9h-6.07a3,3,0,0,0-1.18-2,2.48,2.48,0,0,0-2.86-.14,2.77,2.77,0,0,0-1.24,1.62,8.08,8.08,0,0,0-.08,4.89A3.7,3.7,0,0,0,156,20.06a2.58,2.58,0,0,0,2.2.69,2.06,2.06,0,0,0,1.28-.69,2.66,2.66,0,0,0,.66-1.38,8,8,0,0,0,.13-1.08h6.41a6.51,6.51,0,0,1-1.82,5" ] []
        , styled Svg.rect [ Css.fill (Css.hex firstColor) ] [ x "140.39", width "6.65", height "4.71" ] []
        , styled Svg.rect [ Css.fill (Css.hex firstColor) ] [ x "140.39", y "7.13", width "6.65", height "17.84" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M126.63,9a10.94,10.94,0,0,1,2.76-1.8,7.18,7.18,0,0,1,5.25-.39,5.75,5.75,0,0,1,4,3.89,8.76,8.76,0,0,1,.42,2.74V25H132V14.62a3.22,3.22,0,0,0-.15-1,2,2,0,0,0-1.14-1.28,2.66,2.66,0,0,0-3.36,1.12A3,3,0,0,0,126.9,15V25h-6.83V7.13h6.41L126.63,9" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M48,9a10.94,10.94,0,0,1,2.76-1.8A7.18,7.18,0,0,1,56,6.83a5.73,5.73,0,0,1,4,3.89,8.76,8.76,0,0,1,.42,2.74V25H53.36V14.62a3.21,3.21,0,0,0-.14-1,2,2,0,0,0-1.15-1.28,2.65,2.65,0,0,0-3.35,1.12A2.71,2.71,0,0,0,48.3,15V25H41.46V7.13h6.41L48,9" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M89.91,18.41a10.28,10.28,0,0,1,1.43.35,1.15,1.15,0,0,1,.77.88,1.32,1.32,0,0,1-.36,1.23,2,2,0,0,1-1.18.6,3.49,3.49,0,0,1-1.78-.16,2.35,2.35,0,0,1-.75-.44,1.9,1.9,0,0,1-.63-.94,3.35,3.35,0,0,1-.13-.95H80.77v.38a4.52,4.52,0,0,0,.32,1.71,5.41,5.41,0,0,0,1.44,2.17,6.93,6.93,0,0,0,3,1.67,15.72,15.72,0,0,0,7.05.45,9.77,9.77,0,0,0,3.16-1,6.64,6.64,0,0,0,1.23-.83,5.43,5.43,0,0,0,1.7-5.93,4.38,4.38,0,0,0-1.33-2,7.75,7.75,0,0,0-3-1.61l-.71-.2a32.45,32.45,0,0,0-4-.86c-.38,0-.71-.12-1.08-.2a2.19,2.19,0,0,1-.49-.17.8.8,0,0,1-.39-1.06s0,0,0,0a1.6,1.6,0,0,1,1-.77,3.54,3.54,0,0,1,2.16.05,1.64,1.64,0,0,1,1.11,1.63h6.26a6.05,6.05,0,0,0-.38-2.15A3.83,3.83,0,0,0,96.5,8.35a6,6,0,0,0-1.67-.95A8.52,8.52,0,0,0,93,6.89a18.55,18.55,0,0,0-4.46-.26A14.27,14.27,0,0,0,86,7a7.76,7.76,0,0,0-3.1,1.49,4.91,4.91,0,0,0-1.69,2.37A4.54,4.54,0,0,0,81,12.17a5,5,0,0,0,.37,2.17,4.72,4.72,0,0,0,2.73,2.75,10.83,10.83,0,0,0,1.94.58c1.36.28,2.53.5,3.9.74" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M12.11,17.28H7.55V11.43h3c.57,0,1.05,0,1.61,0a2.47,2.47,0,0,0,1.89-1,2.4,2.4,0,0,0,.45-1.08,3.72,3.72,0,0,0,0-1A2.5,2.5,0,0,0,12,6H7.55V25H0V0H12.34c.49,0,.91,0,1.4,0A8.43,8.43,0,0,1,21.1,5a8.55,8.55,0,0,1,.78,4.75,8.11,8.11,0,0,1-6.41,7.15,15.1,15.1,0,0,1-3.36.36" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M111.23,6.79a12.38,12.38,0,0,0-2-.16,12.2,12.2,0,0,0-2,.16A9.18,9.18,0,0,0,102,9.37a8.46,8.46,0,0,0-2.67,5.56,10.36,10.36,0,0,0,.35,3.84A8.81,8.81,0,0,0,103,23.61a8.54,8.54,0,0,0,3.5,1.64,13.23,13.23,0,0,0,5.51,0,8.58,8.58,0,0,0,3.51-1.64l-3.82-4.18a2.67,2.67,0,0,1-3.54,1.35,2.62,2.62,0,0,1-1.35-1.35,6.68,6.68,0,0,1-.5-1.72,9.79,9.79,0,0,1,.08-3.58,4.72,4.72,0,0,1,.69-1.72,2.59,2.59,0,0,1,3.6-.75,2.44,2.44,0,0,1,.75.75,4.39,4.39,0,0,1,.69,1.72,9.79,9.79,0,0,1,.08,3.58,6.68,6.68,0,0,1-.5,1.72l3.82,4.18a8.79,8.79,0,0,0,3.25-4.84,10,10,0,0,0,.35-3.84,8.46,8.46,0,0,0-2.67-5.56,9.15,9.15,0,0,0-5.18-2.58" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M80.05,23.57c-.1-1.48-.15-2.72-.18-4.19,0-1.94-.07-3.58-.08-5.51a11.24,11.24,0,0,0-.38-2.94,4.64,4.64,0,0,0-2.31-3,7.45,7.45,0,0,0-2.19-.83A18.44,18.44,0,0,0,67.51,7a8.91,8.91,0,0,0-2,.59A5.37,5.37,0,0,0,62.33,11a4.26,4.26,0,0,0-.17,1.84,1.26,1.26,0,0,0,.1.33l6,.15a2.46,2.46,0,0,1,.17-1.07,1.8,1.8,0,0,1,1.13-1.14,3.54,3.54,0,0,1,2.38,0A1.65,1.65,0,0,1,73,12.19a1,1,0,0,1-.15,1,1.43,1.43,0,0,1-.68.54,4.51,4.51,0,0,1-.52.17c-.83.22-1.54.37-2.38.52-.68.11-1.24.21-1.91.35a22,22,0,0,0-2.54.66,5.25,5.25,0,0,0-2.06,1.21,4.37,4.37,0,0,0-1.42,2.7,5.39,5.39,0,0,0,.09,2.08A4.92,4.92,0,0,0,65,25.14a8.62,8.62,0,0,0,5.88-.3,5.58,5.58,0,0,0,2.33-1.71l-.42-3.06a2.57,2.57,0,0,1-1.18,1,4.38,4.38,0,0,1-1.42.37,3.15,3.15,0,0,1-1.22-.1,1.76,1.76,0,0,1-.84-.52,1.4,1.4,0,0,1-.39-.74,1.22,1.22,0,0,1,.4-1.18,2.47,2.47,0,0,1,.75-.44c.7-.26,1.29-.45,2-.65a16.12,16.12,0,0,0,2.38-.88,6.82,6.82,0,0,1,0,1.86,2.92,2.92,0,0,1-.47,1.27l.42,3.06c.13.44.25.81.4,1.23a1.57,1.57,0,0,0,.36.61h6.59a2.81,2.81,0,0,1-.46-1.4" ] []
        , styled Svg.path [ Css.fill (Css.hex firstColor) ] [ d "M40.15,23.57c-.1-1.48-.16-2.72-.18-4.19,0-1.94-.06-3.58-.08-5.51a11.68,11.68,0,0,0-.38-2.94,4.64,4.64,0,0,0-2.31-3A7.39,7.39,0,0,0,35,7.1,18.49,18.49,0,0,0,27.61,7a8.76,8.76,0,0,0-2,.59A5.36,5.36,0,0,0,22.44,11a4.26,4.26,0,0,0-.17,1.84,1.24,1.24,0,0,0,.09.33l6,.15a2.61,2.61,0,0,1,.16-1.07,1.81,1.81,0,0,1,1.12-1.14,3.59,3.59,0,0,1,2.4,0,1.67,1.67,0,0,1,1.08,1.11,1.14,1.14,0,0,1-.15,1,1.41,1.41,0,0,1-.69.54,4.36,4.36,0,0,1-.51.17c-.83.22-1.54.37-2.39.52-.68.11-1.24.21-1.91.35a22.57,22.57,0,0,0-2.54.66,5.21,5.21,0,0,0-2.05,1.21,4.38,4.38,0,0,0-1.43,2.7,5.81,5.81,0,0,0,.08,2.08,5,5,0,0,0,3.54,3.77,8.62,8.62,0,0,0,5.88-.3,5.55,5.55,0,0,0,2.32-1.71l-.42-3.06a2.48,2.48,0,0,1-1.18,1,4.32,4.32,0,0,1-1.42.37,3.15,3.15,0,0,1-1.22-.1,1.76,1.76,0,0,1-.84-.52,1.48,1.48,0,0,1-.39-.74,1.2,1.2,0,0,1,.4-1.18,2.4,2.4,0,0,1,.76-.44c.69-.26,1.28-.45,2-.65a17.48,17.48,0,0,0,2.38-.88,6.82,6.82,0,0,1,0,1.86,2.8,2.8,0,0,1-.47,1.27l.42,3.06c.14.44.25.81.41,1.23A1.68,1.68,0,0,0,34,25h6.59a2.91,2.91,0,0,1-.46-1.4" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M44.33,35.2c4.15,0,5.12,1.3,5.12,3a2.57,2.57,0,0,1-1.7,2.56c-.18.07-.19.09-.19.14s0,0,.17.07a2.72,2.72,0,0,1,2.06,2.67c0,2.46-1.63,3.66-5,3.66a10.18,10.18,0,0,1-3.45-.4,1,1,0,0,1-.69-1V35.6c0-.11.07-.16.17-.18A28.91,28.91,0,0,1,44.33,35.2Zm1.06,5.13a1.57,1.57,0,0,0,1.87-1.77c0-1.13-.83-1.84-2.84-1.84-.33,0-1.09,0-1.49.09-.1,0-.16,0-.16.12V45a.45.45,0,0,0,.37.46,5.37,5.37,0,0,0,1.56.2c2.23,0,2.94-.59,2.94-2,0-1.83-2.23-2-3.76-2C44,40.59,44.42,40.28,45.39,40.33Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M54.58,41.09c0,3.5.38,4.53,2.93,4.53s3.07-1.53,3.07-5.17a27.51,27.51,0,0,0-.42-5.22h.38c1.08,0,1.56,0,1.74.28.29.43.43,2.2.43,5.25,0,4.46-1.32,6.54-5.29,6.54-4.56,0-5-2.26-5-5.07V35.51a.16.16,0,0,1,.17-.17h1.79a.16.16,0,0,1,.17.17Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M69.11,41.8c-2.58-.9-3.54-1.49-3.54-3.41,0-2.27,1.91-3.23,4.65-3.23a5.8,5.8,0,0,1,3.17.63.79.79,0,0,1,.28.74,2.37,2.37,0,0,1-.18.87,8,8,0,0,0-3.19-.68c-1.87,0-2.66.59-2.66,1.62,0,.88.57,1.26,2.89,2,2.58.8,3.42,1.75,3.42,3.35,0,2.67-1.72,3.64-4.91,3.64a5.08,5.08,0,0,1-3.21-.75,1.77,1.77,0,0,1-.59-1.39V45a12.94,12.94,0,0,0,3.94.64c1.9,0,2.62-.69,2.62-1.8S71.07,42.48,69.11,41.8Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M76.86,35.51a.16.16,0,0,1,.17-.17h1.79a.16.16,0,0,1,.17.17V46.39c0,.61-.26.73-1.42.73H77c-.12,0-.17,0-.17-.17Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M91.4,42.2a36.3,36.3,0,0,0-.5-6.92h.38c1.08,0,1.62,0,1.75.32s.25,2.94.25,6.53a19,19,0,0,1-.35,4.65c-.09.22-.33.34-1.49.34h-.17a.85.85,0,0,1-.54-.15,38.52,38.52,0,0,1-6.07-9.14.1.1,0,0,0-.19,0l.17,8.52c0,.61-.29.73-1.45.73H82.7c-.12,0-.17,0-.17-.17V35.51a.16.16,0,0,1,.17-.17h2.78c.1,0,.15.07.2.17a44.83,44.83,0,0,0,5.46,8.84c.09.1.19.1.21,0C91.39,43.74,91.4,43,91.4,42.2Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M96.78,46.5a14,14,0,0,1-.08-2.2v-6c0-1.84.06-2.41.27-2.62s.54-.34,2.29-.34h1.51c.76,0,2.63,0,3.41-.07,0,.71-.05,1.18-.38,1.47s-.74.28-3.33.28h-1c-.56,0-.66.19-.66,1.07v2.15h.6c.77,0,3.42,0,4.2-.1,0,.71,0,1.18-.38,1.47s-1.41.31-4.23.31c-.16,0-.19.07-.19.23V45c0,.5.07.57,1.18.57a28.21,28.21,0,0,0,4.38-.3A2.4,2.4,0,0,1,104,46.9c-.29.26-1.23.31-4.44.31C97.48,47.21,96.9,47,96.78,46.5Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M110.24,41.8c-2.59-.9-3.54-1.49-3.54-3.41,0-2.27,1.91-3.23,4.65-3.23a5.84,5.84,0,0,1,3.17.63c.21.17.27.34.27.74a2.36,2.36,0,0,1-.17.87,8,8,0,0,0-3.19-.68c-1.87,0-2.67.59-2.67,1.62,0,.88.57,1.26,2.9,2,2.58.8,3.41,1.75,3.41,3.35,0,2.67-1.71,3.64-4.9,3.64a5.07,5.07,0,0,1-3.21-.75,1.77,1.77,0,0,1-.59-1.39V45a12.89,12.89,0,0,0,3.94.64c1.9,0,2.61-.69,2.61-1.8S112.2,42.48,110.24,41.8Z" ] []
        , styled Svg.path [ Css.fill (Css.hex secondColor) ] [ d "M121,41.8c-2.58-.9-3.54-1.49-3.54-3.41,0-2.27,1.91-3.23,4.65-3.23a5.82,5.82,0,0,1,3.17.63.79.79,0,0,1,.28.74,2.37,2.37,0,0,1-.18.87,8,8,0,0,0-3.19-.68c-1.87,0-2.66.59-2.66,1.62,0,.88.57,1.26,2.89,2,2.58.8,3.41,1.75,3.41,3.35,0,2.67-1.71,3.64-4.9,3.64a5.08,5.08,0,0,1-3.21-.75,1.77,1.77,0,0,1-.59-1.39V45a12.94,12.94,0,0,0,3.94.64c1.9,0,2.62-.69,2.62-1.8S122.93,42.48,121,41.8Z" ] []
        ]
