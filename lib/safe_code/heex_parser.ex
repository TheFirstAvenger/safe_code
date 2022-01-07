defmodule SafeCode.HeexParser do
  def parse_template(expr) do
    options = [
      engine: Phoenix.LiveView.HTMLEngine,
      file: "foo",
      line: 1,
      module: MyModule,
      indentation: 0
    ]

    EEx.compile_string(expr, options)
  end
end
