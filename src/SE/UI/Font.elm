module SE.UI.Font exposing
    ( remSize, emSize
    , family, codeFamily
    , desktopBaseSize, mobileBaseSize
    )

{-| Font settings


# Sizes

We calculate the size based on a base size (the base size is different for desktop and mobile) and a factor. In mobile the base size is 100% (16px) and the scaling factor is 1.125 which means that a "Size 3" equals (1\_1.125^2 = 1.265625/1.266em/20.25px). The factor is 1-based, BUT the "Size 0" is equal to "Size 1" in order to avoid confusion. However, a "Size -3" equals (1\_1.125^-3 = 0.790123457/0.79em/12.64px)

    SE.UI.Font.remSize 2
        == Css.batch
            [ Css.fontSize (Css.rem (1.125 ^ 1))
            , SE.UI.Utils.desktop
                [ Css.fontSize (Css.rem (1.2 ^ 1))
                ]
            ]

@docs remSize, emSize


# Font families

We use system fonts for the most part. Because : <https://medium.com/needmore-notes/using-system-fonts-for-web-apps-bf76d214a0e0>

@docs family, codeFamily

-}

import Css exposing (Style)
import SE.UI.Utils as Utils


family : String
family =
    "BlinkMacSystemFont, -apple-system, \"Segoe UI\", \"Roboto\", \"Oxygen\", \"Ubuntu\", \"Cantarell\", \"Fira Sans\", \"Droid Sans\", \"Helvetica Neue\", \"Helvetica\", \"Arial\", sans-serif"


codeFamily : String
codeFamily =
    "monospace"



-- FONT SIZES
-- base font size


desktopBaseSize =
    Css.pct 112.5


mobileBaseSize =
    Css.pct 100



-- font scale


desktopScale =
    1.2


mobileScale =
    1.125


type alias Factor =
    Float


{-| One-based index factor with which we calculate the size on both desktop and mobile.
-}
remSize : Factor -> Style
remSize =
    sizeHelper Css.rem


emSize : Factor -> Style
emSize =
    sizeHelper Css.em


sizeHelper fn factor =
    let
        exponent =
            if factor >= 1 then
                factor - 1

            else
                factor
    in
    Css.batch
        [ Css.fontSize (fn (mobileScale ^ exponent))
        , Utils.desktop
            [ Css.fontSize (fn (desktopScale ^ exponent))
            ]
        ]
