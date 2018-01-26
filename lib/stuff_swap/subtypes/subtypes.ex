defmodule StuffSwap.Subtypes do
  @moduledoc """
  The Subtypes context.
  """

  import Ecto.Query, warn: false
  alias StuffSwap.Repo

  alias StuffSwap.Subtypes.Subcategory

  @doc """
  Returns the list of subcategories.

  ## Examples

      iex> list_subcategories()
      [%Subcategory{}, ...]

  """
  def list_subcategories do
    Repo.all(Subcategory)
  end

  @doc """
  Gets a single subcategory.

  Raises `Ecto.NoResultsError` if the Subcategory does not exist.

  ## Examples

      iex> get_subcategory!(123)
      %Subcategory{}

      iex> get_subcategory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subcategory!(id), do: Repo.get!(Subcategory, id)

  @doc """
  Creates a subcategory.

  ## Examples

      iex> create_subcategory(%{field: value})
      {:ok, %Subcategory{}}

      iex> create_subcategory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subcategory(attrs \\ %{}) do
    %Subcategory{}
    |> Subcategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subcategory.

  ## Examples

      iex> update_subcategory(subcategory, %{field: new_value})
      {:ok, %Subcategory{}}

      iex> update_subcategory(subcategory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subcategory(%Subcategory{} = subcategory, attrs) do
    subcategory
    |> Subcategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Subcategory.

  ## Examples

      iex> delete_subcategory(subcategory)
      {:ok, %Subcategory{}}

      iex> delete_subcategory(subcategory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subcategory(%Subcategory{} = subcategory) do
    Repo.delete(subcategory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subcategory changes.

  ## Examples

      iex> change_subcategory(subcategory)
      %Ecto.Changeset{source: %Subcategory{}}

  """
  def change_subcategory(%Subcategory{} = subcategory) do
    Subcategory.changeset(subcategory, %{})
  end
end
