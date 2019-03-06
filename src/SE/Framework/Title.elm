module SE.Framework.Title exposing (title, title1, title2, title3, title4, title5, title6)

import Css exposing (Style, bold, int, num, rem)
import Css.Global exposing (descendants)
import Html.Styled exposing (Html, styled, text)
import SE.Framework.Colors exposing (darkest)
import SE.Framework.Utils exposing (block)


internalTitle : (List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg) -> Float -> String -> Html msg
internalTitle f fontSize t =
    styled f
        [ block
        , Css.property "wordBreak" "break-word"
        , Css.color darkest
        , Css.fontSize (rem fontSize)
        , Css.fontWeight bold
        , Css.lineHeight (num 1.125)
        ]
        []
        [ text t ]


title : String -> Html msg
title =
    internalTitle Html.Styled.h3 2


title1 : String -> Html msg
title1 =
    internalTitle Html.Styled.h1 3


title2 : String -> Html msg
title2 =
    internalTitle Html.Styled.h2 2.5


title3 : String -> Html msg
title3 =
    title


title4 : String -> Html msg
title4 =
    internalTitle Html.Styled.h4 1.5


title5 : String -> Html msg
title5 =
    internalTitle Html.Styled.h5 1.25


title6 : String -> Html msg
title6 =
    internalTitle Html.Styled.h6 1
