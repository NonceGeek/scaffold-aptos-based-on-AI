defmodule ScaffoldAptosBasedOnAIWeb.PageLive do

  alias ScaffoldAptosBasedOnAI.DivenChatInteractor
  alias ScaffoldAptosBasedOnAI.ExChatServiceInteractor
  alias ScaffoldAptosBasedOnAI.{TemplateHandler, SmartPrompterInteractor}
  use ScaffoldAptosBasedOnAIWeb, :live_view
  
  @contract_embedbase_id "aptos-smart-contracts-fragment-by-structure"
  @whitepaper_embedbase_id "aptos-whitepaper-handled"

  @impl true
  def mount(_params, _session, socket) do
    # set session.
    :ok = SmartPrompterInteractor.set_session(Constants.smart_prompter_endpoint())
    {:ok,
     assign(socket,
      form: to_form(%{}, as: :f),
      question_now: "What is Aptos?",
      question_now_2: "Give me the examples about the Struct. Generate a Struct called AddressAggregator",
      question_now_3: "Give me the examples about the Function. Generate a public entry function called add",
      question_now_4: "Give me the examples about the Event. Generate a event called AddAddressEvent",
      question_now_5: "Give me the examples about the Spec. Generate a spec for verify the sum function",
      question_now_6: "Give me the examples about the Test. Generate a test about add function",
     )}
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "intro_apt_obj_model"}, _uri, socket) do
    answer = """
# Object
<br>
The [Object model](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/object.move) allows Move to represent a complex type as a set of resources stored within a single address and offers a rich capability model that allows for fine-grained resource control and ownership management.

In the object model, an NFT or token can place common token data within a Token resource, object data within an ObjectCore resource, and then specialize into additional resources as necessary. For example, a Player object could define a player within a game and be an NFT at the same time. The ObjectCore itself stores both the address of the current owner and the appropriate data for creating event streams.


## [Comparison with the account resources model](https://aptos.dev/standards/aptos-object#comparison-with-the-account-resources-model)


The existing Aptos data model emphasizes the use of the store ability within Move. Store allows for a struct to exist within any struct that is stored on-chain. As a result, data can live anywhere within any struct and at any address. While this provides great flexibility it has many limitations:

1. Data is not be guaranteed to be accessible, for example, it can be placed within a user-defined resource that may violate expectations for that data, e.g., a creator attempting to burn an NFT put into a user-defined store. This can be confusing to both the users and creators of this data.
2. Data of differing types can be stored to a single data structure (e.g., map, vector) via `any`, but for complex data types `any` incurs additional costs within Move as each access requires deserialization. It also can lead to confusion if API developers expect that a specific any field changes the type it represents.
3. While resource accounts allow for greater autonomy of data, they do so inefficiently for objects and do not take advantage of resource groups.
4. Data cannot be recursively composable, because Move currently prohibits recursive data structures. Furthermore, experience suggests that true recursive data structures can lead to security vulnerabilities.
5. Existing data cannot be easily referenced from entry functions, for example, supporting string validation requires many lines of code. Attempting to make tables directly becomes impractical as keys can be composed of many types, thus specializing to support within entry functions becomes complex.
6. Events cannot be emitted from data but from an account that may not be associated with the data.
7. Transferring logic is limited to the APIs provided in the respective modules and generally requires loading resources on both the sender and receiver adding unnecessary cost overheads.

> 💡Object is a core primitive in Aptos Move and created via the object module at 0x1::object.


**Reference:** 

> Code: https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/object.move
>
> Document: https://aptos.dev/standards/#object
"""
    {:ok,
      %{
        similarities: similarities
      }
    } = 
    EmbedbaseInteractor.search_data(@whitepaper_embedbase_id, "Introduce the Aptos Object Model?")
    {
      :noreply, 
      assign(socket, 
        page: String.to_integer(num),
        answer: answer, 
        search_result: similarities
      )
    }
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "aptos_design_token_model"}, _uri, socket) do

  answer = """
## [Token standard comparison](https://aptos.dev/guides/nfts/aptos-token-comparison/#token-standard-comparison)
<br>
In Ethereum or even the whole blockchain world, the Fungible Token (FT) was initially introduced by [EIP-20](https://eips.ethereum.org/EIPS/eip-20), and Non-Fungible Token (NFT) was defined in [EIP-721](https://eips.ethereum.org/EIPS/eip-721). Later, [EIP-1155](https://eips.ethereum.org/EIPS/eip-1155) was proposed to combine FT and NFT or even Semi-Fungible Token (SFT) into the one standard.

One deficiency of the Ethereum token contract is each token having to deploy individual contract code onto a contract account to distinguish it from other tokens even if it simply differs by name. Solana account model enables another pattern where code can be reused so that one generic program operates on various data. To create a new token, you could create an account that can mint tokens and more accounts that can receive them. The mint account itself uniquely determines the token type instead of contract account, and these are all passed as arguments to the one contract deployed to some executable account.

The Aptos token standard shares some similarities with Solana, especially how it covers FT, NFT and SFT in one standard and also has a similar generic token contract, which also implicitly defines token standard. Basically, instead of deploying a new ERC20 smart contract for each new token, all you need to do is call a function in the contract with necessary arguments. Depending on what function you call, the token contract will mint/transfer/burn/... tokens.
<br>
### [Token identification](https://aptos.dev/guides/nfts/aptos-token-comparison/#token-identification)
<br>
Aptos identifies a token by its `TokenId` that includes `TokenDataId` and `property_version`. The `property_version` shares the same concept with *Edition Account* in Solana, but there is no explicit counterpart in Ethereum as it is not required in any token standard interface.

`TokenDataId` is a globally unique identifier of token group sharing all the metadata except for `property_version`, including token creator address, collection name and token name. In Ethereum, the same concept is implemented by deploying a token contract under a unique address so an FT type or a collection of NFTs is identified by different contract addresses. In Solana, the similar concept for token identifier is implemented as mint account, each of which will represent one token type. In Aptos, a creator account can have multiple token types created by giving different collections and token names.
<br>
### [Token categorization](https://aptos.dev/guides/nfts/aptos-token-comparison/#token-categorization)
<br>
it is critical to understand, in Aptos, how to categorize different tokens to expect different sets of features:

- `Fungible Token`: Each FT has one unique `TokenId`, which means tokens sharing the same creator, collection, name and property version are fungible.
- `Non-Fungible Token`: NFTs always have different `TokenId`s, but it is noted that NFTs belonging to the same collection (by nature also the same creator) will share the same `creator` and `collection` fields in their `TokenDataId`s.
- `Semi-Fungible Token`: The crypto communities lack a common definition for SFT. The only consensus is SFTs are comparatively new types of tokens that combine the properties of NFTs and FTs. Usually this is realized via the customized logic based on different customized properties.

It's worth noting that Solana has an `Edition` concept that represents an NFT that was copied from a Master Edition NFT. This can apply to use cases such as tickets in that they are almost exactly the same except for some properties, for example, serial numbers or seats for tickets. They could be implemented in Aptos by bumping the token `property_version` and mutating corresponding fields in `token_properties`. In a nutshell, `Edition` is to Solana token is what `property_version` is to Aptos token; but there is no similar concept in Ethereum token standard.
<br>
### Token metadata[](https://aptos.dev/guides/nfts/aptos-token-comparison/#token-metadata)
<br>
Aptos token has metadata defined in `TokenData` with the multiple fields that describe widely acknowledged property data that needs to be understood by dapps. To name a few fields:

- `name`: The name of the token. It must be unique within a collection.
- `description`: The description of the token.
- `uri`: A URL pointer to off-chain for more information about the token. The asset could be media such as an image or video or more metadata in a JSON file.
- `supply`: The total number of units of this token.
- `token_properties`: a map-like structure containing optional or customized metadata not covered by existing fields.

In Ethereum, only a small portion of such properties are defined as methods, such as `name()`, `symbol()`, `decimals()`, `totalSupply()` of ERC-20; or `name()` and `symbol()` and `tokenURI()` of the optional metadata extension for ERC-721; ERC-1155 also has a similar method `uri()` in its own optional metadata extension. Therefore, for tokens on Ethereum, that token metadata is not standardized so that dapps have to take special treatment case by case, which incurs unnecessary overhead for developers and users.

In Solana, the Token Metadata program offers a Metadata Account defining numerous metadata fields associated with a token as well, including `collection` which is defined in `TokenDataId` in Aptos. Unfortunately, it fails to provide on-chain property with mutability configuration, which could improve the usability of the token standard by enabling more innovative smart contract logic based on on-chain properties. SFT is a good example of this. Instead, the `Token Standard` field introduced to Token Metadata v1.1.0 only provides `attributes` as a container to hold customized properties. However, it is neither mutable nor on-chain, as an off-chain JSON standard.
<br>
Reference: 
<br>
> Code: https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/aptos-token/sources
>
> Document: https://aptos.dev/guides/nfts/aptos-token-comparison/#token-standard-comparison

"""

    {:ok,
      %{
        similarities: similarities
      }
    } = 
    EmbedbaseInteractor.search_data(@whitepaper_embedbase_id, "How does Aptos design Token Model?")
    # TODO: search it in the documentation.
    {
      :noreply, 
      assign(socket, 
        page: String.to_integer(num),
        answer: answer,
        search_result: similarities
      )
    }
  end

  @impl true
  def handle_params(%{"page" => num, "question" => "use_aptos_cli"}, _uri, socket) do
    answer = """
The `aptos` tool is a command line interface (CLI) for developing on the Aptos blockchain, debugging, and for node operations. This document describes how to use the `aptos` CLI tool. To download or build the CLI, follow [Install Aptos CLI](https://aptos.dev/tools/install-cli/).

Reference:

> Document: https://aptos.dev/tools/aptos-cli-tool/use-aptos-cli
"""

    {:ok,
      %{
        similarities: similarities
      }
    } = 
    EmbedbaseInteractor.search_data(@whitepaper_embedbase_id, "How could I use Aptos CLI?")
    {
      :noreply, 
      assign(socket, 
        page: String.to_integer(num),
        answer: answer, 
        search_result: similarities
      )
    }
  end


  @impl true
  def handle_params(%{"page" => num}, _uri, socket) do
    {
      :noreply, 
      assign(socket, 
      page: String.to_integer(num))
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

  def handle_event("change-input", %{"_target" => ["f", "question_input"], "f" => %{"question_input" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_2"], "f" => %{"question_input_2" => question_2}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_2: question_2
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_3"], "f" => %{"question_input_3" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_3: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_4"], "f" => %{"question_input_4" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_4: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "question_input_5"], "f" => %{"question_input_5" => question}}, socket) do
    {
      :noreply, 
      assign(socket,
        question_now_5: question
      )
    }
  end

  def handle_event("change-input", %{"_target" => ["f", "select_dataset"]}, _, socket) do
    # TODO
    {
      :noreply, 
      socket
    }
  end



  def handle_event("show_waiting", _, socket) do
    IO.puts inspect "show_waiting"
    {
      :noreply, 
      assign(socket,
        show_waiting: true
      )
    }
  end

  def handle_event("submit", %{"f" => f}, socket) do
    do_handle_event(f, socket.assigns.page, socket)
  end

  @doc """
    * call the smart prompter to generate the prompt.
    * assert if the answer > 10 bytes.
    * call the GPT to generate the answer.
  """
  def do_handle_event(%{"question_input" => question}, 1, socket) do
    # {:ok,
    #   %{
    #     code: 0,
    #     data: %{
    #       answer: answer
    #     }
    #   }
    # } = DivenChatInteractor.chat(question)
    # using smart prompter to generate the answer.

    {:ok,
      %{
        similarities: similarities
      }
    } = 
    EmbedbaseInteractor.search_data(@whitepaper_embedbase_id, question)

    send(self(), {:get_answer, similarities, question})
    { 
      :noreply, 
      assign(socket,
        search_result: similarities
      )
    }
  end

  def handle_info({:get_answer, similarities, question}, socket) do
    handle_by_similarity(similarities, question, socket)
  end

  def handle_info({:get_answer_of_smart_contracts, filted_result, key, question}, socket) do
    handle_by_similarity_of_smart_contracts(filted_result, key, question, socket)
  end

  def handle_by_similarity_of_smart_contracts(similarities, key, question, socket) do
    similarity = similarities |> Enum.fetch!(0) |> Map.get(:data) 
    similiarities_handled = 
      similarities
      |> Enum.map(&(&1.data))
      |> Enum.reduce("", fn sim, acc -> "#{acc}\n\n* #{sim}" end)
    if byte_size(similarity) >= 20 do
      # similarities.
      # ask template.

      %{content: template} = TemplateHandler.find_generate_move_code()

      prompt = TemplateHandler.gen_prompt(
        template, 
        %{question: question, codes: similiarities_handled, type: key}
        )

      IO.puts inspect prompt

      {:ok,
        %{
          data: %{id: topic_id}
        }
      } = SmartPrompterInteractor.create_topic(Constants.smart_prompter_endpoint(), prompt)
      # wait 20 sec for the answer.
      # TODO: optimize
      Process.sleep(20000)
      {:ok,
        %{
          data: %{messages: msgs}
        }
      } = SmartPrompterInteractor.show_topic(Constants.smart_prompter_endpoint(), topic_id)
        answer = 
          msgs
          |> Enum.find(fn elem -> 
            elem.role == "assistant"
          end)
          |> Map.get(:content)
        { 
          :noreply, 
          assign(socket,
            answer: answer,
            prompt: prompt
          )
        }
    else
    # no similarities. 
      { 
        :noreply, 
        assign(socket,
          answer: "Sorry, but the question are not in the scope."
        )
      }
    end
  end

  def handle_by_similarity(similarities, question, socket) do
    similarity = similarities |> Enum.fetch!(0) |> Map.get(:data) 
    similiarities_handled = 
      similarities
      |> Enum.map(&(&1.data))
      |> Enum.reduce("", fn sim, acc -> "#{acc}\n\n* #{sim}" end)
    if byte_size(similarity) >= 20 do
      # similarities.
      # ask template.
      %{content: template} = TemplateHandler.find_ask_whitepaper()
      prompt = TemplateHandler.gen_prompt(template, %{question: question, content: similiarities_handled})
      {:ok,
        %{
          data: %{id: topic_id}
        }
      } = SmartPrompterInteractor.create_topic(Constants.smart_prompter_endpoint(), prompt)
      # wait 15 sec for the answer.
      # TODO: optimize
      Process.sleep(15000)
      {:ok,
        %{
          data: %{messages: msgs}
        }
      } = SmartPrompterInteractor.show_topic(Constants.smart_prompter_endpoint(), topic_id)
      answer = 
        msgs
        |> Enum.find(fn elem -> 
          elem.role == "assistant"
        end)
        |> Map.get(:content)
      { 
        :noreply, 
        assign(socket,
          answer: answer,
          prompt: prompt
        )
      }
    else
    # no similarities. 
      { 
        :noreply, 
        assign(socket,
          answer: "Sorry, but the question are not in the scope."
        )
      }
    end
  end

  def do_handle_event(%{"question_input_2" => question}, 2, socket) do
    search_and_ask(question, socket)
  end

  def search_and_ask(question, socket) do
    # search the dataset about the question.
    # get the answer by the GPT.
    question_for_ask = String.split(question, ".") |> Enum.fetch!(0)
    {:ok, %{similarities: similarities}} = 
      EmbedbaseInteractor.search_data(@contract_embedbase_id, question_for_ask)
      similarities = handle_search_results(similarities)
    # prompt = Enum.reduce(similarities, "Here are the code examples: ```", fn elem, acc -> 
    #   acc <> elem.data <> "\n"
    # end)

    # prompt = prompt <> "```"

    # {:ok, %{choices: [%{"message" => %{"content" => content}}]}} = ExChatServiceInteractor.chat(:chatable, "gpt-3.5-turbo", prompt, question)

    key = get_key_words(question)
    filted_result = 
      if key == :no_key do
        similarities
      else
        filter_search_result(similarities, "type", key)
      end
    
    send(self(), {:get_answer_of_smart_contracts, filted_result, key, question})

    {
      :noreply, 
      assign(socket,
        # answer: content,
        search_result: filted_result
      )
    }
  end

  def get_key_words(question) do
    cond do
      String.contains?(question, "struct") or  String.contains?(question, "Struct") or String.contains?(question, "Structs") or String.contains?(question, "structs") ->
        "struct"
      String.contains?(question, "spec") or  String.contains?(question, "Spec") or String.contains?(question, "Specs") or String.contains?(question, "specs") ->
        "spec"
      String.contains?(question, "function") or  String.contains?(question, "Function") or String.contains?(question, "Functions") or String.contains?(question, "functions") ->
        "function"
      String.contains?(question, "test") or  String.contains?(question, "Test") or String.contains?(question, "Tests") or String.contains?(question, "tests") ->
        "test"
      String.contains?(question, "event") or  String.contains?(question, "Event") or String.contains?(question, "Events") or String.contains?(question, "events") ->
        "struct"
      true ->
        :no_key
      end
  end

  def filter_search_result(search_result, key, value) do
    Enum.filter(search_result, fn %{metadata: metadata} ->
      # IO.puts inspect Map.fetch(metadata, String.to_atom(key))
      Map.fetch(metadata, String.to_atom(key)) == {:ok, value}
    end)
  end

  def handle_search_results(similarities) do
    Enum.map(similarities, fn elem -> 
      url = 
        case elem.metadata.file_name do
          "hello_blockchain" ->
            "https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/move-examples/hello_blockchain/sources/hello_blockchain.move"
          "hello_prover" ->
            "https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/move-examples/hello_prover/sources/prove.move"
          "common_account" ->
            "https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/move-examples/common_account/sources/common_account.move"
          "iterable_table" ->
            "https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/move-examples/data_structures/sources/iterable_table.move"
        end
      Map.put(elem, :url, url)
    end)
  end

  def do_handle_event(%{"question_input_3" => question}, 3, socket) do
    search_and_ask(question, socket)
  end

  def do_handle_event(%{"question_input_4" => question}, 4, socket) do
    search_and_ask(question, socket)
  end

  def do_handle_event(%{"question_input_5" => question}, 5, socket) do
    search_and_ask(question, socket)
  end

  def do_handle_event(%{"question_input_6" => question}, 6, socket) do
    search_and_ask(question, socket)
  end


  @impl true
  def render(assigns) do
    ~H"""
      <.container class="mt-10 mb-32">
        <center><.h1>Scaffold, Your Move Development copilot</.h1>
        <br>
        <.h5>
          Scaffold is a smart contract and dApp programming copilot built on OpenAI and the MoveSpaceDB.
        </.h5>
        <br>

        </center>
        <.form for={@form} phx-change="change-input" phx-submit="submit">
          <%= case @page do %>
            <%= 1 -> %>

            <.p>Select the Vector Dataset:</.p>
            <.select options={["aptos-whitepaper-handled": "aptos-whitepaper-handled", "aptos-smart-contracts-fragment-by-structure": "aptos-smart-contracts-fragment-by-structure"]} form={@form} field={:select_dataset} />
            <br>
            <.p>Or Input the <a href="https://app.embedbase.xyz/datasets" target="_blank" style="color:blue">Public Dataset</a> Name:</.p>
            <.text_input form={@form} field={:dataset_name} placeholder="eg. web3-dataset" />

            <!-- result panel -->
            <div class="grid gap-5 mt-5 md:grid-cols-1 lg:grid-cols-1" style="height: auto;">
              <.card>
              <!-- answer -->
              <%= if not is_nil(assigns[:answer]) do %>
                <br>
                <%= raw(Earmark.as_html!(assigns[:answer])) %>
              
              <% else %>
                <br><br><br>
                  <b>the smart answer would be shown here.</b>
                <br><br><br><br>
              <% end %>
              <!-- search result -->
              <%= if not is_nil(assigns[:search_result]) do %>
                <br>
                <.p><b>Search Results in Dataset:</b></.p>
                <.table>
                  <thead>
                    <.tr>
                      <.th>Result</.th>
                      <.th>Metadata</.th>
                    </.tr>
                  </thead>
                  <tbody>
                  <%= for elem <- assigns[:search_result] do %>
                    <.tr>
                      <.td><%= elem.data %></.td>
                      <.td><%= inspect(elem.metadata) %></.td>
                    </.tr>
                  <% end %>
                  </tbody>
                </.table>

              <% end %>
                </.card>
              </div>
            <br>
            <.text_input form={@form} field={:question_input} placeholder="Explain the account system in Aptos." value={assigns[:question_now]}/>            <br>
            <br>
            <center><.button phx-click="show_waiting" color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
            <br>
            <%= if assigns[:show_waiting] == true and is_nil(assigns[:answer]) do %>
              <center><b>Please waiting for 15 sec to get the answer...</b></center>
            <% end %>
            <br>
            <.p>Recommend Questions:</.p>
            <br>
            <a href="?page=1&question=intro_apt_obj_model">
              <div class="flex items-start">
                  <.alert color="info" label="Introduce the Aptos Object Model?" />
              </div>
            </a>
            <a href="?page=1&question=aptos_design_token_model">
              <div class="flex items-start mt-4">
                <.alert color="success" label="How does Aptos design Token Model?" />
              </div>
            </a>
            <!--<a href="?page=1&question=use_aptos_cli">
              <div class="flex items-start mt-4">
                <.alert color="warning" label="How could I use Aptos CLI?" />
              </div>
            </a>-->
            
          <%= 2 -> %>

            <.p>Select the Vector Dataset:</.p>
              <.select options={[ "aptos-smart-contracts-fragment-by-structure": "aptos-smart-contracts-fragment-by-structure", "aptos-whitepaper-handled": "aptos-whitepaper-handled"]} form={@form} field={:select_dataset} />
              <br>
              <.p>Or Input the <a href="https://app.embedbase.xyz/datasets" target="_blank" style="color:blue">Public Dataset</a> Name:</.p>
              <.text_input form={@form} field={:dataset_name} placeholder="eg. web3-dataset" />

              <!-- result panel -->
              <div class="grid gap-5 mt-5 md:grid-cols-1 lg:grid-cols-1" style="height: auto;">
                <.card>
                <!-- answer -->
                <%= if not is_nil(assigns[:answer]) do %>
                  <%= raw(Earmark.as_html!(assigns[:answer])) %>
                
                <% else %>
                  <br><br><br>
                    <b>the smart answer would be shown here.</b>
                  <br><br><br><br>
                <% end %>
                <!-- search result -->
                <%= if not is_nil(assigns[:search_result]) do %>
                  <br>
                  <.p><b>Search Results in Dataset:</b></.p>
                  <.table>
                    <thead>
                      <.tr>
                        <.th>Result</.th>
                        <.th>Metadata</.th>
                      </.tr>
                    </thead>
                    <tbody>
                    <%= for elem <- assigns[:search_result] do %>
                      <.tr>
                        <.td><%= elem.data %></.td>
                        <.td><%= inspect(elem.metadata) %></.td>
                      </.tr>
                    <% end %>
                    </tbody>
                  </.table>

                <% end %>
                  </.card>
                </div>
              <br>
              <.text_input form={@form} field={:question_input_2} placeholder={assigns[:question_now_2]} value={assigns[:question_now_2]}/>
              <br>
              <br>
              <center><.button phx-click="show_waiting" color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
              <br>
              <%= if assigns[:show_waiting] == true and is_nil(assigns[:answer]) do %>
                <center><b>Please waiting for 15 sec to get the answer...</b></center>
              <% end %>
              <br>
              <.p>Recommend Questions:</.p>
              <br>
              <a href="?page=1&question=intro_apt_obj_model">
                <div class="flex items-start">
                    <.alert color="info" label="Introduce the Aptos Object Model?" />
                </div>
              </a>
              <a href="?page=1&question=aptos_design_token_model">
                <div class="flex items-start mt-4">
                  <.alert color="success" label="How does Aptos design Token Model?" />
                </div>
              </a>
              <a href="?page=1&question=use_aptos_cli">
                <div class="flex items-start mt-4">
                  <.alert color="warning" label="How could I use Aptos CLI?" />
                </div>
              </a>
            <br>
          <%= 3 -> %>
<.p>Select the Vector Dataset:</.p>
              <.select options={[ "aptos-smart-contracts-fragment-by-structure": "aptos-smart-contracts-fragment-by-structure", "aptos-whitepaper-handled": "aptos-whitepaper-handled"]} form={@form} field={:select_dataset} />
              <br>
              <.p>Or Input the <a href="https://app.embedbase.xyz/datasets" target="_blank" style="color:blue">Public Dataset</a> Name:</.p>
              <.text_input form={@form} field={:dataset_name} placeholder="eg. web3-dataset" />

              <!-- result panel -->
              <div class="grid gap-5 mt-5 md:grid-cols-1 lg:grid-cols-1" style="height: auto;">
                <.card>
                <!-- answer -->
                <%= if not is_nil(assigns[:answer]) do %>
                  <%= raw(Earmark.as_html!(assigns[:answer])) %>
                
                <% else %>
                  <br><br><br>
                    <b>the smart answer would be shown here.</b>
                  <br><br><br><br>
                <% end %>
                <!-- search result -->
                <%= if not is_nil(assigns[:search_result]) do %>
                  <br>
                  <.p><b>Search Results in Dataset:</b></.p>
                  <.table>
                    <thead>
                      <.tr>
                        <.th>Result</.th>
                        <.th>Metadata</.th>
                      </.tr>
                    </thead>
                    <tbody>
                    <%= for elem <- assigns[:search_result] do %>
                      <.tr>
                        <.td><%= elem.data %></.td>
                        <.td><%= inspect(elem.metadata) %></.td>
                      </.tr>
                    <% end %>
                    </tbody>
                  </.table>

                <% end %>
                  </.card>
                </div>
              <br>
              <.text_input form={@form} field={:question_input_3} placeholder={assigns[:question_now_3]} value={assigns[:question_now_3]}/>
              <br>
              <br>
              <center><.button phx-click="show_waiting" color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
              <br>
              <%= if assigns[:show_waiting] == true and is_nil(assigns[:answer]) do %>
                <center><b>Please waiting for 15 sec to get the answer...</b></center>
              <% end %>
              <br>
              <.p>Recommend Questions:</.p>
              <br>
              <a href="?page=1&question=intro_apt_obj_model">
                <div class="flex items-start">
                    <.alert color="info" label="Introduce the Aptos Object Model?" />
                </div>
              </a>
              <a href="?page=1&question=aptos_design_token_model">
                <div class="flex items-start mt-4">
                  <.alert color="success" label="How does Aptos design Token Model?" />
                </div>
              </a>
              <a href="?page=1&question=use_aptos_cli">
                <div class="flex items-start mt-4">
                  <.alert color="warning" label="How could I use Aptos CLI?" />
                </div>
              </a>
            <br>
          <%= 4 -> %>
            <.p>Select the Vector Dataset:</.p>
              <.select options={[ "aptos-smart-contracts-fragment-by-structure": "aptos-smart-contracts-fragment-by-structure", "aptos-whitepaper-handled": "aptos-whitepaper-handled"]} form={@form} field={:select_dataset} />
              <br>
              <.p>Or Input the <a href="https://app.embedbase.xyz/datasets" target="_blank" style="color:blue">Public Dataset</a> Name:</.p>
              <.text_input form={@form} field={:dataset_name} placeholder="eg. web3-dataset" />

              <!-- result panel -->
              <div class="grid gap-5 mt-5 md:grid-cols-1 lg:grid-cols-1" style="height: auto;">
                <.card>
                <!-- answer -->
                <%= if not is_nil(assigns[:answer]) do %>
                  <%= raw(Earmark.as_html!(assigns[:answer])) %>
                
                <% else %>
                  <br><br><br>
                    <b>the smart answer would be shown here.</b>
                  <br><br><br><br>
                <% end %>
                <!-- search result -->
                <%= if not is_nil(assigns[:search_result]) do %>
                  <br>
                  <.p><b>Search Results in Dataset:</b></.p>
                  <.table>
                    <thead>
                      <.tr>
                        <.th>Result</.th>
                        <.th>Metadata</.th>
                      </.tr>
                    </thead>
                    <tbody>
                    <%= for elem <- assigns[:search_result] do %>
                      <.tr>
                        <.td><%= elem.data %></.td>
                        <.td><%= inspect(elem.metadata) %></.td>
                      </.tr>
                    <% end %>
                    </tbody>
                  </.table>

                <% end %>
                  </.card>
                </div>
              <br>
              <.text_input form={@form} field={:question_input_4} placeholder={assigns[:question_now_4]} value={assigns[:question_now_4]}/>
              <br>
              <br>
              <center><.button phx-click="show_waiting" color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
              <br>
              <%= if assigns[:show_waiting] == true and is_nil(assigns[:answer]) do %>
                <center><b>Please waiting for 15 sec to get the answer...</b></center>
              <% end %>
              <br>
              <.p>Recommend Questions:</.p>
              <br>
              <a href="?page=1&question=intro_apt_obj_model">
                <div class="flex items-start">
                    <.alert color="info" label="Introduce the Aptos Object Model?" />
                </div>
              </a>
              <a href="?page=1&question=aptos_design_token_model">
                <div class="flex items-start mt-4">
                  <.alert color="success" label="How does Aptos design Token Model?" />
                </div>
              </a>
              <a href="?page=1&question=use_aptos_cli">
                <div class="flex items-start mt-4">
                  <.alert color="warning" label="How could I use Aptos CLI?" />
                </div>
              </a>
            <br>

          <%= 5 -> %>
<.p>Select the Vector Dataset:</.p>
              <.select options={[ "aptos-smart-contracts-fragment-by-structure": "aptos-smart-contracts-fragment-by-structure", "aptos-whitepaper-handled": "aptos-whitepaper-handled"]} form={@form} field={:select_dataset} />
              <br>
              <.p>Or Input the <a href="https://app.embedbase.xyz/datasets" target="_blank" style="color:blue">Public Dataset</a> Name:</.p>
              <.text_input form={@form} field={:dataset_name} placeholder="eg. web3-dataset" />

              <!-- result panel -->
              <div class="grid gap-5 mt-5 md:grid-cols-1 lg:grid-cols-1" style="height: auto;">
                <.card>
                <!-- answer -->
                <%= if not is_nil(assigns[:answer]) do %>
                  <%= raw(Earmark.as_html!(assigns[:answer])) %>
                
                <% else %>
                  <br><br><br>
                    <b>the smart answer would be shown here.</b>
                  <br><br><br><br>
                <% end %>
                <!-- search result -->
                <%= if not is_nil(assigns[:search_result]) do %>
                  <br>
                  <.p><b>Search Results in Dataset:</b></.p>
                  <.table>
                    <thead>
                      <.tr>
                        <.th>Result</.th>
                        <.th>Metadata</.th>
                      </.tr>
                    </thead>
                    <tbody>
                    <%= for elem <- assigns[:search_result] do %>
                      <.tr>
                        <.td><%= elem.data %></.td>
                        <.td><%= inspect(elem.metadata) %></.td>
                      </.tr>
                    <% end %>
                    </tbody>
                  </.table>

                <% end %>
                  </.card>
                </div>
              <br>
              <.text_input form={@form} field={:question_input_5} placeholder={assigns[:question_now_5]} value={assigns[:question_now_5]}/>
              <br>
              <br>
              <center><.button phx-click="show_waiting" color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
              <br>
              <%= if assigns[:show_waiting] == true and is_nil(assigns[:answer]) do %>
                <center><b>Please waiting for 15 sec to get the answer...</b></center>
              <% end %>
              <br>
              <.p>Recommend Questions:</.p>
              <br>
              <a href="?page=1&question=intro_apt_obj_model">
                <div class="flex items-start">
                    <.alert color="info" label="Introduce the Aptos Object Model?" />
                </div>
              </a>
              <a href="?page=1&question=aptos_design_token_model">
                <div class="flex items-start mt-4">
                  <.alert color="success" label="How does Aptos design Token Model?" />
                </div>
              </a>
              <a href="?page=1&question=use_aptos_cli">
                <div class="flex items-start mt-4">
                  <.alert color="warning" label="How could I use Aptos CLI?" />
                </div>
              </a>
            <br>
          <%= 6 -> %>
<.p>Select the Vector Dataset:</.p>
              <.select options={[ "aptos-smart-contracts-fragment-by-structure": "aptos-smart-contracts-fragment-by-structure", "aptos-whitepaper-handled": "aptos-whitepaper-handled"]} form={@form} field={:select_dataset} />
              <br>
              <.p>Or Input the <a href="https://app.embedbase.xyz/datasets" target="_blank" style="color:blue">Public Dataset</a> Name:</.p>
              <.text_input form={@form} field={:dataset_name} placeholder="eg. web3-dataset" />

              <!-- result panel -->
              <div class="grid gap-5 mt-5 md:grid-cols-1 lg:grid-cols-1" style="height: auto;">
                <.card>
                <!-- answer -->
                <%= if not is_nil(assigns[:answer]) do %>
                  <%= raw(Earmark.as_html!(assigns[:answer])) %>
                
                <% else %>
                  <br><br><br>
                    <b>the smart answer would be shown here.</b>
                  <br><br><br><br>
                <% end %>
                <!-- search result -->
                <%= if not is_nil(assigns[:search_result]) do %>
                  <br>
                  <.p><b>Search Results in Dataset:</b></.p>
                  <.table>
                    <thead>
                      <.tr>
                        <.th>Result</.th>
                        <.th>Metadata</.th>
                      </.tr>
                    </thead>
                    <tbody>
                    <%= for elem <- assigns[:search_result] do %>
                      <.tr>
                        <.td><%= elem.data %></.td>
                        <.td><%= inspect(elem.metadata) %></.td>
                      </.tr>
                    <% end %>
                    </tbody>
                  </.table>

                <% end %>
                  </.card>
                </div>
              <br>
              <.text_input form={@form} field={:question_input_6} placeholder={assigns[:question_now_6]} value={assigns[:question_now_6]}/>
              <br>
              <br>
              <center><.button phx-click="show_waiting" color="primary" label="Get Smart Answer ⏎" variant="outline" /></center>
              <br>
              <%= if assigns[:show_waiting] == true and is_nil(assigns[:answer]) do %>
                <center><b>Please waiting for 15 sec to get the answer...</b></center>
              <% end %>
              <br>
              <.p>Recommend Questions:</.p>
              <br>
              <a href="?page=1&question=intro_apt_obj_model">
                <div class="flex items-start">
                    <.alert color="info" label="Introduce the Aptos Object Model?" />
                </div>
              </a>
              <a href="?page=1&question=aptos_design_token_model">
                <div class="flex items-start mt-4">
                  <.alert color="success" label="How does Aptos design Token Model?" />
                </div>
              </a>
              <a href="?page=1&question=use_aptos_cli">
                <div class="flex items-start mt-4">
                  <.alert color="warning" label="How could I use Aptos CLI?" />
                </div>
              </a>
            <br>
          <%= _others -> %>
            # TODO
          <% end %>
          <br>
        </.form>
        <br>
        <center>
        <span>
            <.link href={~p"/?page=1"} style="color:blue">Step 0x01 - Basic Concept Study</.link> |
            <.link href={~p"/?page=2"} style="color:blue">Step 0x02 - Buidl the Structs</.link>
            <br>
            <.link href={~p"/?page=3"} style="color:blue">Step 0x03 - Buidl the Functions</.link> | 
            <.link href={~p"/?page=4"} style="color:blue">Step 0x04 - Buidl the Events</.link> | 
            <.link href={~p"/?page=5"} style="color:blue">Step 0x05 - Buidl the Specs(Optional)</.link> | 
            <.link href={~p"/?page=6"} style="color:blue">Step 0x06 - Generate the Tests for the Contract</.link>
            <br>
            <.link href={~p"/?page=7"} style="color:blue">Step 0x07 - Generate README of the Smart Contract</.link>
          </span>
        </center>
      </.container>
    """
  end
end
