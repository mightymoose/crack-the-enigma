defmodule CrackTheEnigmaWeb.CrackTheEnigma.IndexLive do
  use CrackTheEnigmaWeb, :live_view

  alias Faker.Lorem

  @default_number_of_rotors 2
  @default_number_of_paragraphs 10

  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok,
       socket
       |> assign(:generating_cyphertext, false)
       |> assign(:number_of_rotors, @default_number_of_rotors)
       |> assign(:plaintext, generate_plaintext(@default_number_of_paragraphs))}
    else
      {:ok, assign(socket, :generating_cyphertext, true)}
    end
  end

  def handle_event("add_rotor", _unsigned_params, socket) do
    {:noreply, update(socket, :number_of_rotors, &(&1 + 1))}
  end

  def handle_event("remove_rotor", _unsigned_params, socket) do
    {:noreply, update(socket, :number_of_rotors, &(&1 - 1))}
  end

  def handle_event("check_my_answer", %{"guess" => guess}, socket) do
    {:noreply, maybe_show_success_message(socket, guess)}
  end

  defp maybe_show_success_message(socket, guess) do
    plaintext = socket.assigns.plaintext

    if guess == plaintext do
      socket
      |> put_flash(:info, "SUCCESS!")
    else
      socket
    end
  end

  defp generate_plaintext(number_of_paragraphs) do
    number_of_paragraphs
    |> Lorem.paragraphs()
    |> Enum.join(" ")
  end
end
