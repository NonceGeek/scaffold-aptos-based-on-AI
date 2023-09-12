defmodule ScaffoldAptosBasedOnAIWeb.CodeAnalyzerLive do
  use ScaffoldAptosBasedOnAIWeb, :live_view
  alias Web3AptosEx.Aptos.SmartContractParser

    @impl true
    def mount(_params, _session, socket) do
        {
            :ok, 
            assign(socket,
              form: to_form(%{}, as: :f),
        )}
    end

    def handle_params(_params, _url, socket) do
        {:noreply, socket}
    end

    @impl true
    def handle_event("record", %{"f" => %{"codes" => codes}}, socket) do
        IO.puts inspect codes
        {
            :noreply, 
            socket
            # assign(
            #     socket,
            #     codes_now: codes
            # )
        }
    end
    
    @impl true
    def handle_event("change_codes", %{"f" => %{"codes" => codes}}, socket) do
        # IO.puts "lllll"
        # IO.puts inspect codes
        {
            :noreply, 
            # socket
            assign(
                socket,
                codes_now: codes
            )
        }
    end

    def handle_event("analyze", %{"f" => %{"codes" => codes}}, socket) do
        # IO.puts "ddddd"
        {:ok, codes_handled} = SmartContractParser.parse_code(codes)
        funcs = get_codes(:function, codes_handled)
        structs = get_codes(:struct, codes_handled)
        events = get_codes(:event, codes_handled)
        {
            :noreply, 
            # socket
            assign(socket, 
                functions: funcs,
                structs: structs,
                events: events
            )
        }
    end

    def get_codes(code_type, codes_handled) do
        codes_handled 
        |> Enum.filter(fn {key, value} -> key==code_type end)
        |> Enum.reduce([], fn {key, value}, acc -> acc ++ [value] end)
        |> Enum.map(fn function -> 
            Enum.reduce(function, "", fn sen, acc -> 
                "#{acc}\n#{sen}"
            end)
        end)
        
    end
    def render(assigns) do
        ~H"""
            <.container class="mt-10 mb-32">
                <center>
                <.h1>
                    A Example showing how to analyze the aptos smart contract by 
                     <a target="_blank" href="https://github.com/noncegeek/web3_aptos_ex" style="color: blue;">
                     web3_aptos_ex
                     </a>
                </.h1>
                <.form for={@form} phx-change="change_codes" phx-submit="analyze">
                    <.p>Input Any Aptos Smart Contract Code Here:</.p>
                    <.textarea form={@form} field={:codes} value={assigns[:codes_now]} style="height: 800px"/>
                    
                    <br>
                    <center>
                    <.button color="secondary" variant="outline">
                        Analyze
                    </.button>
                    </center>
                    <br>

                </.form>
                </center>


                <%= if not is_nil(assigns[:functions]) do %>
                    <.table>
                    <thead>
                        <.tr>
                        <.th>Functions</.th>
                        </.tr>
                    </thead>
                    <tbody>
                    <%= for func <- assigns[:functions] do %>
                        <.tr>
                        <.td> <%= raw(Earmark.as_html!("```#{func}\n```")) %></.td>
                        </.tr>
                    <% end %>
                    </tbody>
                    </.table>
                <% end %>


                <%= if not is_nil(assigns[:structs]) do %>
                    <.table>
                    <thead>
                        <.tr>
                        <.th>Structs</.th>
                        </.tr>
                    </thead>
                    <tbody>
                    <%= for func <- assigns[:structs] do %>
                        <.tr>
                        <.td> <%= raw(Earmark.as_html!("```#{func}\n```")) %></.td>
                        </.tr>
                    <% end %>
                    </tbody>
                    </.table>
                <% end %>

                <%= if not is_nil(assigns[:events]) do %>
                    <.table>
                    <thead>
                        <.tr>
                        <.th>Events</.th>
                        </.tr>
                    </thead>
                    <tbody>
                    <%= for func <- assigns[:events] do %>
                        <.tr>
                        <.td> <%= raw(Earmark.as_html!("```#{func}\n```")) %></.td>
                        </.tr>
                    <% end %>
                    </tbody>
                    </.table>
                <% end %>
            </.container>
        """
    end 
end