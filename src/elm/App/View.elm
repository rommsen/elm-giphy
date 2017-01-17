module App.View exposing (viewHeader, viewBody)

import App.Types exposing (..)
import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)


viewHeader : Model -> Html Msg
viewHeader model =
    section [ class "hero is-info" ]
        [ div [ class "hero-head" ]
            [ div [ class "container" ]
                [ div [ class "nav" ]
                    [ div [ class "nav-left" ]
                        [ span [ class "nav-item is-brand" ] [ text "Elm-Giphy" ] ]
                    ]
                ]
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    section
        [ class "section" ]
        [ div
            [ class "container" ]
            [ h1
                [ class "title" ]
                [ text "Giphy Search" ]
            , h2
                [ class "subtitle" ]
                [ text "Enter a query to search for GIFs" ]
            , hr
                []
                []
            , div
                [ class "columns" ]
                [ div
                    [ class "column" ]
                    [ text "" ]
                , div
                    [ class "column" ]
                    [ Html.form [ onSubmit Query ]
                        [ p [ class "control has-addons" ]
                            [ input
                                [ class "input"
                                , placeholder "What are you looking for?"
                                , onInput InputQuery
                                ]
                                []
                            , button
                                [ class "button is-info"
                                , type_ "submit"
                                ]
                                [ text "Search" ]
                            ]
                        ]
                    ]
                , div
                    [ class "column" ]
                    [ text "" ]
                ]
            , div
                [ class "columns" ]
                [ div
                    [ class "column" ]
                    [ text "" ]
                , div
                    [ class "column" ]
                    [ button
                        [ class "button"
                        , onClick Previous
                        ]
                        [ text "previous" ]
                    , button
                        [ class "button"
                        , onClick Next
                        ]
                        [ text "next" ]
                    ]
                , div
                    [ class "column" ]
                    [ text "" ]
                ]
            , div
                [ class "columns" ]
                [ div
                    [ class "column is-half is-offset-one-quarter" ]
                    [ div
                        [ class "box" ]
                        [ h1
                            [ class "title is-5" ]
                            [ text model.query ]
                        , div
                            [ class "" ]
                            [ showGif model.gifs
                            ]
                        , div
                            [ class "" ]
                            [ div
                                [ class "media" ]
                                [ div
                                    [ class "media-left" ]
                                    [ figure
                                        [ class "image"
                                        , style [ ( "height", "40px" ), ( "width", "40px" ) ]
                                        ]
                                        [ img
                                            [ src "http://bulma.io/images/placeholders/96x96.png", alt "Image" ]
                                            []
                                        ]
                                    ]
                                , div
                                    [ class "media-content" ]
                                    [ p
                                        [ class "title is-4" ]
                                        [ text "John Smith" ]
                                    , p
                                        [ class "subtitle is-6" ]
                                        [ text "@johnsmith" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


showGif : Gifs -> Html Msg
showGif { list, current } =
    case Array.get current list of
        Nothing ->
            text ""

        Just gif ->
            figure
                [ class "image is-4by3" ]
                [ img
                    [ src gif.url
                    , alt "Image"
                    ]
                    []
                ]
