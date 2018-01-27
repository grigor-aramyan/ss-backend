defmodule StuffSwapWeb.GeneralChannel do
  use StuffSwapWeb, :channel
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]

  alias StuffSwap.Types.Category
  alias StuffSwap.Subtypes.Subcategory
  alias StuffSwap.Account.User
  alias StuffSwap.Repo

  def join("stuffswap:general", _params, socket) do
    {:ok, socket}
  end

  def handle_in("fetchproductsbysubcatid", params, socket) do
    subcat_id = params["subcat_id"]

    query = from i in "items",
            where: i.subcategory_id == ^subcat_id,
            select: [i.id, i.title, i.description, i.picture_uri, i.is_free, i.user_id]

    raw_output = Repo.all(query)

    IO.inspect raw_output

    push socket, "fetchproductsbysubcatid", %{
      output: raw_output
    }

    {:reply, :ok, socket}
  end

  def handle_in("getcategories", _params, socket) do
    cats_and_subcats =
      Repo.all(Category)
      |> Repo.preload([:subcategories])

    processed_output =
      get_data_from_cats_list(cats_and_subcats)

    IO.inspect processed_output

    push socket, "getcategories", %{
      output: processed_output
    }

    {:reply, :ok, socket}
  end

  defp get_data_from_cats_list([]) do
    []
  end

  defp get_data_from_cats_list([head | tail]) do
    [ %{ id: head.id, title: head.title,
      pic_uri: head.pic_uri, subcats: get_data_from_subcats_list(head.subcategories) } ] ++ get_data_from_cats_list(tail)
  end

  defp get_data_from_subcats_list([]) do
    []
  end

  defp get_data_from_subcats_list([head | tail]) do
    [ %{ id: head.id, title: head.title, pic_uri: head.pic_uri } ] ++ get_data_from_subcats_list(tail)
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