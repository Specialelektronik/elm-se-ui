module SE.UI.Snackbar exposing
    ( Snackbar, create, add, withDuration, withIcon
    , Model, init, Config
    , Msg, update
    , view
    )

{-| A Snackbar component for displaying short, unintrusive messages to the user.

How to use:

    type alias Model =
        { snackbar : SE.UI.Snackbar.Model
        }

    initialModel : Model
    initialModel =
        { navbar = Snackbar.init
        }

    type Msg
        = GotSnackbarMsg SE.UI.Snackbar.Msg

    snackbarConfig : SE.UI.Snackbar.Config Msg
    snackbarConfig =
        { transform = GotSnackbarMsg }

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            GotSnackbarMsg subMsg ->
                let
                    ( newSnackbar, cmds ) =
                        SE.UI.Snackbar.update snackbarConfig subMsg model.snackbar
                in
                ( { model | snackbar = newSnackbar }, cmds )


# Definition

@docs Snackbar, create, add, withDuration, withIcon


# Model

@docs Model, init, Config


# Update

@docs Msg, update


# View

@docs view

-}

import Css exposing (Style)
import Css.Global
import Css.Transitions
import Dict exposing (Dict)
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Process
import SE.UI.Colors as Colors exposing (Color)
import SE.UI.Delete as Delete
import SE.UI.Font as Font
import SE.UI.Icon.V2 as Icon exposing (Icon)
import SE.UI.Utils as Utils
import Task


{-| Snackbar config holds the static content that cannot change in the UI. Everything else needs to go in the model.

transform : The parent message, see example at the top.

-}
type alias Config msg =
    { transform : Msg -> msg }


{-| The internal model
-}
type alias Model =
    { snackbars : Dict Int Snackbar
    , uid : Int
    }


{-| The internal type that holds the content and state for a single snackbar
-}
type Snackbar
    = Snackbar Internals


type State
    = Entered
    | Leaving


leavingDuration : Int
leavingDuration =
    1000


defaultDuration : Int
defaultDuration =
    3500


type alias Internals =
    { label : String
    , message : Html Never
    , state : State
    , duration : Int
    , iconWithColor : Maybe ( Icon, Color )
    }


{-| An empty model, use this during your model init function
-}
init : Model
init =
    { snackbars = Dict.empty
    , uid = 0
    }


{-| The snackbars internal Msg. When the snackbar is added, it will stay visible for `withDuration` milliseconds, then PassedDuration is triggered, which adds "is-leaving" class to the snackbar and waits for `durationLength` milliseconds. When the `durationLength` milliseconds has passed, the PassedLeavingDuration Msg is triggered which deletes the snackbar
-}
type Msg
    = PassedDuration Int
    | PassedLeavingDuration Int
    | Dismissed Int


{-| The snackbars internal update function. Since it uses tasks to delay certain events, it has to return a tuple of the model and commands.
-}
update : Config msg -> Msg -> Model -> ( Model, Cmd msg )
update config msg model =
    let
        ( newModel, cmds ) =
            updateHelper msg model
    in
    ( newModel
    , Cmd.map config.transform cmds
    )


updateHelper : Msg -> Model -> ( Model, Cmd Msg )
updateHelper msg model =
    case msg of
        PassedDuration index ->
            ( { model
                | snackbars = Dict.update index (Maybe.map (mapState Leaving)) model.snackbars
              }
            , Task.perform (\_ -> PassedLeavingDuration index) (Process.sleep (toFloat leavingDuration))
            )

        PassedLeavingDuration index ->
            ( { model | snackbars = Dict.remove index model.snackbars }, Cmd.none )

        Dismissed index ->
            ( { model | snackbars = Dict.remove index model.snackbars }, Cmd.none )


mapState : State -> Snackbar -> Snackbar
mapState state (Snackbar internals) =
    Snackbar { internals | state = state }


{-| Create a snackbar with default Duration, to set duraction, see `SE.UI.Snackbar.withDuration`
-}
create : { label : String, message : Html Never } -> Snackbar
create { label, message } =
    Snackbar
        { label = label
        , message = message
        , state = Entered
        , duration = defaultDuration
        , iconWithColor = Nothing
        }


{-| Add a snackbar to the internal model
-}
add : Config msg -> Model -> Snackbar -> ( Model, Cmd msg )
add config model ((Snackbar internals) as snackbar) =
    let
        newUid =
            model.uid + 1

        cmds =
            if internals.duration == 0 then
                Cmd.none

            else
                Cmd.map config.transform
                    (Task.perform (\_ -> PassedDuration newUid) (Process.sleep (toFloat internals.duration)))
    in
    ( { model | snackbars = Dict.insert newUid snackbar model.snackbars, uid = newUid }
    , cmds
    )


{-| The snackbars view function, place this at the end of your applications view function since it attaches to the bottom (for mobile views) or the right top corner (for desktop) and it needs to stay on top of everything else.
-}
view : Config msg -> Model -> Html msg
view config model =
    containerHtml []
        (model.snackbars |> Dict.toList |> List.map (toHtml config))


{-| Set the duration of the snackbar
0 duration implies that it will remain until dismissed
-}
withDuration : Int -> Snackbar -> Snackbar
withDuration duration (Snackbar internals) =
    Snackbar { internals | duration = duration }


{-| Add icon with background color. In version 10.1.0 and below the standard icon and color was Icon.cart Colors.Buy.
-}
withIcon : Icon -> Color -> Snackbar -> Snackbar
withIcon icon color (Snackbar internals) =
    Snackbar { internals | iconWithColor = Just ( icon, color ) }


containerHtml : List (Attribute msg) -> List (Html msg) -> Html msg
containerHtml =
    styled Html.div containerStyles


toHtml : Config msg -> ( Int, Snackbar ) -> Html msg
toHtml config ( index, Snackbar internals ) =
    styled Html.div
        snackbarStyles
        [ Attributes.classList [ ( "snackbar", True ), ( "is-leaving", internals.state == Leaving ) ] ]
        [ Maybe.map iconToHtml internals.iconWithColor |> Maybe.withDefault (Html.text "")
        , styled Html.div
            contentStyles
            [ Attributes.classList [ ( "snackbar-content", True ) ] ]
            [ Html.p [ Attributes.classList [ ( "snackbar-title", True ) ] ]
                [ Html.strong [] [ Html.text internals.label ]
                ]
            , Html.p [ Attributes.classList [ ( "snackbar-message", True ) ] ]
                [ Html.map never internals.message
                ]
            ]
        , dismissToHtml (config.transform (Dismissed index))
        ]


iconToHtml : ( Icon, Color ) -> Html msg
iconToHtml ( icon, color ) =
    styled Html.div
        [ Colors.backgroundColor (color |> Colors.toHsla)
        , Colors.color (color |> Colors.toHsla |> Colors.invert)
        , Css.width (Css.px 36)
        , Css.height (Css.px 36)
        , Css.borderRadius (Css.pct 50)
        , Css.displayFlex
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        , Css.flexShrink Css.zero
        ]
        []
        [ icon |> Icon.toHtml
        ]


dismissToHtml : msg -> Html msg
dismissToHtml msg =
    styled Html.div
        [ Css.marginLeft Css.auto
        , Css.paddingLeft (Css.rem 1)
        ]
        []
        [ Delete.regular [] msg ]



-- STYLES


snackbarStyles : List Style
snackbarStyles =
    [ Css.width (Css.pct 100)
    , Utils.widescreen
        [ Css.marginBottom Css.unset
        , Css.width Css.unset
        ]
    , Css.displayFlex
    , Css.alignItems Css.center
    , Css.position Css.relative
    , Css.padding (Css.rem 1)
    , Font.bodySizeEm -2
    , Colors.backgroundColor Colors.white
    , Css.lineHeight (Css.num 1.28571428571)
    , Css.borderRadius Utils.radius
    , Css.boxShadow4 Css.zero (Css.px 4) (Css.px 10) (Colors.black |> Colors.mapAlpha (always 0.15) |> Colors.toCss)
    , Css.opacity (Css.int 1)
    , Css.borderBottom3 (Css.px 3) Css.solid Css.transparent
    , Css.Transitions.transition
        [ Css.Transitions.borderBottom 128
        ]

    -- , Css.property "transform" "translateY(0)"
    , Css.Global.withClass "is-leaving"
        [ Css.Transitions.transition
            [ Css.Transitions.opacity (toFloat leavingDuration)
            , Css.Transitions.marginBottom (toFloat leavingDuration)
            ]
        , Css.opacity Css.zero
        , Css.marginBottom (Css.px -64)
        ]

    -- Box shadow animation
    -- https://tobiasahlin.com/blog/how-to-animate-box-shadow/
    , Css.hover
        [ Css.borderBottomColor (Colors.primary |> Colors.toCss)
        , Css.after
            [ Css.opacity (Css.int 1)
            ]
        ]
    , Css.after
        [ Css.property "content" "''"
        , Css.position Css.absolute
        , Css.top Css.zero
        , Css.left Css.zero
        , Css.zIndex (Css.int -1)
        , Css.width (Css.pct 100)
        , Css.height (Css.pct 100)
        , Css.borderRadius Utils.radius
        , Css.property "box-shadow" "0 4px 10px hsla(0, 0%, 0%, 0.15)"
        , Css.opacity Css.zero
        , Css.Transitions.transition
            [ Css.Transitions.opacity 128
            ]
        ]
    ]


contentStyles : List Style
contentStyles =
    [ Css.marginLeft (Css.rem 1)
    ]


containerStyles : List Style
containerStyles =
    [ Css.zIndex (Css.int 50)
    , Css.displayFlex
    , Css.flexDirection Css.columnReverse
    , Css.position Css.fixed
    , Css.bottom Css.zero
    , Css.width (Css.pct 100)
    , Css.padding4 (Css.rem 1) (Css.rem 1) Css.zero (Css.rem 1)
    , Css.Global.children
        [ Css.Global.class "snackbar"
            [ Css.marginBottom (Css.rem 1)
            ]
        ]
    , Utils.widescreen
        [ Css.bottom Css.unset
        , Css.top Css.zero
        , Css.right Css.zero
        , Css.flexDirection Css.column
        , Css.width Css.unset
        , Css.padding4 Css.zero (Css.rem 1) (Css.rem 1) (Css.rem 1)
        , Css.Global.children
            [ Css.Global.class "snackbar"
                [ Css.important (Css.marginBottom Css.unset)
                , Css.marginTop (Css.rem 1)
                ]
            ]
        ]
    ]
