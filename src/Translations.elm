module Translations exposing (TraKey(..), translate, translateHelp)


type TraKey
    = TK_App_Name
    | TK_App_Description
    | TK_App_Help_Show
    | TK_App_Help_Content
    | TK_Edit_Title
    | TK_Edit_Interval
    | TK_Edit_Pages
    | TK_Edit_GenerateUrl
    | TK_Edit_CopyUrl
    | TK_Flow_Refresh
    | TK_Flow_GoToShow


translate : TraKey -> String
translate key =
    case key of
        TK_App_Name ->
            "Carouselm"

        TK_App_Description ->
            "[TODO] Page description"

        TK_App_Help_Show ->
            "show help"

        TK_App_Help_Content ->
            "[TODO] Help content"

        TK_Edit_Title ->
            "Carousel's title:"

        TK_Edit_Interval ->
            "Changes' interval [ms]:"

        TK_Edit_Pages ->
            "Pages (single URL per line):"

        TK_Edit_GenerateUrl ->
            "Generate URL"

        TK_Edit_CopyUrl ->
            "Copy"

        TK_Flow_Refresh ->
            "Preview configuration"

        TK_Flow_GoToShow ->
            "Go to Show"


translateHelp : TraKey -> Maybe String
translateHelp key =
    case key of
        TK_Edit_Title ->
            Just "TODO - TK_Edit_Title"

        TK_Edit_Interval ->
            Just "TODO - TK_Edit_Interval"

        TK_Edit_Pages ->
            Just "TODO - TK_Edit_Pages"

        TK_Edit_GenerateUrl ->
            Just "TODO - TK_Edit_GenerateUrl"

        TK_Edit_CopyUrl ->
            Just "TODO - TK_Edit_CopyUrl"

        TK_Flow_Refresh ->
            Just "TODO - TK_Flow_Refresh"

        TK_Flow_GoToShow ->
            Just "TODO - TK_Edit_GoToShow"

        _ ->
            Nothing
