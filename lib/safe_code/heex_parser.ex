defmodule SafeCode.HeexParser do
  def parse_template(expr) do
    options = [
      engine: Phoenix.LiveView.TagEngine,
      file: "foo",
      line: 1,
      caller: __ENV__,
      source: expr,
      trim: true,
      tag_handler: Phoenix.LiveView.HTMLEngine
    ]

    EEx.compile_string(expr, options)
  end
end
