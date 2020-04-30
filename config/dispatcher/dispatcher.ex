defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  match "/persons/*path" do
    Proxy.forward conn, path, "http://resource/persons/"
  end

  match "/genders/*path" do
    Proxy.forward conn, path, "http://resource/genders/"
  end


  match "/accounts/*path" do
    Proxy.forward conn, path, "http://resource/accounts/"
  end

  match "/organizations/*path" do
    Proxy.forward conn, path, "http://resource/organizations/"
  end

  match "/membership-statuses/*path" do
    Proxy.forward conn, path, "http://resource/person-statuses/"
  end

  match "/membership-roles/*path" do
    Proxy.forward conn, path, "http://resource/person-roles/"
  end

  match "/memberships/*path" do
    Proxy.forward conn, path, "http://resource/memberships/"
  end

  match "/organization-types/*path" do
    Proxy.forward conn, path, "http://resource/organization-types/"
  end

  match "/contact-points/*path" do
    Proxy.forward conn, path, "http://resource/contact-points/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
