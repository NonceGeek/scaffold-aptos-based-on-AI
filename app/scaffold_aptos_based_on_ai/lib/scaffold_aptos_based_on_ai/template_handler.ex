defmodule ScaffoldAptosBasedOnAI.TemplateHandler do
    alias ScaffoldAptosBasedOnAI.SmartPrompterInteractor

  def gen_prompt(template_content, the_map) do
      Enum.reduce(the_map, template_content, fn {key, value}, acc ->
          key_str = Atom.to_string(key)
          # IO.puts "{#{key_str}}"
          String.replace(acc, "{#{key_str}}", value)
      end)
  end

  def find_ask_whitepaper() do
    endpoint = Constants.smart_prompter_endpoint()
    {:ok, %{data: templates}} = SmartPrompterInteractor.list_template(endpoint)
    Enum.find(templates, fn template ->
      template.title == "AskWhitepaper"
    end)
  end

  def find_generate_move_code() do
    endpoint = Constants.smart_prompter_endpoint()
    {:ok, %{data: templates}} = SmartPrompterInteractor.list_template(endpoint)
    Enum.find(templates, fn template ->
      template.id == 10
    end)
  end
end