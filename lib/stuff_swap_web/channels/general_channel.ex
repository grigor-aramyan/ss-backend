defmodule StuffSwapWeb.GeneralChannel do
  use StuffSwapWeb, :channel
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias StuffSwap.Account.User
  alias StuffSwap.Repo

  def join("stuffswap:general", _params, socket) do
    {:ok, socket}
  end

  def handle_in("signin", params, socket) do
    mail = params["email"]
    pass = params["password"]

    user = Repo.get_by(User, email: mail)

    cond do
      user && checkpw(pass, user.password_hash) ->
        push socket, "signin", %{
          id: user.id,
          email: user.email,
          name: user.name,
          pic_uri: user.profile_image_uri
        }
        {:reply, :ok, assign(socket, :user_id, user.id)}
      true ->
        dummy_checkpw()
        push socket, "signin", %{
          msg: "not found"
        }
        {:reply, :error, socket}
    end
  end

  def handle_in("registeruser", params, socket) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        push socket, "registeruser", %{
          id: user.id,
          email: user.email,
          name: user.name,
          pic_uri: user.profile_image_uri
        }
        {:reply, :ok, assign(socket, :user_id, user.id)}
      {:error, _changeset} ->
        push socket, "registeruser", %{
          msg: "not found"
        }
        {:reply, :error, socket}
    end
  end
end