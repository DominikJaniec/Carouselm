module Controls exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Translations exposing (..)


textFor : TraKey -> Html msg
textFor key =
    translate key
        |> text


buttonFor : TraKey -> msg -> Html msg
buttonFor key msg =
    button [ class "button-group", onClick msg ] [ textFor key ]
        |> withHelpTooltipIcon key


iconButtonFor : TraKey -> String -> msg -> Html msg
iconButtonFor key cssClass msg =
    button
        [ class <| cssClass ++ " button-icon"
        , title <| translate key
        , onClick msg
        ]
        []


indicatorButtonFor : String -> Bool -> msg -> Html Msg
indicatorButtonFor url active msg =
    let
        cssClass =
            " button-icon"

        urlTitle =
            translateWith TK_Show_Select__URL
                [ TraReplacement "URL" url
                ]
    in
        button
            [ class <| cssClass
            , title <| urlTitle
            , onClicl msg
            ]
            []


inputFor : TraKey -> String -> (String -> msg) -> String -> Html msg
inputFor key vid msg init =
    div [ class "form-group group-input" ]
        [ label [ for vid ] [ textFor key ]
        , input [ id vid, type_ "textFor", required True, onInput msg, defaultValue init ] []
            |> withHelpTooltipIcon key
        ]


inputAreaFor : TraKey -> String -> (String -> msg) -> String -> Html msg
inputAreaFor key vid msg init =
    div [ class "from-group group-area" ]
        [ label [ for vid ] [ textFor key ]
        , textarea [ id vid, required True, onInput msg, defaultValue init ] []
            |> withHelpTooltipIcon key
        ]


withHelpTooltipIcon : TraKey -> Html msg -> Html msg
withHelpTooltipIcon key msgHtml =
    let
        helpIcon txt =
            sup [ title txt ] [ Html.text "(?)" ]

        tooltip =
            case translateHelp key of
                Just helpTxt ->
                    [ helpIcon helpTxt ]

                Nothing ->
                    []
    in
        div [ class "with-help" ] (msgHtml :: tooltip)
