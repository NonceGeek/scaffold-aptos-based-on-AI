defmodule Constants do
    def get_github_token() do
      System.get_env("GITHUB_TOKEN")
    end

    def embedbase_key() do
      System.get_env("EMBEDBASE_KEY")
    end

    def get_diven_url() do
      System.get_env("DIVEN_URL")
    end
  end
