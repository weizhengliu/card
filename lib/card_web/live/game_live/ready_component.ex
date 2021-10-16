defmodule CardWeb.ReadyComponent do
  use CardWeb, :live_component

  def handle_event("ready", _params, %{assigns: %{player: player, room: room}} = socket) do
    Card.Room.update(room.id, Map.replace(room, :"#{player}_ready", true))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col p-4 text-center mt-8">
      <div class="bg-blue-300 -mt-8 w-32 h-8 rounded-xl transform skew-x-12 -rotate-6 translate-y-6 translate-x-20"></div>
      <h2 class="transform text-2xl font-serif"><%= @title %></h2>
      <div class="flex justify-between mt-2 w-60">
        <.ready_status player={is_you("Host", @player)} ready={@room.host_ready}/>
        <.ready_status player={is_you("Guest", @player)} ready={@room.guest_ready}/>
      </div>
      <%= unless Map.get(@room, :"#{@player}_ready") do %>
        <div class="flex justify-between w-40 mx-auto mt-8">
          <div class="text-lg text-center">Are you ready?</div>
          <div class="h-8">
            <div class="bg-green-300 w-8 h-8 rounded-xl transform skew-x-12 -rotate-45 translate-x-2"></div>
            <button phx-click="ready" phx-target={@myself} class="transform -translate-y-7 text-xl">Yes</button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp is_you("Host", :host), do: "You"
  defp is_you("Guest", :guest), do: "You"
  defp is_you(name, _player), do: name

  def ready_status(assigns) do
    ~H"""
    <div class="flex">
      <%= @player %>:
      <%= if @ready do %>
        <div class={"ml-8 bg-green-300 w-6 h-6 rounded-3xl transform -skew-x-3 rotate-12"}></div>
      <% else %>
        <div class={"ml-8 bg-red-300 w-6 h-6 rounded-3xl transform -skew-x-3 rotate-12"}></div>
      <% end %>
    </div>
    """
  end
end
