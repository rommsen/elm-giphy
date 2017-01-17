module App.View exposing (viewHeader, viewBody)

import App.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onMouseEnter, onMouseLeave, onSubmit)


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
        [ viewGif model
        , div
            [ class "container" ]
            [ div
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
                                , value model.query
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
                [ class "columns is-multiline is-mobile" ]
                (viewThumbnails model)
            , viewLoadMoreButton model
            ]
        ]


viewThumbnails : Model -> List (Html Msg)
viewThumbnails model =
    List.foldr (\gif thumbnails -> (viewThumbnail gif model) :: thumbnails) [] model.gifs


viewThumbnail : GIF -> Model -> Html Msg
viewThumbnail gif model =
    div
        [ class "column is-one-quarter" ]
        [ figure
            [ class "image is-square grow"
            , onMouseEnter <| ThumbnailPreviewStart gif
            , onMouseLeave ThumbnailPreviewEnd
            , onClick <| Select gif
            ]
            [ img
                [ src <| viewThumbnailUrl gif model ]
                []
            ]
        ]


viewThumbnailUrl : GIF -> Model -> String
viewThumbnailUrl gif model =
    if Just gif == model.thumbnail then
        gif.thumbnail_gif_url
    else
        gif.thumbnail_url


viewGif : Model -> Html Msg
viewGif model =
    case model.current of
        Nothing ->
            text ""

        Just gif ->
            div
                [ class "modal is-active" ]
                [ div
                    [ class "modal-background"
                    , onClick <| Deselect
                    ]
                    []
                , div
                    [ class "modal-content" ]
                    [ p
                        [ class "image is-4by3" ]
                        [ img
                            [ src gif.gif_url ]
                            []
                        ]
                    ]
                ]


viewLoadMoreButton : Model -> Html Msg
viewLoadMoreButton model =
    if List.isEmpty model.gifs then
        text ""
    else
        div
            [ class "columns" ]
            [ div
                [ class "column has-text-centered" ]
                [ button
                    [ class "button  is-primary is-large is-inverted"
                    , onClick AdditionalQuery
                    ]
                    [ text "load more..." ]
                ]
            ]
