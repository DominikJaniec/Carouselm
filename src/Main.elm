module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation exposing (..)
import Controls exposing (..)
import State
import State.Parser as Parser
import Navigator
import Translations exposing (..)


main : Program Never Model Msg
main =
    Navigation.program LoadApp
        { init = initializeModel
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { navCtx : Navigator.Context
    , previewCurrentIndex : Int
    , previewStateData : State.Data
    , showHelp : Bool
    , inputs : Parser.InputState
    , stateData : State.Data
    , stateShareUrl : String
    }


initializeModel : Location -> ( Model, Cmd Msg )
initializeModel location =
    { navCtx = Navigator.getContext location
    , previewCurrentIndex = 0
    , previewStateData = State.initialData
    , showHelp = False
    , inputs = Parser.InputState "" "" ""
    , stateData = State.initialData
    , stateShareUrl = ""
    }
        |> updateFrom location
        |> pairWithCmdNone


loadAppData : Navigator.Context -> Location -> State.Data
loadAppData ctx location =
    case
        location
            |> Navigator.extractState ctx
    of
        Ok ( _, Just data ) ->
            -- TODO: Take care of State.Mode.
            data

        other ->
            State.initialData
                |> Debug.log
                    -- TODO: Handle this in better way than just Log.
                    ("Loading App from given Location ends with unexpected Result."
                        ++ "\n  * Location: "
                        ++ toString location.href
                        ++ "\n  * Result: "
                        ++ toString other
                        ++ "\n\nReplacing with the default data"
                    )


pairWithCmdNone : Model -> ( Model, Cmd Msg )
pairWithCmdNone model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = LoadApp Navigation.Location
    | Title String
    | Interval String
    | Pages String
    | ShowHelp
    | CopyUrl
    | Preview
    | GoToShow
    | GoToEdit
    | GoToAbout


type alias InputsSetter =
    Parser.InputState -> Parser.InputState


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadApp location ->
            updateFrom location model
                |> pairWithCmdNone

        Title txt ->
            (\inputs -> { inputs | title = txt })
                |> updateInputs model
                |> pairWithCmdNone

        Interval txt ->
            (\inputs -> { inputs | interval = txt })
                |> updateInputs model
                |> pairWithCmdNone

        Pages txt ->
            (\inputs -> { inputs | pages = txt })
                |> updateInputs model
                |> pairWithCmdNone

        ShowHelp ->
            { model | showHelp = True }
                |> pairWithCmdNone

        Preview ->
            { model | previewStateData = model.stateData }
                |> pairWithCmdNone

        CopyUrl ->
            Debug.crash "Not yet implemented."

        GoToShow ->
            model |> pairWithCmdNone

        GoToEdit ->
            model |> pairWithCmdNone

        GoToAbout ->
            model |> pairWithCmdNone


updateInputs : Model -> InputsSetter -> Model
updateInputs model setter =
    let
        updatedInputs =
            setter model.inputs

        updatedModel =
            { model | inputs = updatedInputs }
    in
        case Parser.parse updatedInputs of
            Ok parsedData ->
                { updatedModel | stateData = parsedData }
                    |> updateShareUrl

            Err errors ->
                -- TODO : Make better validation:
                { updatedModel | stateShareUrl = toString errors }


updateShareUrl : Model -> Model
updateShareUrl model =
    let
        url =
            Navigator.makeShareableUrl model.navCtx model.stateData
    in
        { model | stateShareUrl = url }


updateFrom : Navigation.Location -> Model -> Model
updateFrom location model =
    let
        stateData =
            loadAppData model.navCtx location
    in
        { model
            | previewStateData = stateData
            , inputs = Parser.unparse stateData
            , stateData = stateData
        }
            |> updateShareUrl



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "view-app" ]
        [ showView model, editView model ]


showView : Model -> Html Msg
showView model =
    section [ class "view-show" ]
        [ sectionNavigator model
        , sectionDisplay model
        ]


sectionNavigator : Model -> Html Msg
sectionNavigator model =
    let
        flowButtons =
            [ iconButtonFor TK_Show_Edit "icon-edit" GoToEdit
            , iconButtonFor TK_Show_About "icon-about" GoToAbout
            ]
    in
        section [ class "section-navigator" ]
            [ (pageIndicators model ++ flowButtons)
                |> List.map (\e -> li [] [ e ])
                |> ul [ class "navi-menu" ]
            ]


pageIndicators : Model -> List (Html Msg)
pageIndicators model =
    let
        indicator index url =
            case model.previewCurrentIndex == index of
                True ->
                    button [ title url ] [ text "◉" ]

                _ ->
                    button [ title url ] [ text "◎" ]
    in
        model.previewStateData.pages
            |> List.indexedMap indicator


sectionDisplay : Model -> Html Msg
sectionDisplay model =
    section [] [ text "Show: View - TODO..." ]


editView : Model -> Html Msg
editView model =
    section [ class "view-edit" ]
        [ sectionTop model
        , sectionConfig model
        , sectionFlow model
        , sectionUrl model
        ]


sectionTop : Model -> Html Msg
sectionTop model =
    section [ class "section-top" ]
        [ h1 [] [ textFor TK_App_Name ]
        , h3 []
            [ textFor TK_App_Description
            , button [ class "help-show", hidden model.showHelp, onClick ShowHelp ]
                [ textFor TK_App_Help_Show ]
            ]
        , article [ class "help-content", hidden (not model.showHelp) ]
            [ textFor TK_App_Help_Content ]
        ]


sectionConfig : Model -> Html Msg
sectionConfig model =
    section [ class "section-config" ]
        [ inputFor TK_Edit_Title "vid_title" Title model.inputs.title
        , inputFor TK_Edit_Interval "vid_interval" Interval model.inputs.interval
        , inputAreaFor TK_Edit_Pages "vid_pages" Pages model.inputs.pages
        ]


sectionFlow : Model -> Html Msg
sectionFlow model =
    section [ class "section-flow" ]
        [ buttonFor TK_Flow_Preview Preview
        , buttonFor TK_Flow_GoToShow GoToShow
        ]


sectionUrl : Model -> Html Msg
sectionUrl model =
    section [ class "section-url" ]
        [ input [ readonly True, defaultValue model.stateShareUrl ] []
        , buttonFor TK_Flow_CopyUrl CopyUrl
        ]
