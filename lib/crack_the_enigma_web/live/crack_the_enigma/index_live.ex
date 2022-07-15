defmodule CrackTheEnigmaWeb.CrackTheEnigma.IndexLive do
  use CrackTheEnigmaWeb, :live_view

  alias Faker.Lorem

  @default_number_of_rotors 3
  @default_number_of_paragraphs 10

  def mount(_params, _session, socket) do
    if connected?(socket) do
      plaintext = generate_plaintext(@default_number_of_paragraphs)
      cyphertext = generate_cyphertext(@default_number_of_rotors, plaintext)

      {:ok,
       socket
       |> assign(:generating_cyphertext, false)
       |> assign(:number_of_rotors, @default_number_of_rotors)
       |> assign(:plaintext, plaintext)
       |> assign(:viewing_cyphertext, true)
       |> assign(:javascript_error, false)
       |> assign(:cyphertext, cyphertext)}
    else
      {:ok,
       socket
       |> assign(:generating_cyphertext, true)
       |> assign(:number_of_rotors, @default_number_of_rotors)}
    end
  end

  def handle_event("javascript_error", _unsigned_params, socket) do
    {:noreply, assign(socket, :javascript_error, true)}
  end

  def handle_event("view_cyphertext", _unsigned_params, socket) do
    {:noreply, assign(socket, :viewing_cyphertext, true)}
  end

  def handle_event("view_plaintext", _unsigned_params, socket) do
    {:noreply, assign(socket, :viewing_cyphertext, false)}
  end

  def handle_event("add_rotor", _unsigned_params, socket) do
    plaintext = socket.assigns.plaintext
    number_of_rotors = socket.assigns.number_of_rotors + 1

    {:noreply,
     socket
     |> update(:number_of_rotors, &(&1 + 1))
     |> assign(:cyphertext, generate_cyphertext(number_of_rotors, plaintext))}
  end

  def handle_event("remove_rotor", _unsigned_params, socket) do
    plaintext = socket.assigns.plaintext
    number_of_rotors = max(socket.assigns.number_of_rotors - 1, 1)

    {:noreply,
     socket
     |> assign(:number_of_rotors, number_of_rotors)
     |> assign(:cyphertext, generate_cyphertext(number_of_rotors, plaintext))}
  end

  def handle_event("check_my_answer", %{"guess" => guess}, socket) do
    {:noreply,
     socket
     |> assign(:javascript_error, false)
     |> maybe_show_success_message(guess)}
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

  defp generate_cyphertext(number_of_rotors, plaintext) do
    "cypher#{number_of_rotors}" <> plaintext
  end
end
