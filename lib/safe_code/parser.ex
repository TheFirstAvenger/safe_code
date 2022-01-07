defmodule SafeCode.Parser do
  def parse_string(str) do
    Code.string_to_quoted!(str)
  end
end
