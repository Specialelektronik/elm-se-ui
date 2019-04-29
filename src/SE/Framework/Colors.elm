module SE.Framework.Colors exposing
    ( white, lightest, lighter, light, base, dark, darker, darkest, black
    , primary, primaryHover, primaryActive, link, linkHover, linkActive, info, infoHover, infoActive, success, successHover, successActive, warning, warningHover, warningActive, danger, dangerHover, dangerActive
    , border, background, backgroundHover, backgroundActive, text
    )

{-| The colors we use. The grey hues are taken from Tailwind CSS. But we use the color names from Bulma. The grey hues have a little more blue which (in my opinion) makes then feel a little more "sophisticated" and calming. Also, plain grey does not have the same depth a the blue-ish version.

<https://bulma.io/documentation/overview/colors/> and <https://tailwindcss.com/docs/colors>


# Greys

@docs white, lightest, lighter, light, base, dark, darker, darkest, black


# Colors

@docs primary, primaryHover, primaryActive, link, linkHover, linkActive, info, infoHover, infoActive, success, successHover, successActive, warning, warningHover, warningActive, danger, dangerHover, dangerActive


# Derived colors

@docs border, background, backgroundHover, backgroundActive, text

-}

import Css exposing (hsl, rgba)


{-| White, mostly used as background
-}
white : Css.Color
white =
    Css.rgb 255 255 255


{-| The lightest shade of gray, used as background to make something pop from the regular white background.
-}
lightest : Css.Color
lightest =
    Css.rgb 248 250 252


{-| The lighter shade is used as a hover color for `lightest`.
-}
lighter : Css.Color
lighter =
    Css.rgb 241 245 248


{-| The light shade functions as the regular border color.
-}
light : Css.Color
light =
    Css.rgb 218 225 231


{-| Base grey, not used a lot.
-}
base : Css.Color
base =
    Css.rgb 184 194 204


{-| Dark grey, not used a lot.
-}
dark : Css.Color
dark =
    Css.rgb 135 149 161


{-| The darker grey can be used to de-emphasis text.
-}
darker : Css.Color
darker =
    Css.rgb 96 111 123


{-| The standard text color.
-}
darkest : Css.Color
darkest =
    Css.rgb 61 72 82


{-| The "black" color (it's not entirely black) is used as a text color when the background is not white or to emphasis text.
-}
black : Css.Color
black =
    Css.rgb 34 41 47


{-| Our primary green color, the same color is used as the "success" color.
-}
primary : Css.Color
primary =
    Css.rgb 53 157 55


{-| The color used when primary is hovered.
-}
primaryHover : Css.Color
primaryHover =
    Css.rgb 47 138 48


{-| The color used when primary is "active" (i.e. clicked).
-}
primaryActive : Css.Color
primaryActive =
    Css.rgb 40 119 42


{-| The color used for links.
-}
link : Css.Color
link =
    Css.rgb 50 115 220


{-| The color used when links are hovered.
-}
linkHover : Css.Color
linkHover =
    Css.rgb 36 102 209


{-| The color used when links are active.
-}
linkActive : Css.Color
linkActive =
    Css.rgb 32 91 187


{-| The info color a lighter blue than link, it's used for notifications and messages.
-}
info : Css.Color
info =
    Css.rgb 32 156 238


{-| The color used when info is hovered.
-}
infoHover : Css.Color
infoHover =
    Css.rgb 17 143 228


{-| The color used when info is "active" (i.e. clicked).
-}
infoActive : Css.Color
infoActive =
    Css.rgb 15 129 204


{-| Alias for primary.

In Bulma, success is a bright green color to express a success result of an action like "Saved!" or "Item #123 placed in the basket.". Since our primary color is green, we use primary and success interchangeably.

-}
success : Css.Color
success =
    primary


{-| Alias for primaryHover.
-}
successHover : Css.Color
successHover =
    primaryHover


{-| Alias for primaryActive.
-}
successActive : Css.Color
successActive =
    primaryActive


{-| An orange hue. Warning indicates something that the user should be alerted about. It's not as heavy as "danger".
-}
warning : Css.Color
warning =
    Css.rgb 255 221 87


{-| The color used when warning is hovered.
-}
warningHover : Css.Color
warningHover =
    Css.rgb 255 216 62


{-| The color used when warning is "active" (i.e. clicked).
-}
warningActive : Css.Color
warningActive =
    Css.rgb 255 211 36


{-| A red hue indicating an error.
-}
danger : Css.Color
danger =
    Css.rgb 255 56 96


{-| The color used when danger is hovered.
-}
dangerHover : Css.Color
dangerHover =
    Css.rgb 255 31 76


{-| The color used when danger is "active" (i.e. clicked).
-}
dangerActive : Css.Color
dangerActive =
    Css.rgb 255 5 55


{-| Alias for light.
-}
border : Css.Color
border =
    light


{-| Alias for lightest.
-}
background : Css.Color
background =
    lightest


{-| The color used when background is hovered.
-}
backgroundHover : Css.Color
backgroundHover =
    lighter


{-| The color used when background is "active" (i.e. clicked).
-}
backgroundActive : Css.Color
backgroundActive =
    light


{-| Alias for darkest.
-}
text : Css.Color
text =
    darkest
