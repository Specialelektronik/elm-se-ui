module SE.UI.Font exposing
    ( desktopBaseSize, mobileBaseSize, titleSizeEm, titleSizeRem, bodySizeEm, bodySizeRem
    , family, codeFamily
    , textButtonStyles
    )

{-| Font settings


# Sizes

We calculate the title size based on a base size (the base size is different for desktop and mobile) and a factor. In mobile the base size is 100% (16px) and the scaling factor is 1.125 which means that a "Size 3" equals (1\_1.125^2 = 1.265625/1.266em/20.25px). The factor is 1-based, BUT the "Size 0" is equal to "Size 1" in order to avoid confusion. However, a "Size -3" equals (1\_1.125^-3 = 0.790123457/0.79em/12.64px)

    SE.UI.Font.titleSizeEm 2
        == Css.batch
            [ Css.fontSize (Css.rem (1.125 ^ 1))
            , SE.UI.Utils.desktop
                [ Css.fontSize (Css.rem (1.2 ^ 1))
                ]
            ]

Body size is calculated similarly but instead uses a factor of (2/18 for desktop, 2/16 for mobile)

@docs desktopBaseSize, mobileBaseSize, titleSizeEm, titleSizeRem, bodySizeEm, bodySizeRem


# Font families

We use system fonts for the most part. Because : <https://medium.com/needmore-notes/using-system-fonts-for-web-apps-bf76d214a0e0>

@docs family, codeFamily


# Styles

@docs textButtonStyles

-}

import Css exposing (Style)
import SE.UI.Colors as Colors
import SE.UI.Utils as Utils


family : String
family =
    "BlinkMacSystemFont, -apple-system, \"Segoe UI\", \"Roboto\", \"Oxygen\", \"Ubuntu\", \"Cantarell\", \"Fira Sans\", \"Droid Sans\", \"Helvetica Neue\", \"Helvetica\", \"Arial\", sans-serif"


codeFamily : String
codeFamily =
    "monospace"



-- FONT SIZES
-- base font size


{-| 18 px
-}
desktopBaseSize =
    Css.pct 112.5


{-| 16 px
-}
mobileBaseSize =
    Css.pct 100



-- font scale


{-| Base size = 18 and 2 pixels in each step
-}
desktopBodyScale =
    2 / 18


{-| Base size = 16 and 2 pixels in each step
-}
mobileBodyScale =
    2 / 16


desktopTitleScale =
    1.2


mobileTitleScale =
    1.125


type alias Factor =
    Float


type alias Exponent =
    Float


{-| One-based index factor with which we calculate the size on both desktop and mobile.
-}
titleSizeRem : Exponent -> Style
titleSizeRem =
    titleSizeHelper Css.rem


titleSizeEm : Exponent -> Style
titleSizeEm =
    titleSizeHelper Css.em


titleSizeHelper fn exponent =
    let
        newExponent =
            if exponent >= 1 then
                exponent - 1

            else
                exponent
    in
    Css.batch
        [ Css.fontSize (fn (mobileTitleScale ^ newExponent))
        , Utils.desktop
            [ Css.fontSize (fn (desktopTitleScale ^ newExponent))
            ]
        ]


bodySizeRem : Factor -> Style
bodySizeRem =
    bodySizeHelper Css.rem


bodySizeEm : Factor -> Style
bodySizeEm =
    bodySizeHelper Css.em


{-| Examples:

Factor 1 = 1em/1rem
Factor 2 = 1.1111em/rem (1.125em/rem in mobile)

-}
bodySizeHelper fn factor =
    let
        newFactor =
            if factor >= 1 then
                factor - 1

            else
                factor
    in
    Css.batch
        [ Css.fontSize (fn (1 + (mobileBodyScale * newFactor)))
        , Utils.desktop
            [ Css.fontSize (fn (1 + (desktopBodyScale * newFactor)))
            ]
        ]



-- STYLES


{-| Use these styles to create our "text button" (it's actually more of a link)

    styled Html.a
        Font.textButtonStyles
        [ Html.Attributes.href "/url" ]
        [ Html.text "Visa mer"
        , SE.UI.Icon.angleDown Control.Small
        ]

-}
textButtonStyles : List Style
textButtonStyles =
    [ Css.display Css.inlineBlock
    , Css.position Css.relative
    , Colors.color Colors.text
    , Css.textTransform Css.uppercase
    , Css.fontWeight (Css.int 600)
    , bodySizeEm -2
    , Css.letterSpacing (Css.px 1)
    , Css.paddingBottom (Css.px 2)
    , Css.borderBottomWidth (Css.px 2)
    , Css.borderBottomStyle Css.solid
    , Colors.borderColor Colors.primary
    ]
