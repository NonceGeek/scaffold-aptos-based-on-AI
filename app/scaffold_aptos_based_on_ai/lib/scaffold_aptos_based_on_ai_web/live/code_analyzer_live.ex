defmodule ScaffoldAptosBasedOnAIWeb.CodeAnalyzerLive do
  use ScaffoldAptosBasedOnAIWeb, :live_view
  alias Web3AptosEx.Aptos.SmartContractParser

    @impl true
    def mount(_params, _session, socket) do
        {
            :ok, 
            assign(socket,
              form: to_form(%{}, as: :f),
              codes_now: " module hello_blockchain::message {\n            use std::error;\n            use std::signer;\n            use std::string;\n            use aptos_framework::account;\n            use aptos_framework::event;\n\n        //:!:>resource\n            struct MessageHolder has key {\n                message: string::String,\n                message_change_events: event::EventHandle<MessageChangeEvent>,\n            }\n        //<:!:resource\n\n            struct MessageChangeEvent has drop, store {\n                from_message: string::String,\n                to_message: string::String,\n            }\n\n            /// There is no message present\n            const ENO_MESSAGE: u64 = 0;\n\n            #[view]\n            public fun get_message(addr: address): string::String acquires MessageHolder {\n                assert!(exists<MessageHolder>(addr), error::not_found(ENO_MESSAGE));\n                borrow_global<MessageHolder>(addr).message\n            }\n\n            public entry fun set_message(account: signer, message: string::String)\n            acquires MessageHolder {\n                let account_addr = signer::address_of(&account);\n                if (!exists<MessageHolder>(account_addr)) {\n                    move_to(&account, MessageHolder {\n                        message,\n                        message_change_events: account::new_event_handle<MessageChangeEvent>(&account),\n                    })\n                } else {\n                    let old_message_holder = borrow_global_mut<MessageHolder>(account_addr);\n                    let from_message = old_message_holder.message;\n                    event::emit_event(&mut old_message_holder.message_change_events, MessageChangeEvent {\n                        from_message,\n                        to_message: copy message,\n                    });\n                    old_message_holder.message = message;\n                }\n            }\n\n            #[test(account = @0x1)]\n            public entry fun sender_can_set_message(account: signer) acquires MessageHolder {\n                let addr = signer::address_of(&account);\n                aptos_framework::account::create_account_for_test(addr);\n                set_message(account,  string::utf8(b\"Hello, Blockchain\"));\n\n                assert!(\n                get_message(addr) == string::utf8(b\"Hello, Blockchain\"),\n                ENO_MESSAGE\n                );\n            }\n        }"
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