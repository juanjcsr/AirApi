defmodule AirApi.User do
  use AirApi.Web, :model


  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w()


  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, ~w(password password_confirmation), [])
    |> validate_length(:password, min: 5)
    |> validate_password_confirmation(:password)
    |> put_password_hash
  end

  defp validate_password_confirmation(changeset, field) do
    value = get_field(changeset, field)
    confirmation = get_field(changeset, :"#{field}_confirmation")
    if value != confirmation, do: add_error(changeset, :"#{field}_confirmation", "does not match"), else: changeset
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

end