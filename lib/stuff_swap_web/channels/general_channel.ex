defmodule StuffSwapWeb.GeneralChannel do
  use StuffSwapWeb, :channel
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]

  alias StuffSwap.Types.Category
  #alias StuffSwap.Subtypes.Subcategory
  alias StuffSwap.Account.User
  alias StuffSwap.Store.Item
  alias StuffSwap.Repo

  def join("stuffswap:general", _params, socket) do
    {:ok, socket}
  end

  def handle_in("chat_message:fetch_all_for_item", params, socket) do
    addressed_to_id = params["addressed_to_id"]
    author_id = params["author_id"]
    item_id = params["item_id"]

    case Integer.parse addressed_to_id do
      {addressed_to_id, ""} ->
        case Integer.parse author_id do
          {author_id, ""} ->
            case Integer.parse item_id do
              {item_id, ""} ->
                query = from m in "messages",
                             where: m.item_id == ^item_id and (m.author_id == ^author_id and m.addressedto_id == ^addressed_to_id) or
                                    (m.author_id == ^addressed_to_id and m.addressedto_id == ^author_id),
                             select: [m.id, m.author_id, m.body, m.is_red, m.inserted_at]

                raw_output = Repo.all(query)

                output = get_messages_from_list(raw_output)

                IO.inspect output

                push socket, "chat_message:fetch_all_for_item", %{
                  output: output
                }

                {:reply, :ok, socket}
              :error ->
                push socket, "chat_message:fetch_all_for_item", %{
                  msg: "Invalid input data"
                }
                {:reply, :error, socket}
            end
          :error ->
            push socket, "chat_message:fetch_all_for_item", %{
              msg: "Invalid input data"
            }
            {:reply, :error, socket}
        end
      :error ->
        push socket, "chat_message:fetch_all_for_item", %{
          msg: "Invalid input data"
        }
        {:reply, :error, socket}
    end
  end

  def handle_in("store_item:fetch", params, socket) do
    item_id = params["item_id"]

    item = Repo.get(Item, item_id)
    user_id = item.user_id
    user = Repo.get(User, user_id)

    IO.inspect user
    IO.inspect item

    push socket, "store_item:fetch", %{
      id: item.id,
      user_id: item.user_id,
      title: item.title,
      desc: item.description,
      item_pic: item.picture_uri,
      profile_avatar: user.profile_image_uri,
      author_name: user.name
    }

    {:reply, :ok, socket}
  end

  def handle_in("store_item:new", params, socket) do
    title = params["title"]
    desc = params["desc"]
    pic_uri = params["pic_uri"]
    is_free = params["is_free"]
    cat_id = params["cat_id"]
    subcat_id = params["subcat_id"]
    user_id = params["user_id"]

    cat_id = String.to_integer cat_id
    subcat_id = String.to_integer subcat_id
    user_id = String.to_integer user_id

    new_item_params = %{
      title: title,
      description: desc,
      picture_uri: pic_uri,
      is_free: is_free,
      category_id: cat_id,
      subcategory_id: subcat_id,
      user_id: user_id
    }

    changeset = Item.changeset(%Item{}, new_item_params)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        query = from i in "items",
                     where: i.subcategory_id == ^subcat_id,
                     select: [i.id, i.title, i.description, i.picture_uri, i.is_free, i.user_id, i.subcategory_id, i.category_id]

        raw_output = Repo.all(query)

        broadcast! socket, "store_item:new", %{
          output: raw_output
        }

        {:reply, :ok, socket}
      {:error, _changeset} ->
        push socket, "store_item:new", %{
          msg: "Failed to add new item"
        }
        {:reply, :error, socket}
    end
  end

  def handle_in("fetchproductsbysubcatid", params, socket) do
    subcat_id = params["subcat_id"]

    case Integer.parse subcat_id do
      {subcat_id, _} ->
        query = from i in "items",
                     where: i.subcategory_id == ^subcat_id,
                     select: [i.id, i.title, i.description, i.picture_uri, i.is_free, i.user_id, i.subcategory_id, i.category_id]

        raw_output = Repo.all(query)

        IO.inspect raw_output

        push socket, "fetchproductsbysubcatid", %{
          output: raw_output
        }

        {:reply, :ok, socket}
      :error ->
        push socket, "fetchproductsbysubcatid", %{
          msg: "Can't recognize subcategory id."
        }

        {:reply, :error, socket}
    end
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

  defp get_messages_from_list([]) do
    []
  end
  defp get_messages_from_list([head | tail]) do
    [ %{ message_id: Enum.at(head, 0), author_id: Enum.at(head, 1), body: Enum.at(head, 2),
      is_red: Enum.at(head, 3) } ] ++ get_messages_from_list(tail)
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
    [ %{ id: head.id, title: head.title, pic_uri: head.pic_uri, cat_id: head.category_id } ] ++ get_data_from_subcats_list(tail)
  end
end