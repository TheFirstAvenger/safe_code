defmodule SafeCode.HeexParser do
  def parse_template(expr) do
    options =
      if Code.ensure_loaded?(Phoenix.LiveView.TagEngine) do
        [
          engine: Phoenix.LiveView.TagEngine,
          file: "foo",
          line: 1,
          caller: __ENV__,
          source: expr,
          trim: true,
          tag_handler: Phoenix.LiveView.HTMLEngine
        ]
      else
        [
          engine: Phoenix.LiveView.HTMLEngine,
          file: "foo",
          line: 1,
          module: MyModule,
          indentation: 0,
          caller: __ENV__,
          source: expr,
          trim: true
        ]
      end

    EEx.compile_string(expr, options)
  end
end
