defmodule DockupUi.Router do
  use DockupUi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_current_user do
    plug DockupUi.Plugs.GetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DockupUi do
    pipe_through :browser
    get "/", DeploymentController, :home
  end

  scope "/", DockupUi do
    pipe_through [:browser, :with_current_user]

    get "/deploy", DeploymentController, :new
    resources "/deployments", DeploymentController, only: [:new, :index, :show]
    resources "/config", ConfigController, only: [:index]
    resources "/whitelisted_urls", WhitelistedUrlController, except: [:index, :show]

    resources "/groups", GroupController, alias: Group do
      resources "/whitelisted_urls", WhitelistedUrlController, except: [:index, :show]
    end
  end

  scope "/api", as: :api, alias: DockupUi.API do
    pipe_through :api

    resources "/deployments", DeploymentController, only: [:create, :index, :show, :delete] do
      put "/hibernate", DeploymentController, :hibernate
      put "/wake_up", DeploymentController, :wake_up
    end
    resources "/github_webhook", GithubWebhookController, only: [:create]
    resources "/bitbucket_webhook", BitbucketWebhookController, only: [:create]
  end

  scope "/auth", DockupUi do
    pipe_through :browser

    get "/", AuthController, :new
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
end
