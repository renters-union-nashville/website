module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import Effect
import Element
import ErrorPage exposing (ErrorPage)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Json.Decode as Decode
import Json.Encode as Encode
import Markdown.Block exposing (Block)
import Markdown.Parser
import Markdown.Renderer
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Post
import RouteBuilder exposing (App, StatefulRoute)
import Server.Request exposing (Request)
import Server.Response exposing (Response)
import Shared
import UrlPath
import View exposing (View)


type alias Model =
    {}


type Msg
    = NoOp


type alias RouteParams =
    { slug : String }


route : StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.buildWithLocalState
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
        (RouteBuilder.serverRender { data = data, action = action, head = head })


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app shared =
    ( {}, Effect.none )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect msg )
update app shared msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )


subscriptions :
    RouteParams
    -> UrlPath.UrlPath
    -> Shared.Model
    -> Model
    -> Sub Msg
subscriptions routeParams path shared model =
    Sub.none


type alias Data =
    { body : List Block
    }


type alias ActionData =
    {}


data :
    RouteParams
    -> Request
    -> BackendTask.BackendTask FatalError.FatalError (Response Data ErrorPage)
data routeParams request =
    BackendTask.Custom.run "getPost"
        (Encode.string routeParams.slug)
        (Decode.nullable Post.decoder)
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\maybePost ->
                case maybePost of
                    Just post ->
                        let
                            parsed : Result String (List Block)
                            parsed =
                                post.body
                                    |> Markdown.Parser.parse
                                    |> Result.mapError (\_ -> "Invalid markdown.")
                        in
                        parsed
                            |> Result.mapError FatalError.fromString
                            |> Result.map
                                (\parsedMarkdown ->
                                    Server.Response.render
                                        { body = parsedMarkdown
                                        }
                                )
                            |> BackendTask.fromResult

                    Nothing ->
                        Server.Response.errorPage ErrorPage.NotFound
                            |> BackendTask.succeed
            )


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg Msg)
view app shared model =
    { title = "Posts.Slug_"
    , body =
        [ Element.text "Here is your generated page!!!"
        , Element.column []
            (app.data.body
                |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
                |> Result.withDefault []
                |> List.map Element.html
            )
        ]
    }


action :
    RouteParams
    -> Request
    -> BackendTask.BackendTask FatalError.FatalError (Server.Response.Response ActionData ErrorPage.ErrorPage)
action routeParams request =
    BackendTask.succeed (Server.Response.render {})
