defmodule SafeCode.Validator do
  alias SafeCode.HeexParser
  alias SafeCode.Parser
  alias SafeCode.Validator.FunctionValidators

  def validate!(str, opts \\ []) when is_binary(str) do
    str
    |> Parser.parse_string()
    |> validate_quoted(opts)
  end

  def validate_heex!(heex, opts \\ []) when is_binary(heex) do
    heex
    |> HeexParser.parse_template()
    |> validate_quoted(include_phoenix(opts))
  end

  defp include_phoenix(opts) do
    Keyword.update(opts, :extra_function_validators, [SafeCode.Validator.FunctionValidators.Phoenix], fn
      atom when is_atom(atom) -> [SafeCode.Validator.FunctionValidators.Phoenix, atom]
      list when is_list(list) -> [SafeCode.Validator.FunctionValidators.Phoenix | list]
    end)
  end

  defp validate_quoted(quoted, opts) do
    Macro.prewalk(quoted, &validate_node(&1, opts))
  end

  defp validate_node(val, opts) do
    if valid_node?(val, opts) do
      val
    else
      raise "invalid_node:\n\n#{Macro.to_string(val)}\n\nast:\n#{inspect(val)}"
    end
  end

  defp valid_node?(atom, _opts) when is_atom(atom), do: true
  defp valid_node?(int, _opts) when is_integer(int), do: true
  defp valid_node?(binary, _opts) when is_binary(binary), do: true
  defp valid_node?(list, _opts) when is_list(list), do: true
  defp valid_node?({_, _}, _opts), do: true

  defp valid_node?({_, _, nil}, _opts), do: true
  defp valid_node?({variable, _, scope}, _opts) when is_atom(variable) and is_atom(scope), do: true
  defp valid_node?({{_, _, _}, _, _}, _opts), do: true
  defp valid_node?({:., _, [{:__aliases__, _, module_list}, func]}, opts), do: safe_module_function?(Module.concat(module_list), func, opts)
  defp valid_node?({:., _, [module, func]}, opts), do: safe_module_function?(module, func, opts)

  defp valid_node?({function, _meta, args}, opts) when is_atom(function) and is_list(args) do
    FunctionValidators.safe_function?(function, opts)
  end

  defp valid_node?(_, _opts), do: false

  defp safe_module_function?(module, function, opts), do: FunctionValidators.safe_module_function?(module, function, opts)
end
