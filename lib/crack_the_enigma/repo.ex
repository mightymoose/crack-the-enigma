defmodule CrackTheEnigma.Repo do
  use Ecto.Repo,
    otp_app: :crack_the_enigma,
    adapter: Ecto.Adapters.Postgres
end
