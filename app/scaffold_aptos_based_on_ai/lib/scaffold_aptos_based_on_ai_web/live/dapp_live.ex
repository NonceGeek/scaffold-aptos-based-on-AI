defmodule ScaffoldAptosBasedOnAIWeb.DAppLive do
  use ScaffoldAptosBasedOnAIWeb, :live_view

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
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, modal: false, slide_over: false)}

      :modal ->
        {:noreply, assign(socket, modal: params["size"])}

      :slide_over ->
        {:noreply, assign(socket, slide_over: params["origin"])}

      :pagination ->
        {:noreply, assign(socket, pagination_page: String.to_integer(params["page"]))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.container class="mt-10 mb-32">
        <center><.h1>Scaffold Aptos based on AI <br>dApp Copilot</.h1>
        <br>
        <.h5>
          AI-based Scaffold Aptos is a smart contract and dApp programming copilot built on OpenAI and the AI database Embedbase.
        </.h5>
        <br>
        <.button color="secondary" label="Visit the Public Vector Dataset about Aptos dApp" variant="shadow" />
        <br><br>
        <.button color="white" label="Submit an on-chain Proposal to the  Public Vector Dataset about Aptos dApp" variant="shadow" />
        <br><br>
        </center>
        <center>
        <span>
            <.link href={~p"/dapp?page=1"} style="color:blue">Step 0x01 - Basic Concept Study</.link> |
            <.link href={~p"/dapp?page=2"} style="color:blue">Step 0x02 - Generate Call Funcs</.link>
            <br>
            <.link href={~p"/dapp?page=3"} style="color:blue">Step 0x03 - Generate View Objects Code</.link> | 
            <.link href={~p"/dapp?page=4"} style="color:blue">Step 0x04 - Generate View Events Code</.link>
            <br>
            <.link href={~p"/dapp?page=5"} style="color:blue">Step 0x05 - Code Suggestions</.link> |
            <.link href={~p"/dapp?page=6"} style="color:blue">Step 0x06 - Generate README of the dApp</.link>
          </span>
        </center>
      </.container>
    """
  end
end
