module SE.Framework.Utils exposing (desktop, desktopWidth, gap)

import Css exposing (Style, px)
import Css.Media as Media exposing (minWidth, only, screen)


{-| Pixel value
-}
gap : Float
gap =
    64


desktopWidth : Float
desktopWidth =
    960 + (2 * gap)



-- @media screen and (min-width: $desktop)


desktop : List Style -> Style
desktop =
    Media.withMedia [ only screen [ minWidth (px desktopWidth) ] ]
