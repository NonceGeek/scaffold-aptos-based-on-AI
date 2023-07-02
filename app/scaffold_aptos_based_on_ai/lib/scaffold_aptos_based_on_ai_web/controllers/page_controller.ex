defmodule ScaffoldSuiBasedOnAiWeb.PageController do
  use ScaffoldSuiBasedOnAiWeb, :controller

  def home(conn, _params) do
    render(conn, :home, active_tab: :home)
  end
end
