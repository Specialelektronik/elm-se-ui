module SE.UI.Title exposing (title1, title2, title3, title4, title5, title6)

{-| Bulma Title elements
see <https://bulma.io/documentation/elements/title/>

Only the title element is supported, not the subtitle

@docs title1, title2, title3, title4, title5, title6

-}

import Css exposing (Style, int, num)
import Html.Styled exposing (Html, styled, text)
import SE.UI.Font as Font
import SE.UI.Utils exposing (block)


internalTitle : (List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg) -> List Style -> String -> Html msg
internalTitle tag style content =
    styled tag
        ([ block
         , Css.property "word-break" "break-word"
         , Css.lineHeight (num 1.3)
         , Css.fontWeight (int 700)
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
        [ Font.titleSizeEm 6
        ]


{-| Title in size 2
-}
title2 : String -> Html msg
title2 =
    internalTitle Html.Styled.h2
        [ Font.titleSizeEm 5
        ]


{-| Title in size 3
-}
title3 : String -> Html msg
title3 =
    internalTitle Html.Styled.h3
        [ Font.titleSizeEm 4
        ]


{-| Title in size 4
-}
title4 : String -> Html msg
title4 =
    internalTitle Html.Styled.h4
        [ Font.titleSizeEm 3
        ]


{-| Title in size 5
-}
title5 : String -> Html msg
title5 =
    internalTitle Html.Styled.h5
        [ Font.titleSizeEm 2
        ]


{-| Title in size 6
-}
title6 : String -> Html msg
title6 =
    internalTitle Html.Styled.h6
        [ Font.titleSizeEm 1
        ]
