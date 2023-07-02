defmodule ScaffoldSuiBasedOnAiWeb.PageLive do
  use ScaffoldSuiBasedOnAiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       pagination_page: 1,
       active_tab: :live
     )}
  end

  @impl true
  def handle_params(%{"page" => "1"}, _uri, socket) do
    
    {
      :noreply, 
      assign(socket, 
      page: 1)
    }
  end

  @impl true
  def handle_params(%{}, _uri, socket) do
    {
      :noreply, 
      assign(socket, 
      page: 1)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.container class="mt-10 mb-32">
        <center><.h1>Scaffold Sui based on AI <br>Contract Copilot</.h1>
        <br>
        <.h5>
          AI-based Scaffold Sui is a smart contract and dApp programming copilot built on OpenAI and the AI database Embedbase.
        </.h5>
        <br>
        <.button color="secondary" label="Visit the Public Vector Dataset about Sui Smart Contract" variant="shadow" />
        <br><br>
        <.button color="white" label="Submit an on-chain Proposal to the  Public Vector Dataset about Sui Smart Contract" variant="shadow" />
        <br><br>
        </center>
        <%= case @page do %>
        <%= 1 -> %>
          <.text_input field={:text_input} placeholder="What is Sui?" />
          <br>
          <center><.button color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
          <br>
          <.p>Recommend Questions:</.p>
          <br>
          <div class="flex items-start">
            <.alert color="info" label="Introduce the Sui Object Model?" />
          </div>
          <div class="flex items-start mt-4">
            <.alert color="success" label="What is Programmable Transaction?" />
          </div>
          <div class="flex items-start mt-4">
            <.alert color="warning" label="How could I use Sui CLI?" />
          </div>
        <%= _others -> %>
          fffff
        <% end %>
        <br>
        <center>
        <span>
            <.link href={~p"/?page=1"} style="color:blue">Step 0x01 - Basic Concept Study</.link> |
            <.link href={~p"/?page=2"} style="color:blue">Step 0x02 - Buidl the Objects</.link>
            <br>
            <.link href={~p"/?page=3"} style="color:blue">Step 0x03 - Buidl the Function Interface</.link> | 
            <.link href={~p"/?page=4"} style="color:blue">Step 0x04 - Buidl the Events</.link>
            <br>
            <.link href={~p"/?page=5"} style="color:blue">Step 0x05 - Impl the Functions</.link> |
            <.link href={~p"/?page=6"} style="color:blue">Step 0x06 - Generate the Tests for the Contract</.link>
            <br>
            <.link href={~p"/?page=7"} style="color:blue">Step 0x07 - Generate README of the Smart Contract</.link>
          </span>
        </center>
      </.container>
    """
  end
end
