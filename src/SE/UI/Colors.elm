module SE.UI.Colors exposing
    ( Color(..), toHsla, Hsla, toCss, mapHue, mapSaturation, mapLightness, mapAlpha
    , white, lightest, lighter, light, base, dark, darker, darkest, black
    , primary, link, buy, danger, bargain, darkGreen, lightBlue
    , border, background, text
    , hover, active, invert
    , color, backgroundColor, borderColor
    )

{-| The colors we use. Some color names are from Bulma but not all of them.

We use a custom type and the HSLA Scale (Hue, saturation, lightness, alpha) since Elm Css does not properly support hsla (hsl and hsla values are converted to hex immediately).

    Colors.primary |> Colors.toCss == Css.Color { alpha = 1, blue = 0, color = Compatible, green = 0, red = 0, value = "hsla(138, 100%, 31%, 1)" }

    Colors.primary |> Colors.hover |> Colors.toCss == Css.Color 0 158 47 1

<https://bulma.io/documentation/overview/colors/>

@docs Color, toHsla, Hsla, toCss, mapHue, mapSaturation, mapLightness, mapAlpha


# Greys

@docs white, lightest, lighter, light, base, dark, darker, darkest, black


# Colors

@docs primary, link, buy, danger, bargain, darkGreen, lightBlue


# Derived colors

@docs border, background, text


# Modifiers

@docs hover, active, invert


# Css utilities

@docs color, backgroundColor, borderColor

-}

import Css


type Color
    = White
    | Lightest
    | Lighter
    | Light
    | Base
    | Dark
    | Darker
    | Darkest
    | Black
    | Primary
    | Link
    | Buy
    | Danger
    | Bargain
    | DarkGreen
    | LightBlue


toHsla : Color -> Hsla
toHsla color_ =
    case color_ of
        White ->
            white

        Lightest ->
            lightest

        Lighter ->
            lighter

        Light ->
            light

        Base ->
            base

        Dark ->
            dark

        Darker ->
            darker

        Darkest ->
            darkest

        Black ->
            black

        Primary ->
            primary

        Link ->
            link

        Buy ->
            buy

        Danger ->
            danger

        Bargain ->
            bargain

        DarkGreen ->
            darkGreen

        LightBlue ->
            lightBlue


type Hsla
    = Hsla Hue Saturation Lightness Alpha


type alias Hue =
    Int


type alias Saturation =
    Float


type alias Lightness =
    Float


type alias Alpha =
    Float



-- GREYS


white : Hsla
white =
    Hsla 0 0 1 1


{-| #f4f4f4
-}
lightest : Hsla
lightest =
    Hsla 0 0 0.96 1


{-| #e5e6e6
-}
lighter : Hsla
lighter =
    Hsla 180 0.02 0.9 1


{-| #c7c8cA
-}
light : Hsla
light =
    Hsla 220 0.03 0.79 1


{-| #8f9295
-}
base : Hsla
base =
    Hsla 210 0.03 0.57 1


{-| #45494e
-}
dark : Hsla
dark =
    Hsla 213 0.06 0.29 1


{-| #292c2f
-}
darker : Hsla
darker =
    Hsla 210 0.07 0.17 1


{-| #0e0f10
-}
darkest : Hsla
darkest =
    Hsla 210 0.07 0.06 1


{-| #000000
-}
black : Hsla
black =
    Hsla 0 0 0 1



-- COLORS


{-| #009e2f Green
-}
primary : Hsla
primary =
    Hsla 138 1 0.31 1


{-| #1a6bd4 Blue
-}
link : Hsla
link =
    Hsla 214 0.78 0.47 1


{-| #daa52f Orange
-}
buy : Hsla
buy =
    Hsla 41 0.7 0.52 1


{-| #ff69b4 Hot pink
-}
bargain : Hsla
bargain =
    Hsla 330 1 0.71 1


{-| Dark green #0a373e
-}
darkGreen : Hsla
darkGreen =
    Hsla 188 0.72 0.14 1


{-| #f8f9fB Light blue-grey
-}
lightBlue : Hsla
lightBlue =
    Hsla 220 0.27 0.98 1


danger : Hsla
danger =
    Hsla 0 1 0.5 1



-- DERIVED COLORS


{-| Alias for light.
-}
border : Hsla
border =
    lighter


{-| Alias for lightest.
-}
background : Hsla
background =
    lightest


{-| Alias for darkest.
-}
text : Hsla
text =
    darkest


hover : Hsla -> Hsla
hover =
    mapLightness ((*) 0.9)


active : Hsla -> Hsla
active =
    mapLightness ((*) 0.8)


{-| Invert the color to either black or white
-}
invert : Hsla -> Hsla
invert ((Hsla _ _ lightness _) as hsla) =
    if hsla == bargain then
        white

    else if lightness < 0.65 then
        white

    else
        black |> mapAlpha ((*) 0.7)


mapHue : (Int -> Int) -> Hsla -> Hsla
mapHue f (Hsla hue saturation lightness alpha) =
    Hsla (f hue) saturation lightness alpha


mapSaturation : (Float -> Float) -> Hsla -> Hsla
mapSaturation f (Hsla hue saturation lightness alpha) =
    Hsla hue (f saturation) lightness alpha


mapLightness : (Float -> Float) -> Hsla -> Hsla
mapLightness f (Hsla hue saturation lightness alpha) =
    Hsla hue saturation (f lightness) alpha


mapAlpha : (Float -> Float) -> Hsla -> Hsla
mapAlpha f (Hsla hue saturation lightness alpha) =
    Hsla hue saturation lightness (f alpha)


{-| Transform our custom color to a color that Elm Css understands
-}
toCss : Hsla -> Css.Color
toCss (Hsla hue saturation lightness alpha) =
    Css.hsla (toFloat hue) saturation lightness alpha


backgroundColor : Hsla -> Css.Style
backgroundColor =
    toCss >> Css.backgroundColor


color : Hsla -> Css.Style
color =
    toCss >> Css.color


borderColor : Hsla -> Css.Style
borderColor =
    toCss >> Css.borderColor
