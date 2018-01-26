defmodule StuffSwap.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias StuffSwap.Account.User
  alias StuffSwap.Store.Item

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :profile_image_uri, :string

    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name, :profile_image_uri])
    |> validate_required([:email, :password, :name, :profile_image_uri])
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> validate_length(:password, min: 8, max: 100)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
