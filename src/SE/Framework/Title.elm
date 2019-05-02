module SE.Framework.Title exposing (title1, title2, title3, title4, title5, title6)

{-| Bulma Title elements
see <https://bulma.io/documentation/elements/title/>

Only the title element is supported, not the subtitle

@docs title1, title2, title3, title4, title5, title6

-}

import Css exposing (Style, bold, int, num, rem, uppercase)
import Css.Global exposing (descendants)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Colors exposing (darkest)
import SE.Framework.Utils exposing (block)


internalTitle : (List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg) -> List Style -> String -> Html msg
internalTitle tag style content =
    styled tag
        ([ block
         , Css.property "word-break" "break-word"
         , Css.color darkest
         , Css.lineHeight (num 1.125)
         ]
            ++ style
        )
        []
        [ text content ]


{-| Title in size 1
-}
title1 : String -> Html msg
title1 =
    internalTitle Html.Styled.h1
        [ Css.fontSize (rem 3)
        , Css.fontWeight (int 200)
        ]


{-| Title in size 2
-}
title2 : String -> Html msg
title2 =
    internalTitle Html.Styled.h2
        [ Css.fontSize (rem 2.5)
        , Css.fontWeight (int 200)
        ]


{-| Title in size 3
-}
title3 : String -> Html msg
title3 =
    internalTitle Html.Styled.h3
        [ Css.fontSize (rem 2)
        , Css.fontWeight (int 300)
        ]


{-| Title in size 4
-}
title4 : String -> Html msg
title4 =
    internalTitle Html.Styled.h4
        [ Css.fontSize (rem 1.5)
        , Css.fontWeight (int 400)
        ]


{-| Title in size 5
-}
title5 : String -> Html msg
title5 =
    internalTitle Html.Styled.h5
        [ Css.fontSize (rem 1.25)
        , Css.fontWeight (int 400)
        ]


{-| Title in size 6
-}
title6 : String -> Html msg
title6 =
    internalTitle Html.Styled.h6
        [ Css.fontSize (rem 0.75)
        , Css.fontWeight (int 600)
        , Css.textTransform uppercase
        ]
