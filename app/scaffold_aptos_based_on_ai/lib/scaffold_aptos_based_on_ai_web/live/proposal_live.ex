defmodule ScaffoldAptosBasedOnAIWeb.ProposalLive do
  use ScaffoldAptosBasedOnAIWeb, :live_view

    @impl true
    def mount(_params, _session, socket) do
        {:ok, socket}
    end

    @impl true
    def handle_event(_key, _params, socket) do
        {:noreply, socket}
    end

    def handle_params(_params, _url, socket) do
        {:noreply, socket}
    end

    def render(assigns) do
        ~H"""
            <.container class="mt-10 mb-32">
                <center><.h1>Submit a Proposal to the Public Dataset!</.h1></center>
                <br>
                <.select options={[SmartContractDataset: "smart_contract_dataset", dAppDataset: "dapp_dataset"]} field={:select} />
                <br>
                <.text_input placeholder="title"/>
                <br>
                <.text_input placeholder="content"/>
                <br>
                <a target="_blank" href="https://explorer.aptoslabs.com/account/0x8f86da0052e425b0e391a4befaab137aa29d18201b4392deade879aa264383be/modules/run/governancer/get_proposal?network=testnet">
                    <center><.button color="primary" label="Submit the Proposal⏎" variant="outline" /></center>
                </a>
            </.container>
        """
    end 
end