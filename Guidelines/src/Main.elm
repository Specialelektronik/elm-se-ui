module Main exposing (..)

import Readme
import Columns

import Html exposing (text)

import UIExplorer
    exposing
        ( UIExplorerProgram
        , category
        , createCategories
        , defaultConfig
        , exploreWithCategories
        , getCurrentSelectedStory
        , logoFromUrl
        , storiesOf
        )
import UIExplorer.Plugins.MenuVisibility as MenuVisibility

config =
    { defaultConfig
        | menuViewEnhancer = MenuVisibility.menuViewEnhancer
        , customHeader =
            Just
                { title = "Tasty Design System"
                , logo = logoFromUrl "grec-logo-header.png"
                , titleColor = Nothing
                , bgColor = Nothing
                }
    }

main : UIExplorerProgram {} () { hasMenu : Bool }
main =
    exploreWithCategories
        config
        (createCategories
            |> category
                "Read me"
                [ storiesOf
                    "Special-Elektronik Elm UI"
                    [ ( "About", \_ -> Readme.toMarkdown Readme.about, { hasMenu = True } ), ( "Intent", \_ -> Readme.toMarkdown Readme.intent, { hasMenu = True } ) ]
                ]
            |> category
                "Columns"
                [ storiesOf
                    "Basics"
                    [ ( "Basics", \_ -> Columns.basics, { hasMenu = False } ) ]
                , storiesOf
                    "Column"
                    [ ( "Column", \_ -> Columns.basics, { hasMenu = False } ) ]
                , storiesOf
                    "Size"
                    [ ( "Size", \_ -> Columns.basics, { hasMenu = False } ) ]
                , storiesOf
                    "Unsupported features"
                    [ ( "Unsupported features", \_ -> Columns.basics, { hasMenu = False } ) ]
                ]
        )