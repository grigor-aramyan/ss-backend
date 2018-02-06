defmodule StuffSwapWeb.GeneralChannel do
  use StuffSwapWeb, :channel
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, only: [from: 2]

  alias StuffSwap.Types.Category
  #alias StuffSwap.Subtypes.Subcategory
  alias StuffSwap.Account.User
  alias StuffSwap.Store.Item
  alias StuffSwap.Repo
  alias StuffSwap.Chat.Message

  def join("stuffswap:general", _params, socket) do
    {:ok, socket}
  end

  def handle_in("chat_messages:fetch_unreds_for_user", params, socket) do
    user_id = params["current_user_id"]
    query = from m in "messages",
                 where: (m.addressedto_id == ^user_id) and (m.is_red == false),
                 select: [m.id, m.author_id, m.body, m.is_red, m.insertion_date, m.item_id]

    raw_output = Repo.all(query)

    unique_messages_map = get_recent_messages_from_list(raw_output, %{})

    output2 = get_recent_unred_message_by_id(Map.values(unique_messages_map), [])

    push socket, "chat_messages:fetch_unreds_for_user", %{
      output: output2
    }

    {:reply, :ok, socket}

  end

  def handle_in("chat_message:new", params, socket) do
    changeset = Message.changeset(%Message{}, params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        IO.inspect message
        message_item = Repo.get(Item, message.item_id)
        user = Repo.get(User, message.author_id)
        message_item_author = Repo.get(User, message_item.user_id)

        broadcast! socket, "chat_message:new", %{
          output: %{
            message_id: message.id,
            message_author_id: message.author_id,
            message_addressedto_id: message.addressedto_id,
            message_is_red: message.is_red,
            message_body: message.body,
            message_insertion_date: message.insertion_date,
            message_item_id: message.item_id,
            message_item_author_id: message_item.user_id,
            message_item_title: message_item.title,
            message_item_author_name: message_item_author.name,
            message_item_author_pic: message_item_author.profile_image_uri,
            message_author_name: user.name,
            message_author_pic: user.profile_image_uri
          }
        }

        {:reply, :ok, socket}
      {:error, _changeset} ->
        push socket, "chat_message:new", %{
          msg: "Couldn't add new message"
        }

        {:reply, :error, socket}
    end
  end

  def handle_in("store_items:fetch_all", _params, socket) do
    raw_output =
      Repo.all(Item)
      |> Repo.preload([:messages])

    IO.inspect raw_output
    output = get_item_from_list(raw_output)
    IO.inspect output

    push socket, "store_items:fetch_all", %{
      output: output
    }

    {:reply, :ok, socket}
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
                             select: [m.id, m.author_id, m.body, m.is_red, m.insertion_date]

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

  defp get_item_from_list([]) do
    []
  end
  defp get_item_from_list([head | tail]) do
    user = Repo.get(User, head.user_id)
    [ %{ id: head.id,  item_author_id: head.user_id, title: head.title, desc: head.description,
      item_pic: head.picture_uri, profile_avatar: user.profile_image_uri, item_is_free: head.is_free,
      item_author_name: user.name, item_cat_id: head.category_id, item_subcat_id: head.subcategory_id,
      messages: get_message_from_keyed_list(head.messages) } ]
    ++ get_item_from_list(tail)
  end
  defp get_message_from_keyed_list([]) do
    []
  end
  defp get_message_from_keyed_list([head | tail]) do
    author_id = head.author_id
    author = Repo.get(User, author_id)
    [ %{ message_id: head.id, message_author_id: author_id, message_author_name: author.name, message_body: head.body,
      message_is_red: head.is_red, message_insertion_date: head.insertion_date,
      message_addressedto_user_id: head.addressedto_id} ]
    ++ get_message_from_keyed_list(tail)
  end

  defp get_messages_from_list_2([]) do
    []
  end
  defp get_messages_from_list_2([head | tail]) do
    author_id = Enum.at(head, 1)
    author = Repo.get(User, author_id)
    message_item_id = Enum.at(head, 5)
    item = Repo.get(Item, message_item_id)
    item_author = Repo.get(User, item.user_id)

    [ %{ message_id: Enum.at(head, 0), author_id: author_id, author_name: author.name, body: Enum.at(head, 2),
      is_red: Enum.at(head, 3), insertion_date: Enum.at(head, 4), message_item_id: message_item_id,
      message_item_author_id: item.user_id, message_item_title: item.title, message_item_author_name: item_author.name,
      message_item_author_pic: item_author.profile_image_uri, message_author_pic: author.profile_image_uri } ]
      ++ get_messages_from_list_2(tail)
  end

  defp get_messages_from_list([]) do
    []
  end
  defp get_messages_from_list([head | tail]) do
    author_id = Enum.at(head, 1)
    author = Repo.get(User, author_id)
    [ %{ message_id: Enum.at(head, 0), author_id: author_id, author_name: author.name, body: Enum.at(head, 2),
      is_red: Enum.at(head, 3), insertion_date: Enum.at(head, 4) } ] ++ get_messages_from_list(tail)
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

  defp get_recent_unred_message_by_id([], outputs) do
    get_messages_from_list_2(outputs)
  end
  defp get_recent_unred_message_by_id([head | tail ], outputs) do
    query = from m in "messages",
                 where: m.id == ^head,
                 select: [m.id, m.author_id, m.body, m.is_red, m.insertion_date, m.item_id]

    output = Repo.all(query)
    outputs = outputs ++ output

    get_recent_unred_message_by_id(tail, outputs)
  end

  defp get_recent_messages_from_list([], map) do
    map
  end
  defp get_recent_messages_from_list([head | tail], map) do
    map =
      case Map.has_key?(map, "#{Enum.at(head, 1)}-#{Enum.at(head, 5)}") do
        true ->
          if map["#{Enum.at(head, 1)}-#{Enum.at(head, 5)}"] < Enum.at(head, 0) do
            Map.put(map, "#{Enum.at(head, 1)}-#{Enum.at(head, 5)}", Enum.at(head, 0))
          else
            map
          end
        false ->
          Map.put(map, "#{Enum.at(head, 1)}-#{Enum.at(head, 5)}", Enum.at(head, 0))
      end
    get_recent_messages_from_list(tail, map)
  end
end